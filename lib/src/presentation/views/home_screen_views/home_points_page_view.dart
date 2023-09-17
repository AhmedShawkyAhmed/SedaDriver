import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

class HomePointsPageView extends StatelessWidget {
  const HomePointsPageView({
    Key? key,
    required this.animate,
    required this.updateState,
  }) : super(key: key);

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
          Row(
            children: [
              Expanded(
                child: DefaultAppButton(
                  margin: EdgeInsets.symmetric(
                    horizontal: animate ? 4.w : 7.w,
                  ),
                  backgroundColor: AppColors.midBlue,
                  icon: Image.asset(
                    AppAssets.icHomePoints,
                  ),
                  text: context.countPoints('10'),
                  onTap: updateState,
                ),
              ),
              if (animate)
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.visibility,
                    color: AppColors.midBlue,
                  ),
                ),
            ],
          ),
          if (animate)
            SizedBox(
              height: 3.h,
            ),
          if (animate)
            DefaultAppText(
              text: context.silverLevel,
              color: AppColors.midBlue,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          if (animate)
            Divider(
              color: AppColors.darkGrey,
              thickness: 0.8,
              height: 3.h,
            ),
          if (animate)
            DefaultAppText(
              text: context.upgradePointsCalculation,
              color: AppColors.midBlue,
              fontSize: 10.sp,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
            ),
          if (animate) const Spacer(),
          if (animate)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: AppColors.midBlue.withAlpha(180),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
