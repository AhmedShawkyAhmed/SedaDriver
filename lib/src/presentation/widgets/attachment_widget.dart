import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/pick_image_bottom_sheet.dart';
import 'package:seda_driver/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class AttachmentWidget extends StatefulWidget {
  final XFile? image;
  final String? title;
  final VoidCallback onSelect;

  const AttachmentWidget({
    this.image,
    this.title,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DefaultText(
          text: widget.title ?? "",
          fontWeight: FontWeight.w400,
        ),
        SizedBox(
          width: 22.w,
          height: 8.h,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional.center,
                child: Container(
                  width: 21.w,
                  height: 7.h,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.midGrey.withOpacity(0.7),
                  ),
                  child: widget.image != null
                      ? Image.file(
                    File(
                      widget.image!.path,
                    ),
                    fit: BoxFit.cover,
                  )
                      : const Padding(
                    padding: EdgeInsets.all(15),
                    child: FittedBox(
                      child: Icon(
                        Icons.person,
                        color: AppColors.white,
                        size: 65,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(100)),
                child: Icon(
                  Icons.close,
                  size: 10.sp,
                  color: AppColors.white,
                ),
              ),
              InkWell(
                onTap: () {
                  widget.onSelect();
                },
                child: Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(100)),
                    child: Icon(
                      Icons.add,
                      size: 10.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
