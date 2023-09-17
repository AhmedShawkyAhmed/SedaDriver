import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seda_driver/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/constants/tools/string.dart';
import 'package:seda_driver/src/models/request/driver_images_upload_request.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/views/pick_image_bottom_sheet.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_rich_text.dart';
import 'package:seda_driver/src/presentation/widgets/default_text_form_field.dart';
import 'package:seda_driver/src/presentation/widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class NationalIdScreen extends StatefulWidget {
  const NationalIdScreen({Key? key}) : super(key: key);

  @override
  State<NationalIdScreen> createState() => _NationalIdScreenState();
}

class _NationalIdScreenState extends State<NationalIdScreen> {
  XFile? _frontNationalId, _backNationalId;
  bool _enable = true;

  @override
  void initState() {
    super.initState();
    final cubit = AuthCubit.get(context);
    if (cubit.checkRegisterResponse?.checkRegisterData?.flags?.nationalId ==
        1) {
      _enable = false;
      final data = cubit.checkRegisterResponse!.checkRegisterData!.savedData;
      _frontNationalId = XFile(
          "${EndPoints.imageBaseUrl}${data?.nationalId?[0].filename ?? ''}");
      _backNationalId = XFile(
          "${EndPoints.imageBaseUrl}${data?.nationalId?[1].filename ?? ''}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.nationalId,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: AppColors.darkGrey,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Column(
                children: [
                  Image.asset(
                    AppAssets.imgNationalId,
                    fit: BoxFit.cover,
                    width: 90.w,
                    height: 50.w,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  _frontNationalId == null
                      ? DefaultTextFormField(
                          controller: TextEditingController(),
                          hintText: context.frontNational,
                          readOnly: true,
                          borderColor: AppColors.midBlue,
                          height: 6.h,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35),
                                ),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (_) => PickImageBottomSheet(
                                selectImage: (image) {
                                  Navigator.pop(context);
                                  setState(() {
                                    _frontNationalId = image;
                                  });
                                },
                              ),
                            );
                          },
                          expand: true,
                          maxLines: null,
                          hintTextColor: AppColors.midBlue,
                          suffix: const Icon(
                            Icons.add,
                            color: AppColors.midBlue,
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 20.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image:
                                        _frontNationalId!.path.contains('http')
                                            ? Image.network(
                                                _frontNationalId!.path,
                                              ).image
                                            : Image.file(
                                                File(
                                                  _frontNationalId!.path,
                                                ),
                                              ).image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                              ),
                            ),
                            if (_enable)
                              SizedBox(
                                width: 1.w,
                              ),
                            if (_enable)
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _frontNationalId = null;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Image.asset(AppAssets.icRemove),
                                ),
                              )
                          ],
                        ),
                  SizedBox(
                    height: 3.h,
                  ),
                  _backNationalId == null
                      ? DefaultTextFormField(
                          controller: TextEditingController(),
                          hintText: context.backNational,
                          readOnly: true,
                          borderColor: AppColors.midBlue,
                          height: 6.h,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35),
                                ),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (_) => PickImageBottomSheet(
                                selectImage: (image) {
                                  Navigator.pop(context);
                                  setState(() {
                                    _backNationalId = image;
                                  });
                                },
                              ),
                            );
                          },
                          expand: true,
                          maxLines: null,
                          hintTextColor: AppColors.midBlue,
                          suffix: const Icon(
                            Icons.add,
                            color: AppColors.midBlue,
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 20.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image:
                                        _backNationalId!.path.contains('http')
                                            ? Image.network(
                                                _backNationalId!.path,
                                              ).image
                                            : Image.file(
                                                File(
                                                  _backNationalId!.path,
                                                ),
                                              ).image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                              ),
                            ),
                            if (_enable)
                              SizedBox(
                                width: 1.w,
                              ),
                            if (_enable)
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _backNationalId = null;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Image.asset(AppAssets.icRemove),
                                ),
                              )
                          ],
                        ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            IgnorePointer(
              ignoring: !_enable,
              child: DefaultAppButton(
                backgroundColor: !_enable ? AppColors.grey : null,
                margin: EdgeInsets.symmetric(horizontal: 14.w),
                text: context.done,
                onTap: () {
                  if (_frontNationalId == null || _backNationalId == null) {
                    context.fillRequiredFields.toToastWarning();
                    return;
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => WillPopScope(
                        child: const LoadingIndicator(),
                        onWillPop: () => Future.value(false),
                      ),
                    );
                    final driverImagesUploadRequest = DriverImagesUploadRequest(
                      images: [
                        DriverImage(
                          image: _frontNationalId!,
                          imageType: DriverImageType.nationalIdFront,
                        ),
                        DriverImage(
                          image: _backNationalId!,
                          imageType: DriverImageType.nationalIdBack,
                        ),
                      ],
                    );
                    AuthCubit.get(context).uploadDriverImages(
                      driverImagesUploadRequest: driverImagesUploadRequest,
                      afterSuccess: () {
                        AuthCubit.get(context).checkRegister(
                          afterSuccess: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          afterError: () => Navigator.pop(context),
                        );
                      },
                      afterError: () => Navigator.pop(context),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            DefaultAppRichText(
              padding: const EdgeInsets.symmetric(horizontal: 25),
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
            ),
          ],
        ),
      ),
    );
  }
}
