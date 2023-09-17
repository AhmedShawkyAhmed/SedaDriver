import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/constants/constants_variables.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/shared_preference_keys.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/constants/tools/toast.dart';
import 'package:seda_driver/src/models/request/driver_images_upload_request.dart';
import 'package:seda_driver/src/models/response/auth/check_register_response/check_register_response.dart';
import 'package:seda_driver/src/models/response/auth/profile_response/profile_response_model.dart';
import 'package:seda_driver/src/models/response/auth/profile_response/update_profile_response.dart';
import 'package:seda_driver/src/models/response/auth/register_response/register_response_model.dart';
import 'package:seda_driver/src/models/response/auth/toggle_online_response/toggle_online_response_model.dart';
import 'package:seda_driver/src/models/vehicle_company_type.dart';
import 'package:seda_driver/src/models/response/auth/vehicles_company_types/vehicles_company_types_response_model.dart';
import 'package:seda_driver/src/models/vehicle_color.dart';
import 'package:seda_driver/src/models/vehicle_type.dart';
import 'package:seda_driver/src/models/response/auth/vehicles_types_response/vehicles_types_response_model.dart';
import 'package:seda_driver/src/models/response/auth/verify_orp_response/verify_otp_response_model.dart';
import 'package:seda_driver/src/models/response/auth/verify_phone_response/verify_phone_response_model.dart';
import 'package:seda_driver/src/services/cache_helper.dart';
import 'package:seda_driver/src/services/dio_helper.dart';
import 'package:seda_driver/src/models/response/auth/profile_response/user_model.dart';
import 'package:seda_driver/src/models/request/register_request.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;

  AuthCubit(this._auth) : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  UserModel? currentUser;
  bool? isConnected;
  List<VehicleColor> vehicleColors = [];
  List<VehicleType> vehicleTypes = [];
  List<VehicleCompanyType> vehicleCompanyTypes = [];

  void resetState() => emit(AuthInitial());

  List<String>? phone;
  String? _verId;
  UserCredential? _user;

  Future verifyFirebasePhone({
    required List<String> phoneNumber,
    required Function() afterSuccess,
    required Function() afterError,
  }) async {
    try {
      phone = phoneNumber;
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber.join(''),
        timeout: const Duration(minutes: 1),
        verificationCompleted: (cred) {},
        verificationFailed: (e) {
          showToast(
            'Phone Verification ${e.message}',
            ToastState.error,
          );
          debugPrint('\x1B[31m verifyPhone error message: ${e.message}\x1B[0m');
          afterError();
          if (Platform.isAndroid) {
            emit(VerifyPhoneVerifyErrorState());
          }
        },
        codeSent: (verId, resCode) {
          _verId = verId;
          afterSuccess();
        },
        codeAutoRetrievalTimeout: (verID) {
          if (_user == null) {
            showToast('Phone Verification Timeout', ToastState.error);
            debugPrint('\x1B[31m Phone Verification Timeout\x1B[0m');
            // afterError();
          }
        },
      );
    } catch (e) {
      showToast('Phone Verification Failure', ToastState.error);
      afterError();
    }
  }

  Future verifyFirebaseOTp({
    required String code,
  }) async {
    try {
      emit(VerifyingOtpLoadingState());
      final cred = PhoneAuthProvider.credential(
        verificationId: _verId!,
        smsCode: code,
      );
      _user = await _auth.signInWithCredential(cred);
      if (_user?.user != null) {
        showToast(
          'Phone Verification Success',
          ToastState.success,
        );
        _user?.user?.delete();
        emit(VerifyingOtpSuccessState());
      } else {
        showToast('Invalid OTP', ToastState.error);
        emit(VerifyingOtpFailureState());
      }
    } catch (e) {
      showToast('OTP Verification Failure', ToastState.error);
      debugPrint('\x1B[31m verifyOTp error: $e\x1B[0m');
      emit(VerifyingOtpFailureState());
    }
  }

  Future verifyPhone({
    required List<String> phone,
    required VoidCallback afterSuccess,
    VoidCallback? afterError,
  }) async {
    emit(VerifyPhoneLoading());
    try {
      await DioHelper.postData(
        url: EndPoints.auth,
        body: {
          "dial_code": phone[0],
          "phone": phone[1],
          'type': 'captain',
        },
      ).then((value) {
        logWarning(value.toString());
        final verifyPhoneResponse =
            VerifyPhoneResponseModel.fromJson(value.data);
        CacheHelper.saveDataSharedPreference(
          key: SharedPreferenceKeys.gistVerifyPhoneToken,
          value: verifyPhoneResponse.data?.token,
        );
        CacheHelper.saveDataSharedPreference(
          key: SharedPreferenceKeys.gistVerifyPhoneOtp,
          value: verifyPhoneResponse.data?.otp,
        );
        CacheHelper.saveDataSharedPreference(
          key: SharedPreferenceKeys.gistPhone,
          value: phone[1],
        );
        CacheHelper.saveDataSharedPreference(
          key: SharedPreferenceKeys.gistDialCode,
          value: phone[0],
        );
        emit(VerifyPhoneSuccess());
        afterSuccess();
      });
    } on DioError catch (dioError) {
      logError("verifyPhone Response Error: $dioError");
      logError("verifyPhone Response Error: ${dioError.requestOptions.data}");
      if (dioError.response?.data != null) {
        showToast(dioError.response?.data['message'].toString() ?? "Error!",
            ToastState.error);
      }
      afterError?.call();
      emit(VerifyPhoneProblem());
    } catch (error) {
      emit(VerifyPhoneFail());
      logError(error.toString());
      afterError?.call();
    }
  }

  Future verifyOTP({
    required String otp,
    required VoidCallback toHome,
    required VoidCallback toRegister,
    VoidCallback? afterError,
  }) async {
    emit(VerifyOTPLoading());
    try {
      final token = CacheHelper.getDataFromSharedPreference(
          key: SharedPreferenceKeys.gistVerifyPhoneToken);
      await DioHelper.postData(token: token, url: EndPoints.otp, body: {
        "otp": otp,
      }).then((value) {
        logWarning(value.toString());
        final verifyOtpResponseModel = VerifyOtpResponseModel.fromJson(
          value.data,
        );
        if (verifyOtpResponseModel.data?.user == true) {
          methodChannel.invokeMethod(
              "addToken", verifyOtpResponseModel.data?.token);
          CacheHelper.saveDataSharedPreference(
            key: SharedPreferenceKeys.apiToken,
            value: verifyOtpResponseModel.data?.token,
          );
          toHome();
        } else {
          CacheHelper.saveDataSharedPreference(
            key: SharedPreferenceKeys.gistVerifyOtpToken,
            value: verifyOtpResponseModel.data?.token,
          );
          toRegister();
        }
        emit(VerifyOTPSuccess());
      });
    } on DioError catch (dioError) {
      emit(VerifyOTPProblem());
      logError(dioError.response.toString());
      afterError?.call();
    } catch (error) {
      emit(VerifyOTPFail());
      logError(error.toString());
      afterError?.call();
    }
  }

  Future getVehiclesType() async {
    emit(GetVehiclesTypesLoading());
    try {
      final token = CacheHelper.getDataFromSharedPreference(
        key: SharedPreferenceKeys.gistVerifyOtpToken,
      );
      logSuccess(token);
      await DioHelper.getData(
        token: token,
        url: EndPoints.vehiclesTypes,
      ).then((value) {
        logWarning(value.toString());
        final vehiclesTypesResponseModel =
            VehiclesTypesResponseModel.fromJson(value.data);
        vehicleColors.clear();
        vehicleColors
            .addAll(vehiclesTypesResponseModel.data?.vehicleColor ?? []);
        vehicleTypes.clear();
        vehicleTypes.addAll(vehiclesTypesResponseModel.data?.vehicleType ?? []);
        emit(GetVehiclesTypesSuccess());
      });
    } on DioError catch (dioError) {
      emit(GetVehiclesTypesProblem());
      logError(dioError.response.toString());
    } catch (error) {
      emit(GetVehiclesTypesFail());
      logError(error.toString());
    }
  }

  Future getVehiclesCompanyType({required String company}) async {
    emit(GetVehiclesCompanyTypesLoading());
    try {
      final token = CacheHelper.getDataFromSharedPreference(
        key: SharedPreferenceKeys.gistVerifyOtpToken,
      );
      logSuccess(token);
      await DioHelper.getData(
        token: token,
        url: EndPoints.vehiclesCompanyTypes,
        query: {
          'company': company,
        },
      ).then((value) {
        logWarning(value.toString());
        final vehiclesCompanyTypesResponseModel =
            VehiclesCompanyTypesResponseModel.fromJson(value.data);
        vehicleCompanyTypes.clear();
        vehicleCompanyTypes
            .addAll(vehiclesCompanyTypesResponseModel.data?.vehicleType ?? []);
        emit(GetVehiclesCompanyTypesSuccess());
      });
    } on DioError catch (dioError) {
      emit(GetVehiclesCompanyTypesProblem());
      logError(dioError.response.toString());
    } catch (error) {
      emit(GetVehiclesCompanyTypesFail());
      logError(error.toString());
    }
  }

  Future register({
    required RegisterRequest registerRequest,
    required VoidCallback afterSuccess,
    VoidCallback? afterError,
  }) async {
    emit(RegisterLoading());
    try {
      final token = CacheHelper.getDataFromSharedPreference(
        key: SharedPreferenceKeys.gistVerifyOtpToken,
      );
      logSuccess(token);
      await DioHelper.postData(
        token: token,
        url: EndPoints.register,
        body: registerRequest.toJson(),
        isForm: true,
      ).then((value) {
        final registerResponse = RegisterResponseModel.fromJson(value.data);
        logWarning(registerResponse.data!.token.toString());
        CacheHelper.saveDataSharedPreference(
            key: SharedPreferenceKeys.apiToken,
            value: registerResponse.data!.token);
        methodChannel.invokeMethod("addToken", registerResponse.data?.token);
        emit(RegisterSuccess());
        afterSuccess();
      });
    } on DioError catch (dioError) {
      emit(RegisterProblem());
      if (dioError.response?.data != null) {
        showToast(dioError.response?.data['message'].toString() ?? "Error!",
            ToastState.error);
      }
      logError(dioError.response.toString());
      afterError?.call();
    } catch (error) {
      emit(RegisterFail());
      logError(error.toString());
      afterError?.call();
    }
  }

  CheckRegisterResponse? checkRegisterResponse;

  Future checkRegister({
    required VoidCallback afterSuccess,
    VoidCallback? afterError,
  }) async {
    try {
      emit(CheckRegisterLoadingState());
      String? token;
      if (CacheHelper.getDataFromSharedPreference(
              key: SharedPreferenceKeys.apiToken) ==
          null) {
        token = CacheHelper.getDataFromSharedPreference(
          key: SharedPreferenceKeys.gistVerifyOtpToken,
        );
      }
      await DioHelper.postData(
        token: token,
        url: EndPoints.checkRegister,
      ).then((value) {
        logSuccess("checkRegister: $value");
        checkRegisterResponse = CheckRegisterResponse.fromJson(value.data);
        if (checkRegisterResponse?.checkRegisterData?.complete == 1) {
          CacheHelper.removeData(key: SharedPreferenceKeys.registrationData);
        } else {
          CacheHelper.saveDataSharedPreference(
            key: SharedPreferenceKeys.registrationData,
            value: jsonEncode(
              checkRegisterResponse?.toJson(),
            ),
          );
        }
        afterSuccess();
        emit(CheckRegisterSuccessState());
      });
    } on DioError catch (e) {
      logError("checkRegister Dio Error: $e");
      logError("checkRegister Dio Response Error: ${e.response}");
      afterError?.call();
      emit(CheckRegisterErrorState());
    } catch (e) {
      logError("checkRegister Error: $e");
      afterError?.call();
      emit(CheckRegisterErrorState());
    }
  }

  Future uploadDriverImages({
    required DriverImagesUploadRequest driverImagesUploadRequest,
    required Function() afterSuccess,
    Function()? afterError,
  }) async {
    try {
      emit(UploadDriverImagesLoadingState());
      await DioHelper.postData(
        url: EndPoints.uploadDriverImages,
        body: driverImagesUploadRequest.toJson(),
        isForm: true,
      ).then((value) {
        logSuccess("uploadDriverImages: $value");
        showToast(
          value.data['message'],
          ToastState.success,
        );
        afterSuccess();
        emit(UploadDriverImagesSuccessState());
      });
    } on DioError catch (e) {
      logError("uploadDriverImages Dio Error: $e");
      logError("uploadDriverImages Dio Response Error: ${e.response}");
      afterError?.call();
      emit(UploadDriverImagesErrorState());
    } catch (e) {
      logError("uploadDriverImages Error: $e");
      afterError?.call();
      emit(UploadDriverImagesErrorState());
    }
  }

  Future profile() async {
    emit(ProfileLoading());
    try {
      await DioHelper.getData(
        url: EndPoints.getProfile,
      ).then((value) {
        logWarning("Auth cubit response: $value");
        final profileResponse = ProfileResponseModel.fromJson(value.data);
        currentUser = profileResponse.data;
        isConnected = currentUser?.userBasicInfo!.isOnline;
        emit(ProfileSuccess());
      });
    } on DioError catch (dioError) {
      emit(ProfileProblem());
      logError(dioError.response.toString());
    } catch (error) {
      emit(ProfileFail());
      logError(error.toString());
    }
  }

  Future updateProfile({
    String? name,
    String? nickName,
    String? birthDate,
    String? email,
    String? image,
  }) async {
    String tag = 'AuthCubit - updateProfile - ';
    try {
      emit(UpdateProfileLoading());
      final token = CacheHelper.getDataFromSharedPreference(
        key: SharedPreferenceKeys.apiToken,
      );
      final body = <String, dynamic>{};
      body['name'] = name;
      body['nickName'] = nickName;
      body['birth'] = birthDate;
      body['email'] = email;
      if (image != null) {
        body['image'] = MultipartFile.fromFileSync(
          image,
          filename: image,
        );
      }
      final response = await DioHelper.postData(
        token: token,
        url: EndPoints.updateProfile,
        body: body,
        isForm: true,
      );
      logSuccess(
        '${tag}request: ${(response.requestOptions.data as FormData).fields}',
      );
      logSuccess(
        '${tag}response: $response',
      );
      if (response.statusCode == 200) {
        final updateProfileResponseModel = UpdateProfileResponseModel.fromJson(
          response.data,
        );
        currentUser?.userBasicInfo = updateProfileResponseModel.data;
        emit(UpdateProfileSuccess());
      } else {
        emit(
          UpdateProfileProblem(
            (response.data['message'] as String?)?.replaceAll('api.', '') ??
                'Error Updating Profile Data',
          ),
        );
      }
    } on DioError catch (e) {
      logWarning(
        '${tag}error request end point: ${e.requestOptions.path}',
      );
      logWarning(
        '${tag}error request data: ${e.requestOptions.data}',
      );
      logError(
        '${tag}error response: ${e.response}',
      );
      emit(
        UpdateProfileProblem(
          (e.response?.data['message'] as String?)?.replaceAll('api.', '') ??
              'Error Updating Profile Data',
        ),
      );
    } catch (e) {
      logError('${tag}error: $e');
      emit(UpdateProfileProblem('Error Updating Profile Data'));
    }
  }

  Future toggleOnline({bool? isOnline}) async {
    emit(ToggleOnlineLoading());
    try {
      logWarning(isOnline.toString());
      await DioHelper.postData(
        url: EndPoints.toggleOnline,
        // query: isOnline != null
        //     ? {
        //         'is_online': isOnline == true ? 1 : 0,
        //       }
        //     : null,
      ).then((value) {
        logWarning(value.toString());
        final toggleOnlineResponseModel =
            ToggleOnlineResponseModel.fromJson(value.data);
        isConnected = toggleOnlineResponseModel.data?.isOnline;
        if (isConnected == true) {
          showToast('now you are online', ToastState.success);
        } else {
          showToast('now you are offline', ToastState.success);
        }
        emit(ToggleOnlineSuccess());
      });
    } on DioError catch (dioError) {
      emit(ToggleOnlineProblem());
      logError(dioError.response.toString());
    } catch (error) {
      emit(ToggleOnlineFail());
      logError(error.toString());
    }
  }

  Future sendFCM(
      {required String fcm, required VoidCallback afterSuccess}) async {
    emit(SendFcmLoadingState());
    try {
      await DioHelper.putData(
        url: EndPoints.updateFcm,
        body: {
          'fcm': fcm,
        },
      ).then((value) {
        afterSuccess();
        emit(SendFcmSuccessState());
      });
    } on DioError catch (dioError) {
      emit(SendFcmProblemState());
      logError("sendFCM response error: ${dioError.response}");
      showToast(dioError.message, ToastState.error);
    } catch (error) {
      emit(SendFcmFailureState());
      logError("sendFCM error: $error");
      showToast('error has occurred', ToastState.error);
    }
  }

  Future logout({
    required Function() afterSuccess,
    Function()? afterError,
  }) async {
    String tag = 'AuthCubit - logout - ';
    try {
      emit(LogoutLoading());
      final token = CacheHelper.getDataFromSharedPreference(
        key: SharedPreferenceKeys.apiToken,
      );
      methodChannel.invokeMethod("removeToken");
      final response = await DioHelper.getData(
        url: EndPoints.eLogout,
        token: token,
      );
      logSuccess(
        '${tag}response: $response',
      );
      if (response.statusCode == 200) {
        await CacheHelper.clearData();
        afterSuccess();
        emit(LogoutSuccess());
      } else {
        showToast(
            (response.data['message'] as String?)?.replaceAll('api.', '') ??
                'Error Logging Out',
            ToastState.error);
        afterError?.call();
        emit(
          LogoutProblem(),
        );
      }
    } on DioError catch (e) {
      logWarning(
        '${tag}error request end point: ${e.requestOptions.path}',
      );
      logWarning(
        '${tag}error request data: ${e.requestOptions.data}',
      );
      logError(
        '${tag}error response: ${e.response}',
      );
      showToast(
          (e.response?.data['message'] as String?)?.replaceAll('api.', '') ??
              'Error Logging Out',
          ToastState.error);
      afterError?.call();
      emit(
        LogoutProblem(),
      );
    } catch (e) {
      logError('${tag}error: $e');
      showToast('Error Logging Out', ToastState.error);
      afterError?.call();
      emit(LogoutFail());
    }
  }
}
