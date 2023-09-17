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
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:seda_driver/src/presentation/widgets/default_text_form_field.dart';
import 'package:seda_driver/src/presentation/widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class VehiclePhotoScreen extends StatefulWidget {
  const VehiclePhotoScreen({Key? key}) : super(key: key);

  @override
  State<VehiclePhotoScreen> createState() => _VehiclePhotoScreenState();
}

class _VehiclePhotoScreenState extends State<VehiclePhotoScreen> {
  XFile? _image;
  bool _enable = true;

  @override
  void initState() {
    super.initState();
    final cubit = AuthCubit.get(context);
    if (cubit.checkRegisterResponse?.checkRegisterData?.flags?.vehicleImage ==
        1) {
      _enable = false;
      final data = cubit.checkRegisterResponse!.checkRegisterData!.savedData;
      _image = XFile(
          "${EndPoints.imageBaseUrl}${data?.vehicleImage?[0].filename ?? ''}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.vehiclePhoto),
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
                  DefaultAppText(
                    text: context.vehiclePhoto,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Image.asset(AppAssets.imgCarPhoto),
                  SizedBox(
                    height: 3.h,
                  ),
                  _image == null
                      ? DefaultTextFormField(
                          controller: TextEditingController(),
                          hintText: context.addPhoto,
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
                                    _image = image;
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
                                    image: _image!.path.contains('http')
                                        ? Image.network(_image!.path).image
                                        : Image.file(
                                            File(
                                              _image!.path,
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
                                width: 2.w,
                              ),
                            if (_enable)
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Image.asset(AppAssets.icRemove),
                                ),
                              ),
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
                backgroundColor: _enable ? null : AppColors.grey,
                margin: EdgeInsets.symmetric(horizontal: 14.w),
                text: context.done,
                onTap: () {
                  if (_image == null) {
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
                          image: _image!,
                          imageType: DriverImageType.vehicleImage,
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
