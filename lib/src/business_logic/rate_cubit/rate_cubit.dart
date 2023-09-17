import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/constants/tools/toast.dart';
import 'package:seda_driver/src/services/dio_helper.dart';

part 'rate_state.dart';

class RateCubit extends Cubit<RateState> {
  RateCubit() : super(RateInitial());

  static RateCubit get(context) => BlocProvider.of(context);

  Future addRate({
    required int userId,
    required int rate,
    required String comment,
    required VoidCallback afterSuccess,
    VoidCallback? afterError,
  }) async {
    emit(AddRateLoading());
    try {
      await DioHelper.postData(
        url: EndPoints.addRate,
        body: {
          "rate": rate,
          "rateable_type": "User",
          "rateable_id": userId,
          "comment": comment,
        },
      ).then((value) {
        showToast(
          value.data['message'].toString(),
          ToastState.success,
        );
        emit(AddRateSuccess());
        afterSuccess();
      });
    } on DioError catch (dioError) {
      afterError?.call();
      emit(AddRateFail());
      logError(dioError.toString());
    } catch (error) {
      afterError?.call();
      emit(AddRateFail());
      logError(error.toString());
    }
  }
}
