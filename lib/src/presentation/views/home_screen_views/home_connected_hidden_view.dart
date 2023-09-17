import 'dart:math';

import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';
import '../../router/app_routes_names.dart';

class HomeConnectedHiddenView extends StatelessWidget {
  const HomeConnectedHiddenView({
    Key? key,
    required this.disconnect,
    required this.showVisible,
    required this.showStop,
  }) : super(key: key);

  final Function() disconnect;
  final Function() showVisible;
  final bool showStop;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBlue : AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          CustomListViewItem(
            backgroundColor: AppColors.midBlue,
            trailing: const SizedBox(),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultAppText(
                  text: context.youConnected,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  textAlign: TextAlign.center,
                  color: AppColors.white,
                ),
                SizedBox(width: 2.w),
                Transform.rotate(
                  angle: (90 / 180) * pi,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            textAlign: TextAlign.center,
            height: 9.h,
            onClick: () {
              showVisible();
            },
          ),
          SizedBox(
            height: 2.w,
          ),
          CustomListViewItem(
            backgroundColor: isDark ? AppColors.darkBlue : AppColors.white,
            trailing: Row(
              children: [
                Image.asset(AppAssets.icSilverLevel),
                SizedBox(
                  width: 2.w,
                ),
                DefaultAppText(
                  text: context.countPoints(
                    '40/100',
                  ),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDark
                      ? AppColors.white
                      : AppColors.midBlue.withAlpha(150),
                ),
              ],
            ),
            height: 7.h,
            titleText: context.tryReachHigherLevel,
            titleFontSize: 12.sp,
            titleColor: isDark ? AppColors.white : AppColors.darkGrey,
            titleFontWeight: FontWeight.w500,
            onClick: () {
              Navigator.pushNamed(context, AppRouterNames.levels);
            },
          ),
          Divider(
            color: isDark ? AppColors.white : AppColors.darkGrey,
            thickness: 1,
          ),
          if (showStop)
            CustomListViewItem(
              backgroundColor: isDark ? AppColors.darkBlue : AppColors.white,
              height: 7.h,
              leading: Image.asset(
                AppAssets.icSeeDrivingTime,
                color: isDark ? AppColors.white : AppColors.black,
              ),
              titleText: context.seeDrivingTime,
              titleFontSize: 13.sp,
              titleColor: isDark ? AppColors.white : AppColors.darkGrey,
              titleFontWeight: FontWeight.w500,
              onClick: () {
                //TODO
              },
            ),
          if (showStop)
            Divider(
              color: isDark ? AppColors.white : AppColors.darkGrey,
              thickness: 1,
            ),
          if (showStop)
            CustomListViewItem(
              backgroundColor: isDark ? AppColors.darkBlue : AppColors.white,
              height: 7.h,
              leading: Image.asset(
                AppAssets.icUpcomingPromotions,
                color: isDark ? AppColors.white : AppColors.black,
              ),
              titleText: context.upcomingPromotionalAds,
              titleFontSize: 13.sp,
              titleColor: isDark ? AppColors.white : AppColors.darkGrey,
              titleFontWeight: FontWeight.w500,
              onClick: () {
                //TODO
              },
            ),
          if (showStop)
            Divider(
              color: isDark ? AppColors.white : AppColors.darkGrey,
              thickness: 1,
            ),
          if (showStop)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.25),
                          offset: const Offset(0, 4),
                        )
                      ],
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: 6.h,
                    width: 6.h,
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        onTap: () {
                          //TODO
                        },
                        child: Icon(
                          Icons.search,
                          color: AppColors.darkGrey,
                          size: 20.sp,
                          weight: 5,
                        ),
                      ),
                    ),
                  ),
                  DefaultAppButton(
                    width: 13.h,
                    height: 13.h,
                    text: context.stop,
                    enableBorder: true,
                    borderColor: isDark ? AppColors.white : AppColors.red,
                    borderWidth: 10,
                    textColor: isDark ? AppColors.white : AppColors.red,
                    backgroundColor: isDark ? AppColors.red : AppColors.white,
                    buttonShape: BoxShape.circle,
                    onTap: () {
                      disconnect();
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.25),
                          offset: const Offset(0, 4),
                        )
                      ],
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: 6.h,
                    width: 6.h,
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        onTap: () {
                          //TODO
                        },
                        child: Image.asset(
                          AppAssets.icHomeSettings,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
