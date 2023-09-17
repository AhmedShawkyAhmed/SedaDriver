// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:seda_driver/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda_driver/src/business_logic/socket_cubit/socket_cubit.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/constants/shared_preference_keys.dart';
import 'package:seda_driver/src/constants/tools/string.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:seda_driver/src/presentation/widgets/loading_indicator.dart';
import 'package:seda_driver/src/services/cache_helper.dart';
import 'package:sizer/sizer.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.phone}) : super(key: key);
  final String phone;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool _error = false;
  String? _otp;
  late Timer _timer;
  int _time = 120;

  String _getTimer(int timeInSeconds) {
    final min = (timeInSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (timeInSeconds % 60).toString().padLeft(2, '0');
    final time = '$min:$sec';
    return time;
  }

  void _initializeTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_time == 0) {
            _timer.cancel();
            _time = 120;
          } else {
            _time--;
          }
        });
      },
    );
  }

  _toRegister() {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, AppRouterNames.register);
  }

  _toHome() {
    AuthCubit.get(context).checkRegister(
      afterSuccess: () async {
        final isCompleted = AuthCubit.get(context)
                .checkRegisterResponse
                ?.checkRegisterData
                ?.complete ==
            1;
        await CacheHelper.saveDataSharedPreference(
          key: SharedPreferenceKeys.isRegistrationCompleted,
          value: isCompleted,
        );
        if (isCompleted) {
          SocketCubit.get(context).getLastOrderStatus(
            afterSuccess: (order) {
              if (order != null) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouterNames.home,
                  arguments: order,
                  (route) => false,
                );
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouterNames.home,
                  (route) => false,
                );
              }
            },
            afterError: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouterNames.home,
              (route) => false,
            ),
          );
        } else {
          Navigator.pushReplacementNamed(context, AppRouterNames.register);
        }
      },
      afterError: () => Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouterNames.home,
        (route) => false,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initializeTimer();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.phoneVerification,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DefaultAppText(
                text: context.enterVerificationCode,
                textAlign: TextAlign.center,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: 3.h,
              ),
              Text.rich(
                TextSpan(
                  text: context.enter4Digits,
                  style: TextStyle(
                    height: 1.5,
                    wordSpacing: 2,
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                  children: [
                    TextSpan(
                      text: widget.phone,
                      style: const TextStyle(
                        color: Color(0xff2185F5),
                      ),
                    )
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 4.h,
              ),
              if (_error)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_outlined,
                      color: AppColors.red,
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    DefaultAppText(
                      text: context.invalidVerificationCode,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.red,
                    ),
                  ],
                ),
              SizedBox(
                height: 4.h,
              ),
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (val) {
                  setState(() {
                    _otp = val;
                  });
                },
                onCompleted: (val) {},
                showCursor: true,
                cursorColor: AppColors.darkGrey,
                pinTheme: PinTheme(
                  activeColor: AppColors.darkGrey,
                  disabledColor: AppColors.darkGrey,
                  errorBorderColor: AppColors.darkGrey,
                  selectedColor: AppColors.darkGrey,
                  inactiveColor: AppColors.darkGrey,
                  borderRadius: BorderRadius.circular(10),
                  shape: PinCodeFieldShape.box,
                  fieldWidth: 12.w,
                  fieldHeight: 6.h,
                ),
                textStyle: TextStyle(
                  fontSize: 12.sp,
                ),
                blinkWhenObscuring: true,
                obscureText: true,
                autoFocus: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 3.h,
              ),
              DefaultAppText(
                text: context.minutesLeft(_getTimer(_time)),
                fontSize: 13.sp,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 3.h,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    if (_timer.isActive) {
                      context.invalidSendCode.toToastWarning();
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return const LoadingIndicator();
                        },
                      );
                      AuthCubit.get(context).verifyFirebasePhone(
                        afterSuccess: () {
                          Navigator.pop(context);
                          _initializeTimer();
                        },
                        afterError: () => Navigator.pop(context),
                        phoneNumber: AuthCubit.get(context).phone!,
                      );
                    }
                  },
                  child: DefaultAppText(
                    text: context.resendCode,
                    color: _time!=120?AppColors.grey:AppColors.lightBlue,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is VerifyingOtpSuccessState) {
                    AuthCubit.get(context).verifyPhone(
                      phone: AuthCubit.get(context).phone!,
                      afterSuccess: () {
                        AuthCubit.get(context).verifyOTP(
                          otp: CacheHelper.getDataFromSharedPreference(
                            key: SharedPreferenceKeys.gistVerifyPhoneOtp,
                          ),
                          toHome: _toHome,
                          toRegister: _toRegister,
                          afterError: () => Navigator.pop(context),
                        );
                      },
                      afterError: () => Navigator.pop(context),
                    );
                  } else if (state is VerifyingOtpFailureState) {
                    Navigator.pop(context);
                    setState(() {
                      _error = true;
                    });
                  }
                },
                child: DefaultAppButton(
                  height: 6.h,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  text: context.continueT,
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_otp?.length != 6) {
                      context.verificationCodeRequired.toToastWarning();
                      return;
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return const LoadingIndicator();
                        },
                      );
                      AuthCubit.get(context).verifyFirebaseOTp(code: _otp!);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
