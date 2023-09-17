import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seda_driver/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/constants/tools/string.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_country_picker_dialog.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:seda_driver/src/presentation/widgets/default_text_form_field.dart';
import 'package:seda_driver/src/presentation/widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  late Country _country;

  @override
  void initState() {
    super.initState();
    _country = CountryPickerUtils.getCountryByPhoneCode('966');
  }

  void _showCountryPicker() => showDialog(
        context: context,
        builder: (context) => CustomCountryPickerDialog(
          onCountryPicked: (Country country) =>
              setState(() => _country = country),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: 100.w,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 30.h,
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          AppAssets.icLogo1,
                        ),
                      ),
                      Center(
                        child: DefaultAppText(
                          text: context.loginGreeting,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 25.h,
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    AppAssets.imgLoginCar,
                    width: 70.w,
                  ),
                ),
                DefaultTextFormField(
                  maxLength: 11,
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp(r'^0+'),
                    ),
                  ],
                  prefix: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: AppColors.darkGrey,
                          width: 1.sp,
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(right: 2.w),
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        onTap: _showCountryPicker,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              CountryPickerUtils.getFlagImageAssetPath(
                                _country.isoCode,
                              ),
                              height: 15.0,
                              width: 25.0,
                              fit: BoxFit.fill,
                              package: "country_pickers",
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            DefaultAppText(
                              text: "+${_country.phoneCode}",
                              fontSize: 10.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  left: 10.w,
                  margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                  hintText: context.phoneNumber,
                ),
                DefaultAppButton(
                  text: context.login,
                  onTap: () {

                  },
                  margin: EdgeInsets.symmetric(horizontal: 14.w),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
