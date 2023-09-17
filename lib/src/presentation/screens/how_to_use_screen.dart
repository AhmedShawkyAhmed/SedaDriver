import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

class HowToUseScreen extends StatefulWidget {
  const HowToUseScreen({Key? key}) : super(key: key);

  @override
  State<HowToUseScreen> createState() => _HowToUseScreenState();
}

class _HowToUseScreenState extends State<HowToUseScreen> {
  List<List<dynamic>> _reg(BuildContext context) => <List<dynamic>>[
        [context.silverLevel, false, Image.asset(AppAssets.icSilverLevel), 0],
        [context.goldenLevel, false, Image.asset(AppAssets.icGoldenLevel), 100],
        [
          context.platinumLevel,
          false,
          Image.asset(AppAssets.icPlatinumLevel),
          400
        ],
        [
          context.diamondLevel,
          true,
          Image.asset(AppAssets.icDiamondLevel),
          800
        ],
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.howToUse,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 11),
                child: Column(
                  children: [
                    DefaultAppText(
                      text: context.earn1PointEveryTrip,
                      fontSize: 1.9.h,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    DefaultAppText(
                      text: context.maintainService,
                      fontSize: 5.w,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      color: AppColors.midBlue,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    DefaultAppText(
                      text: context.keepHighRating,
                      fontSize: 1.9.h,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
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
                padding: const EdgeInsets.symmetric(horizontal: 11),
                child: Column(
                  children: [
                    SizedBox(
                      height: 4.h,
                    ),
                    DefaultAppText(
                      text: context.yourBonus,
                      fontSize: 5.w,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      color: AppColors.midBlue,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    DefaultAppText(
                      text: context.yourPointsEvaluation,
                      fontSize: 1.95.h,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 1,
                          color: AppColors.grey,
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: EdgeInsets.only(bottom: 1.h),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Material(
                          color: AppColors.transparent,
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 15,
                            ),
                            height: 6.5.h,
                            alignment: Alignment.center,
                            color: _reg(context)[index][1] == true
                                ? AppColors.darkBlue
                                : AppColors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        _reg(context)[index][2],
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        DefaultAppText(
                                          text: _reg(context)[index][0],
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                          color: _reg(context)[index][1] == true
                                              ? AppColors.white
                                              : AppColors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _reg(context)[index][1] == true
                                    ? const SizedBox()
                                    : const VerticalDivider(
                                        thickness: 1,
                                        width: 0,
                                        color: AppColors.grey,
                                      ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    color: _reg(context)[index][1] == true
                                        ? AppColors.transparent
                                        : AppColors.lightGrey,
                                    child: DefaultAppText(
                                      text: context.countPoints(
                                          '${_reg(context)[index][3]}'),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      textAlign: TextAlign.center,
                                      color: _reg(context)[index][1] == true
                                          ? AppColors.white
                                          : AppColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        separatorBuilder: (context, index) => const Divider(
                          color: AppColors.grey,
                          thickness: 1,
                          height: 0,
                        ),
                        itemCount: _reg(context).length,
                      ),
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
                padding: const EdgeInsets.symmetric(horizontal: 11),
                child: Column(
                  children: [
                    SizedBox(
                      height: 4.h,
                    ),
                    DefaultAppText(
                      text: context.threeMonthPeriod,
                      fontSize: 5.w,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      color: AppColors.midBlue,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    DefaultAppText(
                      text: context.pointsCalculation,
                      fontSize: 1.95.h,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
