import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/constants/tools/toast.dart';
import 'package:seda_driver/src/models/order_model.dart';
import 'package:seda_driver/src/models/orders_history.dart';
import 'package:seda_driver/src/models/response/end_order.dart';
import 'package:seda_driver/src/models/response/order_details.dart';
import 'package:seda_driver/src/services/dio_helper.dart';

import '../../models/response/driver_statistics.dart';
import '../../models/response/earnings/daily_earning.dart';
import '../../models/response/earnings/earnings_model.dart';
import '../../models/response/earnings/today_earning.dart';
import '../../models/response/earnings/today_earning_statistics.dart';
import '../../models/response/statistics.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  static OrdersCubit get(context) => BlocProvider.of(context);

  void resetState() => emit(OrdersInitial());

  Future sendOffer({
    required int orderId,
    required double price,
    required VoidCallback afterSuccess,
    VoidCallback? afterError,
  }) async {
    emit(OrdersSendOfferLoading());
    try {
      await DioHelper.postData(url: EndPoints.sendOffer, body: {
        "order_id": orderId,
        "price": price,
      }).then((value) {
        logWarning(value.data["message"].toString());
        showToast(
          value.data["message"].toString(),
          ToastState.success,
        );
        logSuccess("sendOffer: ${value.data}");
        afterSuccess();
        emit(OrdersSendOfferSuccess());
      });
    } on DioError catch (dioError) {
      emit(OrdersSendOfferFail());
      if (dioError.response?.data['message'] != null) {
        showToast(
          dioError.response?.data['message'].toString() ?? "Error!",
          ToastState.error,
        );
      }
      afterError?.call();
      logError(dioError.response.toString());
    } catch (error) {
      emit(OrdersSendOfferFail());
      afterError?.call();
      logError(error.toString());
    }
  }

  Future acceptedByDriver({
    required int orderId,
    required VoidCallback afterSuccess,
    VoidCallback? afterError,
  }) async {
    emit(OrdersAcceptLoading());
    try {
      await DioHelper.postData(url: EndPoints.acceptOrderByDriver, body: {
        "orderId": orderId,
      }).then((value) {
        logWarning(value.data["message"].toString());
        showToast(
          value.data["message"].toString(),
          ToastState.success,
        );
        logSuccess("acceptedByDriver: ${value.data}");
        afterSuccess();
      });
    } on DioError catch (dioError) {
      emit(OrdersAcceptFail());
      if (dioError.response?.data['message'] != null) {
        showToast(
          dioError.response?.data['message'].toString() ?? "Error!",
          ToastState.error,
        );
      }
      logError(dioError.response.toString());
      afterError?.call();
    } catch (error) {
      emit(OrdersAcceptFail());
      logError(error.toString());
      afterError?.call();
    }
  }

  Future startedByDriver({
    required int orderId,
    required VoidCallback afterSuccess,
    VoidCallback? afterError,
  }) async {
    emit(OrdersStartLoading());
    try {
      await DioHelper.postData(url: EndPoints.startOrderByDriver, body: {
        "orderId": orderId,
      }).then((value) {
        logWarning(value.data["message"].toString());
        logSuccess("startedByDriver: ${value.data}");
        afterSuccess();
        emit(OrdersStartSuccess());
      });
    } on DioError catch (dioError) {
      logError(dioError.response!.statusCode.toString());
      emit(OrdersStartFail());
      if (dioError.response?.data['message'] != null) {
        showToast(
          dioError.response?.data['message'].toString() ?? "Error!",
          ToastState.error,
        );
      }
      afterError?.call();
      logError(dioError.response.toString());
    } catch (error) {
      afterError?.call();
      emit(OrdersStartFail());
      logError(error.toString());
    }
  }

  Future arrivedOrderFromByDriver({
    required int orderId,
    required double lat,
    required double lon,
    required VoidCallback afterSuccess,
    VoidCallback? afterError,
  }) async {
    emit(ArrivedOrderFromByDriverLoading());
    try {
      await DioHelper.postData(url: EndPoints.arrivedOrderFromByDriver, body: {
        "orderId": orderId,
        "latitude": lat,
        "Longitude": lon,
      }).then((value) {
        logWarning(value.data["message"].toString());
        logSuccess("arrivedOrderFromByDriver: ${value.data}");
        afterSuccess();
        emit(ArrivedOrderFromByDriverSuccess());
      });
    } on DioError catch (dioError) {
      logError(dioError.response!.statusCode.toString());
      emit(ArrivedOrderFromByDriverFail());
      if (dioError.response?.data['message'] != null) {
        showToast(
          dioError.response?.data['message'].toString() ?? "Error!",
          ToastState.error,
        );
      }
      afterError?.call();
      logError(dioError.response.toString());
    } catch (error) {
      afterError?.call();
      emit(ArrivedOrderFromByDriverFail());
      logError(error.toString());
    }
  }

  Future canceledByDriver({
    required int orderId,
    required String cancelReason,
    required VoidCallback afterSuccess,
    VoidCallback? afterError,
  }) async {
    emit(OrdersCancelLoading());
    try {
      await DioHelper.postData(url: EndPoints.cancelOrderByDriver, body: {
        "orderId": orderId,
        "cancel_reason": cancelReason,
      }).then((value) {
        logWarning(value.data["message"].toString());
        logSuccess("canceledByDriver: ${value.data}");
        showToast(
          value.data["message"].toString(),
          ToastState.success,
        );
        afterSuccess();
        emit(OrdersCancelSuccess());
      });
    } on DioError catch (dioError) {
      emit(OrdersCancelFail());
      if (dioError.response?.data['message'] != null) {
        showToast(
          dioError.response?.data['message'].toString() ?? "Error",
          ToastState.error,
        );
      }
      afterError?.call();
      logError(dioError.response.toString());
    } catch (error) {
      emit(OrdersCancelFail());
      afterError?.call();
      logError(error.toString());
    }
  }

  EndOrderResponse? endOrderResponse;
  List<double> lngLine = [];
  List<double> latLine = [];

  Future endedByDriver({
    required int orderId,
    required Function(OrderModel orderModel) afterSuccess,
    VoidCallback? afterError,
  }) async {
    emit(OrdersEndLoading());
    try {
      await DioHelper.postData(url: EndPoints.endOrderByDriver, body: {
        "orderId": orderId,
        "long_line": lngLine,
        "lat_line": latLine,
      }).then((value) {
        logWarning("endedByDriver response: $value");
        endOrderResponse = EndOrderResponse.fromJson(value.data);
        showToast(
          value.data["message"].toString(),
          ToastState.success,
        );
        afterSuccess(endOrderResponse!.data![0]);
        emit(OrdersEndSuccess());
      });
    } on DioError catch (dioError) {
      emit(OrdersEndFail());
      if (dioError.response?.data['message'] != null) {
        showToast(
          dioError.response?.data['message'].toString() ?? "Error!",
          ToastState.error,
        );
      }
      afterError?.call();
      logError("endedByDriver error: ${dioError.response}");
    } catch (error) {
      emit(OrdersEndFail());
      afterError?.call();
      logError("endedByDriver error: $error");
    }
  }

  Future shareTrip({
    required int orderId,
    required double lat,
    required double lon,
    VoidCallback? afterSuccess,
    VoidCallback? afterError,
  }) async {
    emit(ShareTripLoading());
    try {
      logWarning("orderIddddddddddddddddddd $orderId");
      await DioHelper.postData(url: EndPoints.shareTrip, body: {
        "order_id": orderId,
        "lat": lat,
        "lng": lon,
      }).then((value) {
        logWarning("ShareTrip response: $value");
        emit(ShareTripSuccess());
      });
    } on DioError catch (dioError) {
      emit(ShareTripFail());
      afterError?.call();
      logError("ShareTrip error: ${dioError.response}");
    } catch (error) {
      emit(ShareTripFail());
      afterError?.call();
      logError("ShareTrip error: $error");
    }
  }

  Future addMoneyToWallet({
    required int orderId,
    required double amount,
    VoidCallback? afterSuccess,
    VoidCallback? afterError,
  }) async {
    emit(AddMoneyToWalletLoading());
    try {
      logWarning("addMoneyToWallet $orderId");
      await DioHelper.postData(url: EndPoints.addMoneyToWallet, body: {
        "order_id": orderId,
        "amount": amount,
      }).then((value) {
        logWarning("addMoneyToWallet response: $value");
        emit(AddMoneyToWalletSuccess());
        afterSuccess?.call();
      });
    } on DioError catch (dioError) {
      emit(AddMoneyToWalletFail());
      afterError?.call();
      logError("addMoneyToWallet error: ${dioError.response}");
    } catch (error) {
      emit(AddMoneyToWalletFail());
      afterError?.call();
      logError("addMoneyToWallet error: $error");
    }
  }

  OrdersHistory ordersHistory = OrdersHistory();
  int pages = 0;

  Future getHistory(
      {required VoidCallback afterSuccess, int? page, String? date}) async {
    if (page == null) ordersHistory = OrdersHistory();
    emit(GetOrderHistoryLoadingState());
    try {
      await DioHelper.getData(
          url: EndPoints.historyOrder,
          query: {'page': page, 'per_page': 5, 'date': date}).then((value) {
        if (page == null) {
          ordersHistory = OrdersHistory.fromJson(value.data);
          pages = ordersHistory.data.pages;
          logSuccess('-----------$pages');
          logSuccess('-----------${ordersHistory.data.orders.length}');
        } else {
          final newOrdersHistory = OrdersHistory.fromJson(value.data);
          ordersHistory.data.orders.addAll(newOrdersHistory.data.orders);
        }
        afterSuccess();
        emit(GetOrderHistorySuccessState());
      });
    } on DioError catch (dioError) {
      emit(GetOrderHistoryProblemState());
      showToast(dioError.message, ToastState.error);
      logError("getHistory response error: ${dioError.response}");
    } catch (error) {
      emit(GetOrderHistoryFailureState());
      logError("getHistory error: $error");
      showToast('error has occurred', ToastState.error);
    }
  }

  OrderDetails? orderDetails;

  Future getOrderDetails(
      {required VoidCallback afterSuccess,
      int? id,
      required void Function() afterError}) async {
    emit(GetOrderDetailsLoadingState());
    try {
      await DioHelper.postData(
          url: EndPoints.getMyOrders, body: {'order_id': id}).then((value) {
        log(value.data.toString());
        orderDetails = OrderDetails.fromJson(value.data);
        afterSuccess();
        emit(GetOrderDetailsSuccessState());
      });
    } on DioError catch (dioError) {
      emit(GetOrderDetailsProblemState());
      afterError();
      logError('getOrderDetails response error: ${dioError.response}');
      showToast(dioError.message, ToastState.error);
    } catch (error) {
      emit(GetOrderDetailsFailureState());
      afterError();
      logError('getOrderDetails error: $error');
      showToast('error has occurred', ToastState.error);
    }
  }

  DriverStatistics driverStatistics = DriverStatistics();
  Statistics statistics = Statistics();

  Future getDriverStatistics({
    VoidCallback? afterSuccess,
    VoidCallback? afterError,
  }) async {
    emit(GetDriverStatisticsLoadingState());
    try {
      await DioHelper.getData(url: EndPoints.getDriverStatistics).then((value) {
        driverStatistics = DriverStatistics.fromJson(value.data);
        statistics = driverStatistics.data!;
        logSuccess('-----------$driverStatistics');
        afterSuccess?.call();
        emit(GetDriverStatisticsSuccessState());
      });
    } on DioError catch (dioError) {
      afterError?.call();
      emit(GetDriverStatisticsProblemState());
      showToast(dioError.message, ToastState.error);
      logError("getStatistics response error: ${dioError.response}");
    } catch (error) {
      afterError?.call();
      emit(GetDriverStatisticsFailureState());
      logError("getStatistics error: $error");
      showToast('error has occurred', ToastState.error);
    }
  }

  EarningsModel driverEarnings = EarningsModel();
  DailyEarning? dailyEarning = DailyEarning();
  List<DailyEarning>? previousEarning = [];
  Future getDriverEarnings({
    VoidCallback? afterSuccess,
    VoidCallback? afterError,
  }) async {
    emit(GetDriverEarningsLoadingState());
    try {
      await DioHelper.getData(url: EndPoints.getDriverEarnings).then((value) {
        driverEarnings = EarningsModel.fromJson(value.data);
        dailyEarning = driverEarnings.data!.dailyEarning;
        previousEarning = driverEarnings.data!.previousEarning;
        logSuccess('-----------$dailyEarning');
        afterSuccess?.call();
        emit(GetDriverEarningsSuccessState());
      });
    } on DioError catch (dioError) {
      afterError?.call();
      emit(GetDriverEarningsProblemState());
      showToast(dioError.message, ToastState.error);
      logError("getEarnings response error: ${dioError.response}");
    } catch (error) {
      afterError?.call();
      emit(GetDriverEarningsFailureState());
      logError("getEarnings error: $error");
      showToast('error has occurred', ToastState.error);
    }
  }

  TodayEarningStatistics todayEarningStatistics = TodayEarningStatistics();
  TodayEarning? dailyEarningStatistics = TodayEarning();
  Future getTodayEarningStatistics({
    VoidCallback? afterSuccess,
    VoidCallback? afterError,
  }) async {
    emit(GetTodayEarningStatisticsLoadingState());
    try {
      await DioHelper.getData(url: EndPoints.getDriverTodayEarnings)
          .then((value) {
        todayEarningStatistics = TodayEarningStatistics.fromJson(value.data);
        dailyEarningStatistics = todayEarningStatistics.data!.dailyEarning;
        logSuccess('-----------$dailyEarningStatistics');
        afterSuccess?.call();
        emit(GetTodayEarningStatisticsSuccessState());
      });
    } on DioError catch (dioError) {
      afterError?.call();
      emit(GetTodayEarningStatisticsProblemState());
      showToast(dioError.message, ToastState.error);
      logError("TodayEarningStatistics response error: ${dioError.response}");
    } catch (error) {
      afterError?.call();
      emit(GetTodayEarningStatisticsFailureState());
      logError("TodayEarningStatistics error: $error");
      showToast('error has occurred', ToastState.error);
    }
  }
}
