import 'package:flutter/material.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:sizer/sizer.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    Key? key,
    required this.tabs,
    this.onTap,
  }) : super(key: key);

  final List<String> tabs;
  final Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      height: 8.h,
      color: AppColors.midBlue,
      alignment: Alignment.center,
      child: TabBar(
        onTap: onTap,
        padding: EdgeInsets.zero,
        indicatorColor: AppColors.white,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: AppColors.white,
        unselectedLabelStyle: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
        ),
        isScrollable: true,
        indicatorWeight: 3,
        labelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
        tabs: tabs
            .map(
              (e) => Tab(
                text: e,
              ),
            )
            .toList(),
      ),
    );
  }
}
