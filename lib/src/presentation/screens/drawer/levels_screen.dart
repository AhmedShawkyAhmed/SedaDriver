import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({Key? key}) : super(key: key);

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  List<List<dynamic>> _reg(BuildContext context) => <List<dynamic>>[
        [
          context.healthInsurance,
          Image.asset(AppAssets.icHealthInsurance),
        ],
        [
          context.familyInsurance,
          Image.asset(AppAssets.icFamilyInsurance),
        ],
        [
          context.bankLoan,
          Image.asset(AppAssets.icBankLoad),
        ],
        [
          context.freeFuelShipping,
          Image.asset(AppAssets.icFreeFuelShipping),
        ],
        [
          context.discounts,
          Image.asset(AppAssets.icDiscount),
        ],
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.levels,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AppAssets.icSilverLevel),
                            const SizedBox(
                              width: 10,
                            ),
                            DefaultAppText(
                              text: context.silverLevel,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              color:
                                  isDark ? AppColors.white : AppColors.darkBlue,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        CircularPercentIndicator(
                          radius: 120,
                          lineWidth: 16,
                          animation: true,
                          percent: 0.4,
                          center: Text(
                            "40 / 100",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color:
                                  isDark ? AppColors.white : AppColors.midBlue,
                            ),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor:
                              isDark ? AppColors.white : AppColors.midBlue,
                          backgroundColor: isDark
                              ? AppColors.grey
                              : AppColors.blue.withOpacity(0.2),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DefaultAppText(
                              text: context.starReviews,
                              fontSize: 1.9.h,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.center,
                            ),
                            Row(
                              children: [
                                DefaultAppText(
                                  text: '(5)',
                                  fontSize: 1.9.h,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Icon(
                                  Icons.star,
                                  color: AppColors.yellow,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DefaultAppText(
                              text: context.tripCancellationRate,
                              fontSize: 1.9.h,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.center,
                            ),
                            DefaultAppText(
                              text: '0%',
                              fontSize: 1.9.h,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        DefaultAppButton(
                          backgroundColor: isDark
                              ? AppColors.darkBlue
                              : AppColors.transparent,
                          textColor:
                              isDark ? AppColors.white : AppColors.midBlue,
                          enableBorder: true,
                          borderColor:
                              isDark ? AppColors.white : AppColors.midBlue,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          margin: EdgeInsets.symmetric(horizontal: 15.w),
                          text: context.howToUse,
                          onTap: () {
                            Navigator.pushNamed(context, AppRouterNames.howToUse);
                          },
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: AppColors.darkGrey,
                    thickness: 1,
                    height: 0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4.h,
                    ),
                    child: DefaultAppText(
                      text: context.silverLevelBonus,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: isDark ? AppColors.white : AppColors.darkBlue,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => CustomListViewItem(
                        borderColor:
                            isDark ? AppColors.white : AppColors.darkBlue,
                        enableBorder: true,
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 15,
                        ),
                        leading: _reg(context)[index][1],
                        borderRadius: BorderRadius.circular(12),
                        titleFontWeight: FontWeight.w400,
                        titleFontSize: 12.sp,
                        titleText: _reg(context)[index][0],
                        onClick: () {
                          //TODO
                        },
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                      ),
                      itemCount: _reg(context).length,
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomListViewItem(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
            ),
            titleText: context.levelUpForMoreBonus,
            height: 8.h,
            titleFontSize: 12.sp,
            titleFontWeight: FontWeight.w400,
            titleColor: AppColors.white,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.white,
            ),
            backgroundColor: AppColors.darkBlue.withAlpha(220),
            onClick: () {},
          ),
        ],
      ),
    );
  }
}
