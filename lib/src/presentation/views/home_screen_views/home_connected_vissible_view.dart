import 'dart:math';

import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';
import 'home_bottom_sheet_service_view.dart';

class HomeConnectedVisibleView extends StatefulWidget {
  const HomeConnectedVisibleView({Key? key, required this.showHidden})
      : super(key: key);

  final Function() showHidden;

  @override
  State<HomeConnectedVisibleView> createState() =>
      _HomeConnectedVisibleViewState();
}

class _HomeConnectedVisibleViewState extends State<HomeConnectedVisibleView> {
  String service = 'City Rides';

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
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomListViewItem(
            backgroundColor: AppColors.midBlue,
            textAlign: TextAlign.center,
            height: 9.h,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
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
                  angle: (-90 / 180) * pi,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            onClick: () {
              //TODO
              widget.showHidden();
            },
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
              //TODO
              Navigator.pushNamed(context, AppRouterNames.levels);
            },
          ),
          Divider(
            color: isDark ? AppColors.white : AppColors.darkGrey,
            thickness: 1,
          ),
          CustomListViewItem(
            backgroundColor: isDark ? AppColors.darkBlue : AppColors.white,
            trailing: Row(
              children: [
                DefaultAppText(
                  text: service,
                  color: isDark ? AppColors.white : AppColors.lightBlue,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  width: 7.w,
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
            titleText: context.services,
            titleFontSize: 13.sp,
            titleColor: isDark ? AppColors.white : AppColors.darkGrey,
            titleFontWeight: FontWeight.w500,
            onClick: () {
              //TODO: change service
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  enableDrag: false,
                  isDismissible: false,
                  backgroundColor: AppColors.transparent,
                  builder: (context) => ServicesView(
                        service: service,
                      )).then((value) {
                setState(() {
                  service = value;
                });
              });
            },
          ),
        ],
      ),
    );
  }
}
