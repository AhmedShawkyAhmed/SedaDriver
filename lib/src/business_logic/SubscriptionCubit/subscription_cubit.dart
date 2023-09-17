import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/constants/tools/toast.dart';
import 'package:seda_driver/src/models/response/subscription/subscribed_data.dart';
import 'package:seda_driver/src/services/dio_helper.dart';

import '../../models/response/subscription/check_subscription_model.dart';
import '../../models/response/subscription/subscription.dart';
import '../../models/response/subscription/subscription_response_model.dart';

part 'subscription_states.dart';

class SubscriptionCubit extends Cubit<SubscriptionStates> {
  SubscriptionCubit() : super(SubscriptionInitial());

  static SubscriptionCubit get(BuildContext context) =>
      BlocProvider.of(context);

  SubscriptionResponseModel subscription = SubscriptionResponseModel();

  List<Subscription> subscriptionList = [];

  Future getSubscription() async {
    subscriptionList.clear();
    emit(GetSubscriptionLoading());
    try {
      await DioHelper.getData(url: EndPoints.getSubscription).then((value) {
        logSuccess(value.data.toString());
        subscription = SubscriptionResponseModel.fromJson(value.data);
        subscriptionList
            .addAll(subscription.data?.subscription as Iterable<Subscription>);
        logWarning(subscription.data!.subscription.toString());
        emit(GetSubscriptionSuccess());
        logSuccess('ssssssssssssssssssssssssss');
      });
    } on DioError catch (dioError) {
      logError("getSubscription response error: ${dioError.response}");
      showToast(dioError.message, ToastState.error);
      emit(GetSubscriptionFailed());
    } catch (e) {
      showToast('error has occurred', ToastState.error);
      logError("getSubscription error: $e");
      emit(GetSubscriptionFailed());
    }
  }

  bool subscribed = false;
  bool subscriptionStatus = false;
  int subscriptionId = 0;
  CheckSubscriptionModel checkSubscriptionModel = CheckSubscriptionModel();
  SubscribedData subscribedData = SubscribedData();
  Future checkSubscription() async {
    emit(CheckSubscriptionLoading());
    try {
      await DioHelper.getData(url: EndPoints.checkSubscription).then((value) {
        logSuccess(value.data.toString());
        checkSubscriptionModel = CheckSubscriptionModel.fromJson(value.data);
        subscribed = checkSubscriptionModel.data!.flag!;
        subscriptionStatus = checkSubscriptionModel.data!.activeSubscription!;
        if (subscribed) {
          subscribedData = checkSubscriptionModel.data!.subscribedData!;
          subscriptionId =
              checkSubscriptionModel.data!.subscribedData!.subscriptionsId!;
        }
        logSuccess(
            "checkSubscription response success:${subscribedData.endDate}");
        emit(CheckSubscriptionSuccess());
      });
    } on DioError catch (dioError) {
      logError("checkSubscription response error: ${dioError.response}");
      showToast(dioError.message, ToastState.error);
      emit(CheckSubscriptionFailed());
    } catch (e) {
      showToast('error has occurred', ToastState.error);
      logError("checkSubscription error: $e");
      emit(CheckSubscriptionFailed());
    }
  }

  Future subscribe({
    required int id,
    Function()? afterSuccess,
    Function()? afterError,
  }) async {
    emit(SubscriptionLoading());
    try {
      final body = <String, dynamic>{};
      body['subscriptions_id'] = id;
      final response = await DioHelper.postData(
        url: EndPoints.subscribe,
        body: body,
        isForm: true,
      );
      logSuccess(response.toString());
      emit(SubscriptionSuccess());
      afterSuccess?.call();
    } on DioError catch (dioError) {
      logError("subscribe response error: ${dioError.response}");
      showToast(dioError.message, ToastState.error);
      emit(SubscriptionFailed());
      afterError?.call();
    } catch (e) {
      showToast('error has occurred', ToastState.error);
      logError("subscribe error: $e");
      emit(SubscriptionFailed());
      afterError?.call();
    }
  }

  Future renewSubscription({
    required int id,
    Function()? afterSuccess,
    Function()? afterError,
  }) async {
    emit(SubscriptionLoading());
    try {
      final body = <String, dynamic>{};
      body['subscriptions_id'] = id;
      final response = await DioHelper.postData(
        url: EndPoints.renewSubscription,
        body: body,
        isForm: true,
      );
      logSuccess(response.toString());
      emit(SubscriptionSuccess());
      afterSuccess?.call();
    } on DioError catch (dioError) {
      logError("subscribe response error: ${dioError.response}");
      showToast(dioError.message, ToastState.error);
      emit(SubscriptionFailed());
      afterError?.call();
    } catch (e) {
      showToast('error has occurred', ToastState.error);
      logError("subscribe error: $e");
      emit(SubscriptionFailed());
      afterError?.call();
    }
  }

  Future upgradeSubscription({
    required int id,
    Function()? afterSuccess,
    Function()? afterError,
  }) async {
    emit(SubscriptionLoading());
    try {
      final body = <String, dynamic>{};
      body['subscriptions_id'] = id;
      final response = await DioHelper.postData(
        url: EndPoints.upgradeSubscription,
        body: body,
        isForm: true,
      );
      logSuccess(response.toString());
      emit(SubscriptionSuccess());
      afterSuccess?.call();
    } on DioError catch (dioError) {
      logError("subscribe response error: ${dioError.response}");
      showToast(dioError.message, ToastState.error);
      emit(SubscriptionFailed());
      afterError?.call();
    } catch (e) {
      showToast('error has occurred', ToastState.error);
      logError("subscribe error: $e");
      emit(SubscriptionFailed());
      afterError?.call();
    }
  }
}
