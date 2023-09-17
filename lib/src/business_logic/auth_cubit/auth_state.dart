part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class VerifyPhoneLoading extends AuthState {}

class VerifyPhoneProblem extends AuthState {}

class VerifyPhoneSuccess extends AuthState {}

class VerifyPhoneFail extends AuthState {}

class VerifyOTPLoading extends AuthState {}

class VerifyOTPProblem extends AuthState {}

class VerifyOTPSuccess extends AuthState {}

class VerifyOTPFail extends AuthState {}

class GetVehiclesTypesLoading extends AuthState {}

class GetVehiclesTypesProblem extends AuthState {}

class GetVehiclesTypesSuccess extends AuthState {}

class GetVehiclesTypesFail extends AuthState {}

class GetVehiclesCompanyTypesLoading extends AuthState {}

class GetVehiclesCompanyTypesProblem extends AuthState {}

class GetVehiclesCompanyTypesSuccess extends AuthState {}

class GetVehiclesCompanyTypesFail extends AuthState {}

class RegisterLoading extends AuthState {}

class RegisterProblem extends AuthState {}

class RegisterSuccess extends AuthState {}

class RegisterFail extends AuthState {}

class ProfileLoading extends AuthState {}

class ProfileProblem extends AuthState {}

class ProfileSuccess extends AuthState {}

class ProfileFail extends AuthState {}

class UpdateProfileLoading extends AuthState {}

class UpdateProfileProblem extends AuthState {
  final String message;

  UpdateProfileProblem(this.message);
}

class UpdateProfileSuccess extends AuthState {}

class UpdateProfileFail extends AuthState {}

class ToggleOnlineLoading extends AuthState {}

class ToggleOnlineProblem extends AuthState {}

class ToggleOnlineSuccess extends AuthState {}

class ToggleOnlineFail extends AuthState {}

class LogoutLoading extends AuthState {}

class LogoutProblem extends AuthState {}

class LogoutSuccess extends AuthState {}

class LogoutFail extends AuthState {}

class SendFcmLoadingState extends AuthState {}

class SendFcmSuccessState extends AuthState {}

class SendFcmProblemState extends AuthState {}

class SendFcmFailureState extends AuthState {}

class VerifyPhoneCodeReceivedState extends AuthState {
  final String code;
  VerifyPhoneCodeReceivedState(this.code);
}

class VerifyPhoneVerifiedState extends AuthState {}

class VerifyPhoneVerifyErrorState extends AuthState {}

class VerifyingOtpLoadingState extends AuthState {}

class VerifyingOtpSuccessState extends AuthState {}

class VerifyingOtpFailureState extends AuthState {}

class CheckRegisterLoadingState extends AuthState {}

class CheckRegisterSuccessState extends AuthState {}

class CheckRegisterErrorState extends AuthState {}

class UploadDriverImagesLoadingState extends AuthState {}

class UploadDriverImagesSuccessState extends AuthState {}

class UploadDriverImagesErrorState extends AuthState {}
