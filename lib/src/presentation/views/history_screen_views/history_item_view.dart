import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';
import '../../../models/orders_history.dart';

class HistoryItemView extends StatelessWidget {
  const HistoryItemView({
    Key? key,
    required this.tripHistory,
    required this.onTap,
  }) : super(key: key);

  final Orders tripHistory;
  final dynamic Function() onTap;

  @override
  Widget build(BuildContext context) {
    return CustomListViewItem(
      height: 30.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      enableBorder: true,
      borderRadius: BorderRadius.circular(12),
      borderColor: isDark ? AppColors.white : AppColors.midBlue,
      onClick: onTap,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DefaultAppText(
                  text: 'id: ${tripHistory.id}',
                  fontWeight: FontWeight.w400,
                  fontSize: 10.sp,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
                Container(
                  height: 3.h,
                  width: 25.w,
                  decoration: BoxDecoration(
                    color: tripHistory.status == "end"
                        ? AppColors.midGreen
                        : AppColors.red,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultAppText(
                        text: tripHistory.status == "end"
                            ? context.completed
                            : context.cancelled,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: AppColors.white,
                      ),
                      tripHistory.status == "end"
                          ? Icon(
                              Icons.check,
                              color: AppColors.white,
                              size: 10.sp,
                            )
                          : Icon(
                              Icons.close_rounded,
                              color: AppColors.white,
                              size: 10.sp,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 1.1.h,
                        width: 1.1.h,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      Container(
                        height: 5.5.h,
                        width: 0.5.w,
                        margin: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: const BoxDecoration(
                          color: AppColors.lightBlue,
                        ),
                      ),
                      Container(
                        height: 1.1.h,
                        width: 1.1.h,
                        margin: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 0.8.h,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DefaultAppText(
                            text: tripHistory.fromLocation?.address ?? '-',
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                            color: AppColors.black,
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 0.8.h,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DefaultAppText(
                            text: tripHistory.toLocation!.last.address!,
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                            color: AppColors.black,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      AppAssets.icMoney,
                      scale: 0.75,
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    DefaultAppText(
                      text: '${tripHistory.price} SAR',
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                  ],
                ),
                Row(
                  children: [
                    DefaultAppText(
                      text: context.more,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                      color: isDark ? AppColors.white : AppColors.lightBlue,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: isDark ? AppColors.white : AppColors.midBlue,
                      size: 10.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: const SizedBox(),
    );
  }
}
