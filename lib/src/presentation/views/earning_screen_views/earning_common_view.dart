import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../business_logic/orders_cubit/orders_cubit.dart';
import '../../../constants/constants_variables.dart';

class EarningCommonView extends StatelessWidget {
  const EarningCommonView({
    Key? key,
    required this.earningPageIdentifierView,
    required this.id,
    this.index,
  }) : super(key: key);

  final Widget earningPageIdentifierView;
  final int id;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
      final cubit = OrdersCubit.get(context);
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    color: isDark ? AppColors.white : AppColors.darkGrey,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    earningPageIdentifierView,
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        AppAssets.icTrip,
                                        color: isDark
                                            ? AppColors.white
                                            : AppColors.black,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      DefaultAppText(
                                        text: context.trips,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.sp,
                                      ),
                                    ],
                                  ),
                                ),
                                DefaultAppText(
                                  text: context.tripCounter(
                                      "${id == 1 ? cubit.dailyEarning?.tripsNum ?? '-' : cubit.previousEarning?[index ?? 0].tripsNum ?? '-'}"),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.sp,
                                  textAlign: TextAlign.center,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.midBlue,
                                ),
                              ],
                            ),
                            VerticalDivider(
                              thickness: 1,
                              width: 0,
                              color: isDark ? AppColors.white : AppColors.black,
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        AppAssets.icClock,
                                        color: isDark
                                            ? AppColors.white
                                            : AppColors.black,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      DefaultAppText(
                                        text: context.onlineHours,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.sp,
                                      ),
                                    ],
                                  ),
                                ),
                                DefaultAppText(
                                  text:
                                      "${id == 1 ? cubit.dailyEarning?.hours?.toStringAsFixed(3) ?? '-' : cubit.previousEarning?[index ?? 0].hours?.toStringAsFixed(3) ?? '-'} h",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.sp,
                                  textAlign: TextAlign.center,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.midBlue,
                                ),
                              ],
                            ),
                            VerticalDivider(
                              thickness: 1,
                              width: 0,
                              color: isDark ? AppColors.white : AppColors.black,
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        AppAssets.icCash,
                                        color: isDark
                                            ? AppColors.white
                                            : AppColors.black,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      DefaultAppText(
                                        text: context.cashTrips,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.sp,
                                      ),
                                    ],
                                  ),
                                ),
                                DefaultAppText(
                                  text:
                                      '${id == 1 ? cubit.dailyEarning?.earning ?? '-' : cubit.previousEarning?[index ?? 0].earning ?? '-'} SAR',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.sp,
                                  textAlign: TextAlign.center,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.midBlue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DefaultAppText(
                          text: context.tripFares,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                        DefaultAppText(
                          text:
                              '${id == 1 ? cubit.dailyEarning?.earning ?? '-' : cubit.previousEarning?[index ?? 0].earning ?? '-'} SAR',
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DefaultAppText(
                          text: context.appFees,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                        DefaultAppText(
                          text:
                              '${id == 1 ? cubit.dailyEarning?.captainTax ?? '-' : cubit.previousEarning?[index ?? 0].captainTax ?? '-'} SAR',
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DefaultAppText(
                          text: context.tax,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                        DefaultAppText(
                          text:
                              '${id == 1 ? cubit.dailyEarning?.captainTax ?? '-' : cubit.previousEarning?[index ?? 0].captainTax ?? '-'} SAR',
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DefaultAppText(
                          text: context.tolls,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                        DefaultAppText(
                          text:
                              '${id == 1 ? cubit.dailyEarning?.captainTax ?? '-' : cubit.previousEarning?[index ?? 0].captainTax ?? '-'} SAR',
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DefaultAppText(
                          text: context.discount,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                        DefaultAppText(
                          text:
                              '${id == 1 ? cubit.dailyEarning?.captainTax ?? '-' : cubit.previousEarning?[index ?? 0].captainTax ?? '-'} SAR',
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DefaultAppText(
                          text: context.topUpAdded,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                        DefaultAppText(
                          text:
                              '${id == 1 ? cubit.dailyEarning?.captainTax ?? '-' : cubit.previousEarning?[index ?? 0].captainTax ?? '-'} SAR',
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: Divider(
                  color: isDark ? AppColors.white : AppColors.darkGrey,
                  thickness: 1,
                  height: 0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultAppText(
                      text: context.totalEarning,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: isDark ? AppColors.white : AppColors.midBlue,
                    ),
                    DefaultAppText(
                      text:
                          '${id == 1 ? cubit.dailyEarning?.earning ?? '-' : cubit.previousEarning?[index ?? 0].earning ?? '-'} SAR',
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: isDark ? AppColors.white : AppColors.midBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
