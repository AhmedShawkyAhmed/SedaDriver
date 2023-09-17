import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/pick_image_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

class CustomProfileImageView extends StatelessWidget {
  const CustomProfileImageView({
    Key? key,
    required this.view,
    this.selectImage,
    this.image,
    this.networkImage,
    this.backgroundColor,
    this.iconColor,
    this.avatarIconPadding,
  }) : super(key: key);

  final Widget? networkImage;
  final String? image;
  final bool view;
  final Function(XFile image)? selectImage;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? avatarIconPadding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 13.h,
          height: 13.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? AppColors.midGrey.withOpacity(0.7),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: networkImage ??
              (image != null
                  ? Image.file(
                      File(
                        image!,
                      ),
                      fit: BoxFit.cover,
                    )
                  : Padding(
                      padding: EdgeInsets.all(avatarIconPadding ?? 15),
                      child: FittedBox(
                        child: Icon(
                          Icons.person,
                          color: iconColor ?? AppColors.white,
                          size: 65,
                        ),
                      ),
                    )),
        ),
        if (!view)
          Positioned(
            top: 9.h,
            right: 1.w,
            child: Material(
              color: AppColors.midBlue,
              type: MaterialType.circle,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(35),
                        topLeft: Radius.circular(35),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (_) => PickImageBottomSheet(
                      selectImage: selectImage!,
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.edit_outlined,
                    color: AppColors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
