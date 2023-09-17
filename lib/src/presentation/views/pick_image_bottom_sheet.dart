import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seda_driver/src/constants/constant_methods.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

class PickImageBottomSheet extends StatelessWidget {
  const PickImageBottomSheet({
    Key? key,
    required this.selectImage,
  }) : super(key: key);

  final Function(XFile image) selectImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              pickImage(
                source: ImageSource.gallery,
                onImageSelect: selectImage,
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.image,
                    color: AppColors.midBlue,
                  ),
                  const Spacer(),
                  DefaultAppText(
                    text: context.gallery,
                    color: AppColors.midBlue,
                    fontSize: 15.sp,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              pickImage(
                source: ImageSource.camera,
                onImageSelect: selectImage,
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.midBlue,
                  ),
                  const Spacer(),
                  DefaultAppText(
                    text: context.camera,
                    color: AppColors.darkBlue,
                    fontSize: 15.sp,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
