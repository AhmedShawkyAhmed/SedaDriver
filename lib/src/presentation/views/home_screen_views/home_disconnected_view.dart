import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../business_logic/SubscriptionCubit/subscription_cubit.dart';
import '../../../constants/constants_variables.dart';

class HomeDisConnectedView extends StatelessWidget {
  const HomeDisConnectedView({Key? key, required this.connect})
      : super(key: key);

  final Function() connect;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionStates>(
        builder: (context, state) {
      final cubit = SubscriptionCubit.get(context);
      final DateFormat month = DateFormat('MMMM');
      return Stack(
        children: [
          Stack(
            children: [
              Container(
                height: 12.h,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 2.h),
                margin: EdgeInsets.only(
                    top: cubit.subscribed && !cubit.subscriptionStatus
                        ? 10.h
                        : 5.h),
                decoration: const BoxDecoration(
                  color: AppColors.midBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: DefaultAppText(
                  text: context.notConnected,
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(
                      top: cubit.subscribed && !cubit.subscriptionStatus
                          ? 6.h
                          : 1.h),
                  height: 25.w,
                  width: 25.w,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.midBlue,
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: DefaultAppButton(
                    backgroundColor: AppColors.white,
                    textColor: AppColors.midBlue,
                    text: context.start,
                    buttonShape: BoxShape.circle,
                    onTap: () {
                      //TODO
                      connect();
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: cubit.subscribed && !cubit.subscriptionStatus ? 22.h : 16.h,
            child: Container(
              padding: EdgeInsets.only(bottom: 0.h),
              color: isDark ? AppColors.darkBlue : AppColors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  cubit.subscribed && !cubit.subscriptionStatus
                      ? Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.darkRed,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 2.h,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 1.h,
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(AppAssets.icWarning),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    DefaultAppText(
                                      text: context.warning,
                                      color: AppColors.darkRed,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                DefaultAppText(
                                  text: context.upPaidSubscription(
                                    month.format(
                                      DateTime.parse(
                                          cubit.subscribedData.endDate ??
                                              '2023-06-21 15:07:38.951971'),
                                    ),
                                  ),
                                  color: AppColors.darkRed,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Divider(
                    color: isDark
                        ? AppColors.white
                        : AppColors.darkGrey.withAlpha(
                            150,
                          ),
                    thickness: 1,
                    height: 1.h,
                  ),
                  CustomListViewItem(
                    leading: Image.asset(
                      AppAssets.icSeeDrivingTime,
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                    titleText: context.seeDrivingTime,
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: isDark
                          ? AppColors.white
                          : AppColors.midBlue.withAlpha(200),
                      size: 20,
                    ),
                    onClick: () {
                      //TODO
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
