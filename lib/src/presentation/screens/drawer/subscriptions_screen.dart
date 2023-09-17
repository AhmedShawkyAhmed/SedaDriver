import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/business_logic/SubscriptionCubit/subscription_cubit.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:seda_driver/src/presentation/widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({Key? key, this.confirmed}) : super(key: key);
  final String? confirmed;

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  @override
  void initState() {
    SubscriptionCubit.get(context).checkSubscription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.subscriptions,
      ),
      body: BlocConsumer<SubscriptionCubit, SubscriptionStates>(
        listener: (context, state) {
          if (state is SubscriptionSuccess) {
            SubscriptionCubit.get(context).checkSubscription();
          }
        },
        builder: (context, state) {
          final cubit = SubscriptionCubit.get(context);
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 2.h,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: DefaultAppText(
                    text: context.subscriptions,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    color: isDark ? AppColors.white : AppColors.midBlue,
                  ),
                ),
                state is! GetSubscriptionLoading
                    ? CustomListView(
                        enableBorder: false,
                        enableDivider: false,
                        margin: EdgeInsets.only(bottom: 1.h),
                        separatorHeight: 2.h,
                        children: List.generate(
                          cubit.subscriptionList.length,
                          (index) => CustomListViewItem(
                            height: 16.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 2.h,
                            ),
                            enableBorder: true,
                            borderRadius: BorderRadius.circular(12),
                            borderColor: cubit.subscribed &&
                                    cubit.subscriptionStatus &&
                                    cubit.subscriptionList[index].id ==
                                        cubit.subscriptionId
                                ? isDark
                                    ? AppColors.green
                                    : AppColors.lightBlue
                                : isDark
                                    ? AppColors.white
                                    : AppColors.darkGrey,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DefaultAppText(
                                      text: cubit
                                              .subscriptionList[index].name ??
                                          (index == 0
                                              ? context.subscriptionWeekly
                                              : context.subscriptionMonthly),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    ),
                                    if (cubit.subscriptionList[index].id ==
                                        cubit.subscriptionId)
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                    !cubit.subscribed ||(cubit.subscriptionList[index].id != cubit.subscriptionId)
                                        ? const SizedBox():
                                    (cubit.subscriptionStatus &&
              cubit.subscriptionList[index].id == cubit.subscriptionId)?
                  Icon(
                                            Icons.check_circle_outline_rounded,
                                            color: isDark
                                                ? AppColors.green
                                                : AppColors.lightBlue,
                                          )
                                        :const Icon(
                                                Icons.error_outline_rounded,
                                                color: AppColors.yellow,
                                              ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                DefaultAppText(
                                  text:
                                      '${cubit.subscriptionList[index].price}  SAR',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.sp,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.lightBlue,
                                ),
                              ],
                            ),
                            onClick: () {
                              Navigator.pushNamed(
                                context,
                                AppRouterNames.subscriptionsType,
                                arguments: {
                                  'subscription': cubit.subscriptionList[index],
                                },
                              );
                            },
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 34.h,
                        child: const LoadingIndicator(),
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: DefaultAppText(
                    text: context.commissionType,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    color: isDark ? AppColors.white : AppColors.midBlue,
                  ),
                ),
                CustomListViewItem(
                  enableBorder: true,
                  borderRadius: BorderRadius.circular(12),
                  borderColor: cubit.subscribed && !cubit.subscriptionStatus
                      ? isDark
                          ? AppColors.green
                          : AppColors.lightBlue
                      : isDark
                          ? AppColors.white
                          : AppColors.darkGrey,
                  titleText: context.commissionType,
                  titleFontSize: 12.sp,
                  titleFontWeight: FontWeight.w400,
                  trailing: Row(
                    children: [
                      if (cubit.subscribed && !cubit.subscriptionStatus)
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: isDark ? AppColors.green : AppColors.lightBlue,
                        ),
                      if (cubit.subscribed && !cubit.subscriptionStatus)
                        SizedBox(
                          width: 3.w,
                        ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: isDark ? AppColors.white : AppColors.lightBlue,
                      ),
                    ],
                  ),
                  onClick: () {
                    setState(() {});
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
