import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

class HomePromotionsPageView extends StatelessWidget {
  const HomePromotionsPageView(
      {Key? key, required this.animate, required this.updateState})
      : super(key: key);

  final bool animate;
  final Function() updateState;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.symmetric(horizontal: 17.w),
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: animate ? 2.h : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: animate
            ? Border.all(
                color: AppColors.midBlue,
                width: 3,
              )
            : null,
        color: animate ? AppColors.white : AppColors.transparent,
      ),
      duration: const Duration(milliseconds: 250),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultAppButton(
            margin: EdgeInsets.symmetric(horizontal: 7.w),
            backgroundColor: AppColors.midBlue,
            icon: Image.asset(
              AppAssets.icHomePromotions,
            ),
            text: context.promotions,
            onTap: updateState,
          ),
          if (animate)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultAppText(
                    text: context.promotionsText,
                    textAlign: TextAlign.center,
                    lineHeight: 1.7,
                    color: AppColors.midBlue,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          if (animate)
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRouterNames.levels);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DefaultAppText(
                    text: context.clickForMore,
                    fontSize: 9.sp,
                    color: AppColors.midBlue,
                    fontWeight: FontWeight.w500,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: AppColors.midBlue.withAlpha(180),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
