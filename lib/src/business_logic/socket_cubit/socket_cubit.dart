// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seda_driver/src/constants/constants_variables.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/shared_preference_keys.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/constants/tools/toast.dart';
import 'package:seda_driver/src/models/location_model.dart';
import 'package:seda_driver/src/models/message_model.dart';
import 'package:seda_driver/src/models/order_model.dart';
import 'package:seda_driver/src/models/response/google_map_directions_reponse/google_map_directions_reponse.dart';
import 'package:seda_driver/src/models/response/last_order_status_response_model.dart';
import 'package:seda_driver/src/models/response/new_message_event_response.dart';
import 'package:seda_driver/src/models/response/order_response.dart';
import 'package:seda_driver/src/services/cache_helper.dart';
import 'package:seda_driver/src/services/dio_helper.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

part 'socket_state.dart';

class SocketCubit extends Cubit<SocketState> {
  SocketCubit() : super(SocketCubitInitial());

  static SocketCubit get(context) => BlocProvider.of(context);
  OrderResponse? orderResponse;

  List<OrderResponse> orderResponses = [];

  void clearOrdersList() {
    orderResponses = [];
  }

  void changeStatus() {
    emit(SocketLoading());
  }

  void emitState(SocketState state) {
    emit(state);
  }

  late io.Socket socket;

  /// Print Long String
  void printLongString(String text) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach(
          (RegExpMatch match) => debugPrint('\x1B[33m${match.group(0)}\x1B[0m'),
        );
  }

  Future getLastOrderStatus({
    required Function(OrderModel? order) afterSuccess,
    VoidCallback? afterError,
  }) async {
    logSuccess('==============================');
    emit(GetLastOrderStatusLoading());
    try {
      await DioHelper.getData(
        url: EndPoints.epLastStatusOrder,
      ).then((value) {
        logSuccess('getLastOrderStatus response: ${value.data}');
        if (value.statusCode == 200) {
          LastOrderStatusResponse lastOrderStatusResponse =
              LastOrderStatusResponse.fromJson(value.data);
          orderResponse = OrderResponse(
            orderModel: value.data["data"]["order"] != null
                ? OrderModel.fromJson(
                    value.data["data"]["order"],
                  )
                : null,
          );
          if (lastOrderStatusResponse.data?.order != null &&
              lastOrderStatusResponse.data?.order?.status != 'cancel' &&
              lastOrderStatusResponse.data?.order?.status != 'end') {
            afterSuccess(lastOrderStatusResponse.data?.order);
            emit(GetLastOrderStatusSuccess());
          } else {
            // logError(
            //     'errorrrrrrrrr: ${lastOrderStatusResponse.data?.order?.status != 'cancel'}');
            // logError(
            //     'errorrrrrrrrr: ${lastOrderStatusResponse.data?.order != null}');
            afterError?.call();
            emit(GetLastOrderStatusFail());
          }
        }
      });
    } on DioError catch (dioError) {
      logError('getLastOrderStatus response error: ${dioError.response}');
      showToast(dioError.response?.data['message'].toString() ?? "Error!",
          ToastState.error);
      afterError?.call();
      emit(GetLastOrderStatusFail());
    } catch (error) {
      showToast('error has occurred', ToastState.error);
      logError("getLastOrderStatus Unknown Error: $error");
      afterError?.call();
      emit(GetLastOrderStatusFail());
    }
  }

  void connectSocket(id) {
    if (kDebugMode) {
      print('ADHAM+++++_+_+_+_+_+_+_+_+_+_');
    }
    emit(SocketLoading());
    var url = "wss://socket.magdsofteg.xyz";
    socket = io.io(url, <String, dynamic>{
      "transports": ["websocket"],
    });
    logWarning("try to connect to $url");

    socket.onConnect((data) {
      logWarning("Socket Connection Successfully");
      if (orderResponse != null) {
        if (orderResponse?.orderModel?.status == "accept") {
          emit(SocketOrderAcceptedByDriver());
        } else if (orderResponse?.orderModel?.status == "arrived") {
          emit(SocketArrivedOrderFromByDriver());
        } else if (orderResponse?.orderModel?.status == "start") {
          emit(SocketOrderStartedByDriver());
        }
      }
    });
    socket.on("${EndPoints.appKey}.users.$id", (data) async {
      var map = jsonDecode(data);
      log("socket response: $data");
      logWarning("new event gotten: ${map['event']}");
      if (map['event'].toString() == "newOrder") {
        showToast(map['message'].toString(), ToastState.success);
        printLongString(jsonDecode(data).toString());
        orderResponse = OrderResponse.fromJson(map);
        logWarning(
            "ppppppppppppppppppppppppp: ${orderResponse!.orderModel!.price}");
        orderResponses.add(orderResponse!);
        // logWarning("gggggggggggggggggggggg${orderResponses.length}");
        if (state is SocketNewOrder) {
          emit(SocketSecondNewOrder());
        } else {
          emit(SocketNewOrder());
        }
        await service.showOrderNotification(
          id: 0,
          title: orderResponse!.event.toString(),
          body: orderResponse!.message.toString(),
        );
      } else if (map['event'].toString() == 'cancelOrderByUser') {
        logError('Cancel==================User========');
        printLongString(jsonDecode(data).toString());
        showToast('order canceled', ToastState.success);
        orderResponse = OrderResponse.fromJson(map);
        logWarning(orderResponse!.orderModel!.fromLocation.toString());
        await service.showNotification(
          id: 1,
          title: 'The Order has been Canceled'.toString(),
          body: map['message'].toString(),
        );
        if (state is OrderCancelByUser) {
          emit(OrderSecondCancelByUser());
        } else {
          emit(OrderCancelByUser());
        }
      } else if (map['event'].toString() == 'AutoCancelDriver') {
        logError('Cancel==================AutoCancelDriver========');
        printLongString(jsonDecode(data).toString());
        if (orderResponses.isNotEmpty) {
          showToast('order canceled', ToastState.success);
          orderResponse = OrderResponse.fromJson(map);
          logWarning(orderResponse!.orderModel!.fromLocation.toString());
          orderResponses.removeWhere(
            (e) => e.orderModel?.id == orderResponse?.orderModel?.id,
          );
          await service.showNotification(
            id: 1,
            title: 'The Order has been Canceled Automatically'.toString(),
            body: map['message'].toString(),
          );
          if (state is AutoCancelDriver) {
            emit(AutoSecondCancelDriver());
          } else {
            emit(AutoCancelDriver());
          }
        }
      } else if (map['event'].toString() == "you have new message") {
        logSuccess(map['event'].toString());
        log('New Message: $map');
        logSuccess('New Message: $map');
        NewMessageEventResponse newMessage = NewMessageEventResponse.fromJson(
          Map<String, dynamic>.from(map),
        );
        if (newMessage.data != null) {
          await service.showNotification(
            id: 2,
            title: map['event'].toString(),
            body: newMessage.data?.massage ?? 'you have media message',
          );
          emit(state is SocketArrivedOrderFromByDriver
              ? SocketNewMessageAfterArrived(newMessage.data!)
              : SocketNewMessageAfterAccept(newMessage.data!));
        }
      } else if (map['event'].toString() == "ArrivedDriverAlert") {
        logSuccess(map['event'].toString());
        emit(SocketOrderAlertTimeOut());
      } else if (map['event'].toString() == "order gone") {
        orderResponse = null;
        emit(SocketOrderGone());
        logSuccess(map['event'].toString());
      } else if (map['event'].toString() == "newOfferOrder") {
        showToast(map['message'].toString(), ToastState.success);
        printLongString(jsonDecode(data).toString());
        orderResponse = OrderResponse.fromJson(map);
        logWarning(orderResponse!.orderModel!.fromLocation.toString());
        emit(SocketNewOrderOffer());
        await service.showOrderNotification(
          id: 3,
          title: orderResponse!.event.toString(),
          body: orderResponse!.message.toString(),
        );
      } else if (map['event'].toString() == "Trip is recorded") {
        showToast(map['message'].toString(), ToastState.success);
        emit(SocketTripRecording());
      } else if (map['event'].toString() == "acceptOrder") {
        showToast(map['message'].toString(), ToastState.success);
        printLongString(jsonDecode(data).toString());
        emit(SocketAcceptOfferByUser());
      } else if (map['event'].toString() == "newBlockOrder") {
        showToast(map['message'].toString(), ToastState.success);
        printLongString("HoursNewOrder: $map");
        orderResponse = OrderResponse.fromJson(map);
        logWarning(orderResponse!.orderModel!.fromLocation.toString());
        await service.showOrderNotification(
          id: 4,
          title: orderResponse!.event.toString(),
          body: orderResponse!.message.toString(),
        );
        emit(SocketNewHoursOrder());
      } else if (map['event'].toString() == "userAddNewDropOff") {
        final newDropOff = LocationModel.fromJson(map['data']);
        orderResponse!.orderModel!.toLocation!.add(newDropOff);
        if (state is SocketOrderStartedByDriver) {
          if (state is UserAddedDropOffStarted) {
            emit(UserAddedDropOffSecondStarted());
          } else {
            emit(UserAddedDropOffStarted());
          }
        } else if (state is SocketArrivedOrderFromByDriver) {
          if (state is UserAddedDropOffArrived) {
            emit(UserAddedDropOffSecondArrived());
          } else {
            emit(UserAddedDropOffArrived());
          }
        } else {
          emit(SocketOrderAcceptedByDriver());
        }
        await service.showNotification(
          id: 5,
          title: map['event'].toString(),
          body: map['message'].toString(),
        );
      }
    });
    socket.onConnectError((data) {
      logError(" socket.onConnectError ${data.toString()}");
      emit(SocketFailure());
    });

    socket.onError((data) {
      logError(" socket.onError");
      emit(SocketFailure());
    });

    socket.on("message", (data) {
      logWarning("message");
    });
  }

  Future<void> sendLocationToUser(data) async {
    try {
      await Dio(BaseOptions(
              headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Accept-Language': CacheHelper.getDataFromSharedPreference(
                key: SharedPreferenceKeys.appLanguage),
          },
              baseUrl: "https://socket.magdsofteg.xyz/",
              receiveDataWhenStatusError: true))
          .post("emit", data: data);
      logWarning('goooood');
    } on DioError catch (e) {
      logError('+++++++++++++++++$e');
      logError('__________${e.response!.data}');
      logError('__________${e.response}');
      showToast(e.message, ToastState.error);
    } catch (e) {
      logError('=============$e');
      showToast('Error when send location to user', ToastState.error);
    }
  }

  Future<GoogleMapDirections?> getDirections(
    LatLng origin,
    List<LatLng> wayPoint,
  ) async {
    try {
      logError(
          "destination: ${wayPoint.last.latitude},${wayPoint.last.longitude}");
      logError("origin: ${origin.latitude},${origin.longitude}");
      final uri = Uri.https(
        "maps.googleapis.com",
        "/maps/api/directions/json",
        {
          "destination": "${wayPoint.last.latitude},${wayPoint.last.longitude}",
          "origin": "${origin.latitude},${origin.longitude}",
          if (wayPoint.length > 1)
            "waypoints": wayPoint
                .sublist(0, wayPoint.length - 1)
                .map(
                  (e) => "${e.latitude},${e.longitude}",
                )
                .join(
                  "|",
                ),
          "key": EndPoints.googleMapKey,
          "mode": "driving"
        },
      );
      final response = await DioHelper.dio?.getUri(uri);
      log(response.toString());
      if (response?.statusCode == 200) {
        final model = GoogleMapDirections.fromJson(response!.data);
        if (model.status == "OK") {
          return model;
        }
      }
    } catch (e) {
      logError('============$e');
    }
    return null;
  }

  bool isRecordingTrip = false;
  bool isRecordingTripCompleted = false;
  late RecorderController recorderController;

  Future sendRecord({
    required String mediaFile,
    required Function() afterSuccess,
  }) async {
    emit(SendRecordLoading());
    try {
      var formData = {
        "mediaable_type": "order",
        "mediaable_id": orderResponse?.orderModel?.id.toString(),
        'image': await MultipartFile.fromFile(
          mediaFile,
        ),
        'type': "orderVoice",
      };
      await DioHelper.postData(
        url: EndPoints.epSendRecord,
        body: formData,
        isForm: true,
      ).then((value) {
        logSuccess("SendRecord Response: $value");
        afterSuccess();
        emit(SendRecordSuccess());
      });
    } on DioError catch (dioError) {
      logError("SendRecord Error request: ${dioError.requestOptions}");
      logError("SendRecord Error Response: ${dioError.response}");
      emit(SendRecordFail());
    } catch (error) {
      logError("SendRecord Unknown Error: $error");
      emit(SendRecordFail());
    }
  }
}
