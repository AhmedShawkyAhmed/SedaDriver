import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:seda_driver/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/views/custom_profile_image_view.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_rich_text.dart';
import 'package:seda_driver/src/presentation/widgets/default_drop_down_menu.dart';
import 'package:seda_driver/src/presentation/widgets/default_text_form_field.dart';
import 'package:sizer/sizer.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({Key? key}) : super(key: key);

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _locationController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _vehicleInfoController = TextEditingController();

  bool _enable = true;

  XFile? _image;

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime(2010),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          primaryColor: AppColors.darkBlue,
          colorScheme: const ColorScheme.light(
            primary: AppColors.darkBlue,
          ),
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        child: child ?? Container(),
      ),
    );
    if (date != null) {
      _dateOfBirthController.text = DateFormat('yyyy-MM-dd', 'en_US').format(date);
    }
  }

  @override
  void initState() {
    super.initState();
    final cubit = AuthCubit.get(context);
    if (cubit.checkRegisterResponse?.checkRegisterData?.savedData != null) {
      _enable = false;
      final data = cubit.checkRegisterResponse!.checkRegisterData!.savedData;
      _fullNameController.text = data!.basicInfo?.name ?? '';
      _emailController.text = data.basicInfo?.email ?? '';
      _dateOfBirthController.text = data.basicInfo?.birth ?? '';
      _locationController.text = data.basicInfo?.address ?? '';
      _image = XFile("${EndPoints.imageBaseUrl}${data.basicInfo?.image ?? ''}");
      _vehicleNumberController.text = data.vehicle?.carNumber ?? '';
      _vehicleInfoController.text =
          "${data.vehicle?.vehicleTypesCompany ?? ''}, "
          "${data.vehicle?.vehicleTypesType ?? ''}, "
          "${data.vehicle?.vehicleTypesModel ?? ''}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.basicInfo),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: IgnorePointer(
                ignoring: !_enable,
                child: CustomProfileImageView(
                  view: !_enable,
                  image: _image?.path,
                  networkImage: !_enable
                      ? Image.network(
                          _image!.path,
                          fit: BoxFit.cover,
                        )
                      : null,
                  selectImage: (image) {
                    Navigator.pop(context);
                    setState(() {
                      _image = image;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            DefaultTextFormField(
              enabled: _enable,
              controller: _fullNameController,
              hintText: context.fullName,
              keyboardType: TextInputType.name,
              prefix: const Icon(
                Icons.person_outline,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            DefaultTextFormField(
              controller: _emailController,
              hintText: context.email,
              keyboardType: TextInputType.emailAddress,
              prefix: const Icon(
                Icons.email_outlined,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            DefaultTextFormField(
              enabled: _enable,
              controller: _vehicleNumberController,
              hintText: context.phone,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              prefix: const Icon(
                Icons.phone_android_rounded,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),

            DefaultTextFormField(
              enabled: true,
              readOnly: true,
              controller: _dateOfBirthController,
              hintText: context.birthDate,
              backgroundColor: AppColors.white,
              onTap: (){
                _selectDate(context);
              },
              prefix: const Icon(
                Icons.calendar_month,
                color: Colors.grey,
              ),
              suffix: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 5.h,
              child: DefaultDropdown<String>(
                hint: "Gender",
                showSearchBox: false,
                items: ['Male','Female'],
                icon: const Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                ),
                onChanged: (val) {},
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 5.h,
              child: DefaultDropdown<String>(
                hint: "Vehicle Brand",
                showSearchBox: true,
                items: ['Ahmed','Shawky'],
                icon: const Icon(
                  Icons.directions_car_rounded,
                  color: Colors.grey,
                ),
                onChanged: (val) {},
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 5.h,
              child: DefaultDropdown<String>(
                hint: "Vehicle Brand",
                showSearchBox: true,
                items: [],
                icon: const Icon(
                  Icons.directions_car_rounded,
                  color: Colors.grey,
                ),
                onChanged: (val) {},
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 5.h,
              child: DefaultDropdown<String>(
                hint: "Vehicle Brand",
                showSearchBox: true,
                items: [],
                icon: const Icon(
                  Icons.directions_car_rounded,
                  color: Colors.grey,
                ),
                onChanged: (val) {},
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 5.h,
              child: DefaultDropdown<String>(
                hint: "Vehicle Brand",
                showSearchBox: true,
                items: ['Ahmed'],
                icon: const Icon(
                  Icons.directions_car_rounded,
                  color: Colors.grey,
                ),
                onChanged: (val) {},
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            IgnorePointer(
              ignoring: !_enable,
              child: DefaultAppButton(
                backgroundColor: _enable ? null : AppColors.grey,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                text: context.next,
                onTap: () {
                  Navigator.pushNamed(context, AppRouterNames.register);
                },
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            DefaultAppRichText(
              children: [
                TextSpan(
                  text: context.customerSupportText,
                ),
                TextSpan(
                  text: context.customerSupport,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.pushNamed(
                          context,
                      AppRouterNames.customerSupport,
                        ),
                  style: const TextStyle(
                    color: AppColors.lightBlue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
              globalTextColor: AppColors.darkGrey,
              globalTextFontSize: 10.sp,
              globalTextFontWeight: FontWeight.w500,
              globalTextAlign: TextAlign.center,
              globalTextHeight: 1.5,
              padding: const EdgeInsets.symmetric(horizontal: 25),
            ),
          ],
        ),
      ),
    );
  }
}
