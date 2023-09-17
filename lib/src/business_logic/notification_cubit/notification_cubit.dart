import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/services/dio_helper.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  static NotificationCubit get(BuildContext context) =>
      BlocProvider.of(context);

  final _globalTag = 'NotificationCubit';

  Future getAllNotifications({
    Function()? onSuccess,
    Function()? onError,
  }) async {
    final localTag = '$_globalTag - getAllNotifications';
    try {
      emit(NotificationsGetAllLoadingState());
      final response = await DioHelper.getData(
        url: EndPoints.getAllNotifications,
      );
      if (response.statusCode == 200) {
        logSuccess('$localTag - response: ${response.data}');
        //TODO response decoding
        emit(NotificationsGetAllSuccessState());
        onSuccess?.call();
      } else {
        logError('$localTag - response error: ${response.data}');
        emit(NotificationsGetAllFailureState());
        onError?.call();
      }
    } on DioError catch (e) {
      logError('$localTag - response error: ${e.response}');
      emit(NotificationsGetAllFailureState());
      onError?.call();
    } catch (e) {
      logError('$localTag - error: $e');
      emit(NotificationsGetAllFailureState());
      onError?.call();
    }
  }

  Future getSingleNotification({
    required int id,
    Function()? onSuccess,
    Function()? onError,
  }) async {
    final localTag = '$_globalTag - getSingleNotification';
    try {
      emit(NotificationsGetSingleLoadingState());
      final response = await DioHelper.getData(
        url: '${EndPoints.getSingleNotification}/$id',
      );
      if (response.statusCode == 200) {
        logSuccess('$localTag - response: ${response.data}');
        //TODO response decoding
        emit(NotificationsGetSingleSuccessState());
        onSuccess?.call();
      } else {
        logError('$localTag - response error: ${response.data}');
        emit(NotificationsGetSingleFailureState());
        if (onError != null) {
          onError();
        }
      }
    } on DioError catch (e) {
      logError('$localTag - response error: ${e.response}');
      emit(NotificationsGetSingleFailureState());
      onError?.call();
    } catch (e) {
      logError('$localTag - error: $e');
      emit(NotificationsGetSingleFailureState());
      onError?.call();
    }
  }

  Future markAllNotificationsAsRead({
    Function()? onSuccess,
    Function()? onError,
  }) async {
    final localTag = '$_globalTag - markAllNotificationsAsRead';
    try {
      emit(NotificationsMarkAllAsReadLoadingState());
      final response = await DioHelper.putData(
        url: EndPoints.markAllNotificationsAsRead,
        body: {},
      );
      if (response.statusCode == 200) {
        logSuccess('$localTag - response: ${response.data}');
        //TODO response decoding
        emit(NotificationsMarkAllAsReadSuccessState());
        onSuccess?.call();
      } else {
        logError('$localTag - response error: ${response.data}');
        emit(NotificationsMarkAllAsReadFailureState());
        if (onError != null) {
          onError();
        }
      }
    } on DioError catch (e) {
      logError('$localTag - response error: ${e.response}');
      emit(NotificationsMarkAllAsReadFailureState());
      onError?.call();
    } catch (e) {
      logError('$localTag - error: $e');
      emit(NotificationsMarkAllAsReadFailureState());
      onError?.call();
    }
  }

  Future markSingleNotificationAsRead({
    required int id,
    Function()? onSuccess,
    Function()? onError,
  }) async {
    final localTag = '$_globalTag - markSingleNotificationAsRead';
    try {
      emit(NotificationsMarkSingleAsReadLoadingState());
      final response = await DioHelper.getData(
        url: '${EndPoints.markSingleNotificationsAsRead}/$id',
      );
      if (response.statusCode == 200) {
        logSuccess('$localTag - response: ${response.data}');
        //TODO response decoding
        emit(NotificationsMarkSingleAsReadSuccessState());
        onSuccess?.call();
      } else {
        logError('$localTag - response error: ${response.data}');
        emit(NotificationsMarkSingleAsReadFailureState());
        if (onError != null) {
          onError();
        }
      }
    } on DioError catch (e) {
      logError('$localTag - response error: ${e.response}');
      emit(NotificationsMarkSingleAsReadFailureState());
      onError?.call();
    } catch (e) {
      logError('$localTag - error: $e');
      emit(NotificationsMarkSingleAsReadFailureState());
      onError?.call();
    }
  }
}
