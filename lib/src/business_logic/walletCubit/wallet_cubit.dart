import 'package:dio/dio.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/constants/tools/toast.dart';
import 'package:seda_driver/src/models/response/wallet_&_points/points_response.dart';
import 'package:seda_driver/src/services/dio_helper.dart';
import 'package:seda_driver/src/models/response/wallet_&_points/wallet_response.dart';

import '../../models/response/wallet_&_points/points.dart';
import '../../models/response/wallet_&_points/wallet.dart';

part 'wallet_states.dart';

class WalletCubit extends Cubit<WalletStates> {
  WalletCubit() : super(WalletInitial());

  static WalletCubit get(context) => BlocProvider.of(context);

  WalletResponse walletResponse = WalletResponse();
  Wallet wallet = Wallet();

  Future getWallet() async {
    emit(WalletLoading());
    try {
      await DioHelper.getData(url: EndPoints.getWalletData).then((value) {
        logSuccess(value.data.toString());
        walletResponse = WalletResponse.fromJson(value.data);
        wallet = walletResponse.data!.wallet!;
        logWarning(wallet.balance.toString());
        emit(WalletSuccess());
        logSuccess('ssssssssssssssssssssssssss');
      });
    } on DioError catch (dioError) {
      logError("getWallet response error: ${dioError.response}");
      showToast(dioError.message, ToastState.error);
      emit(WalletFailed());
    } catch (e) {
      showToast('error has occurred', ToastState.error);
      logError("getWallet error: $e");
      emit(WalletFailed());
    }
  }

  PointsResponse pointsResponse = PointsResponse();
  Points points = Points();

  Future getPoints() async {
    emit(PointsLoading());
    try {
      await DioHelper.getData(url: EndPoints.getUserPointData).then((value) {
        logSuccess(value.data.toString());
        pointsResponse = PointsResponse.fromJson(value.data);
        points = pointsResponse.data!.points!;
        logWarning(points.toString());
        emit(PointsSuccess());
      });
    } on DioError catch (dioError) {
      logError("getPoints response error: ${dioError.response}");
      showToast(dioError.message, ToastState.error);
      emit(PointsFailed());
    } catch (e) {
      showToast('error has occurred', ToastState.error);
      logError("getPoints error: $e");
      emit(PointsFailed());
    }
  }

  Future refund(
      {required VoidCallback afterSuccess,
      required VoidCallback error,
      required double amount,
      required int orderId}) async {
    try {
      await DioHelper.postData(
          url: EndPoints.addMoneyToWallet,
          body: {'amount': amount, 'order_id': orderId}).then((value) {
        logSuccess(value.data.toString());
        afterSuccess();
      });
    } on DioError catch (dioError) {
      error();
      logError("refund response error: ${dioError.response}");
      showToast(dioError.message, ToastState.error);
    } catch (e) {
      error();
      showToast('error has occurred', ToastState.error);
      logError("refund error: $e");
    }
  }
}
