import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/business_logic/SubscriptionCubit/subscription_cubit.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/constants/tools/string.dart';
import 'package:seda_driver/src/models/response/subscription/subscription.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants_variables.dart';

class SubscriptionsTypeScreen extends StatefulWidget {
  const SubscriptionsTypeScreen({Key? key, required this.subscription})
      : super(key: key);
  // final String title;
  // final int fees;
  final Subscription subscription;

  @override
  State<SubscriptionsTypeScreen> createState() =>
      _SubscriptionsTypeScreenState();
}

class _SubscriptionsTypeScreenState extends State<SubscriptionsTypeScreen> {
  _features(BuildContext context) => <List<dynamic>>[
        [
          context.subscriptionFeatureCityRides,
          AppAssets.imgCityRides,
        ],
        [
          context.subscriptionFeatureCityToCity,
          AppAssets.imgCityToCity,
        ],
        [
          context.subscriptionFeatureReservationOfHour,
          AppAssets.imgReservationOFHour,
        ],
        [
          context.subscriptionFeatureCustomisedPrice,
          AppAssets.imgCustomizedPrice,
        ],
      ];
  final List<bool> _featuresStatus = [false, false, false, false];

  List<List<dynamic>> _offers(BuildContext context) => <List<dynamic>>[
        [
          context.healthInsurance,
          AppAssets.icHealthInsurance,
        ],
        [
          context.familyInsurance,
          AppAssets.icFamilyInsurance,
        ],
      ];
  int featureCount = 0;

  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionStates>(
        builder: (context, state) {
      final cubit = SubscriptionCubit.get(context);
      return Scaffold(
        appBar: CustomAppBar(
          title: widget.subscription.name,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 6.w,
          ),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 1.h,
                  horizontal: 6.w,
                ),
                child: DefaultAppText(
                  text: context.weeklySubscriptionText(
                    widget.subscription.price.toString(),
                  ),
                  lineHeight: 1.5,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: DefaultAppText(
                  text: context.featuresOffered,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: isDark ? AppColors.white : AppColors.midBlue,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 3.h, top: 1.h),
                child: DefaultAppText(
                  text: context.servicesCanJoin,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                ),
              ),
              CustomListView(
                enableDivider: false,
                enableBorder: false,
                separatorHeight: 2.5.h,
                children: List.generate(
                  widget.subscription.benefits?.numOfService??_featuresStatus.length,
                  (index) => CustomListViewItem(
                    enableBorder: true,
                    borderRadius: BorderRadius.circular(12),
                    borderColor: _featuresStatus[index] == true
                        ? isDark
                            ? AppColors.white
                            : AppColors.lightBlue
                        : isDark
                            ? AppColors.white
                            : AppColors.darkGrey,
                    titleText: _features(context)[index][0],
                    titleFontSize: 12.sp,
                    titleFontWeight: FontWeight.w400,
                    leading: Image.asset(_features(context)[index][1]),trailing: const SizedBox(), onClick: () {  },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 2.5.h, top: 1.5.h),
                child: DefaultAppText(
                  text: context.rewardOffered,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                ),
              ),
              CustomListView(
                separatorHeight: 2.5.h,
                enableBorder: false,
                enableDivider: false,
                children: List.generate(widget.subscription.benefits?.numOfOffer??_offers(context).length, (index) => CustomListViewItem(
                  enableBorder: true,
                  borderRadius: BorderRadius.circular(12),
                  titleText: _offers(context)[index][0],
                  titleFontSize: 12.sp,
                  titleFontWeight: FontWeight.w400,
                  leading: Image.asset(_offers(context)[index][1]),
                  // trailing: Icon(
                  //   Icons.arrow_forward_ios,
                  //   color: isDark ? AppColors.white : AppColors.lightBlue,
                  //   size: 15.sp,
                  // ),
                  trailing: const SizedBox(),
                  onClick: () {
                    //TODO
                    logWarning(
                        "${DateTime.parse(cubit.subscribedData.endDate!)}");
                    logWarning(
                        "${DateTime.parse(cubit.subscribedData.endDate!).subtract(const Duration(days: 2))}");
                  },
                ),)
              ),
              DefaultAppButton(
                text: !cubit.subscribed
                    ? context.subscribe
                    : cubit.subscriptionId != widget.subscription.id
                        ? context.upgrade
                        : context.renew,
                onTap: cubit.subscribed &&
                        cubit.subscriptionId == widget.subscription.id &&
                        (DateTime.parse(cubit.subscribedData.endDate!)
                            .isAfter(today))
                    ? () {}
                    : () {
                        showDialog(
                          context: context,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                        if (widget.subscription.id != null) {
                          if (cubit.subscribed &&
                              cubit.subscriptionId == widget.subscription.id) {
                            cubit.renewSubscription(
                                id: widget.subscription.id!,
                                afterSuccess: () {
                                  context.youSubscribedSuccessfully
                                      .toToastSuccess();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                afterError: () {
                                  context.someErrorHappenedTryAgain
                                      .toToastError();
                                  Navigator.pop(context);
                                });
                          } else if (cubit.subscribed && cubit.subscriptionId !=
                              widget.subscription.id) {
                            cubit.upgradeSubscription(
                                id: widget.subscription.id!,
                                afterSuccess: () {
                                  context.youSubscribedSuccessfully
                                      .toToastSuccess();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                afterError: () {
                                  context.someErrorHappenedTryAgain
                                      .toToastError();
                                  Navigator.pop(context);
                                });
                          } else {
                            cubit.subscribe(
                                id: widget.subscription.id!,
                                afterSuccess: () {
                                  context.youSubscribedSuccessfully
                                      .toToastSuccess();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                afterError: () {
                                  context.someErrorHappenedTryAgain
                                      .toToastError();
                                  Navigator.pop(context);
                                });
                          }
                        }
                      },
                fontSize: 13.sp,
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                backgroundColor: cubit.subscribed &&
                        cubit.subscriptionId == widget.subscription.id &&
                        (DateTime.parse(cubit.subscribedData.endDate!)
                            .isAfter(today))
                    ? AppColors.lightGrey
                    : null,
              ),
            ],
          ),
        ),
      );
    });
  }
}
