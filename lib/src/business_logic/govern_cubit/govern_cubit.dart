import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/constants/tools/toast.dart';
import 'package:seda_driver/src/services/dio_helper.dart';
import 'package:seda_driver/src/models/request/govern_create_request_model.dart';

part 'govern_state.dart';

class GovernCubit extends Cubit<GovernState> {
  GovernCubit() : super(GovernInitial());

  static GovernCubit get(BuildContext context) => BlocProvider.of(context);

  final _myGovernTrips = [];

  List get myGovernTrips => _myGovernTrips;

  Future createGovernTrip({
    required GovernCreateRequestModel governCreateRequestModel,
    required Function() afterSuccess,
    required Function() afterError,
  }) async {
    emit(GovernTripCreateLoadingState());
    try {
      final response = await DioHelper.postData(
        url: EndPoints.makeShardOrder,
        body: governCreateRequestModel.toJson(),
        isForm: true,
      );
      logWarning("GovernCubit createGovernTrip response: $response");
      if (response.statusCode == 200) {
        showToast(
          response.statusMessage ?? 'GovernTrip creation successful',
          ToastState.success,
        );
        afterSuccess();
        emit(GovernTripCreateSuccessState());
      } else {
        showToast(
            response.data['message'] ?? 'Creating Govern Trip Server Error',
            ToastState.error);
        afterError();
        emit(GovernTripCreateFailureState());
      }
    } on DioError catch (e) {
      logError("GovernCubit createGovernTrip error response: ${e.response}");
      showToast(
          e.response?.data['message'] ?? 'Creating Govern Trip Server Error',
          ToastState.error);
      afterError();
      emit(GovernTripCreateFailureState());
    } catch (e) {
      logError("GovernCubit createGovernTrip error: $e");
      showToast(
        'Error creating Govern Trip',
        ToastState.error,
      );
      afterError();
      emit(GovernTripCreateFailureState());
    }
  }
}
