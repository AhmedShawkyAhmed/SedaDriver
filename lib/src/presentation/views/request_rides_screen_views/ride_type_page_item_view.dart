import 'package:flutter/material.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

class RideTypePageItemView extends StatelessWidget {
  const RideTypePageItemView({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  final List<dynamic> data;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return CustomListViewItem(
      margin: EdgeInsets.only(right: 2.w),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(12),
      enableBorder: true,
      height: 8.h,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            data[2],
            scale: 0.9,
            color: data[1] != true ? AppColors.black : AppColors.midBlue,
          ),
          SizedBox(
            height: 1.h,
          ),
          DefaultAppText(
            text: data[0],
            fontWeight: FontWeight.w500,
            fontSize: 11.sp,
            color: data[1] != true ? AppColors.black : AppColors.midBlue,
          ),
        ],
      ),
      trailing: const SizedBox(),
      onClick: onTap,
    );
  }
}
