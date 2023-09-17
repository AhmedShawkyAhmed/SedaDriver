import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/business_logic/socket_cubit/socket_cubit.dart';
import 'package:seda_driver/src/constants/constants_variables.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/views/custom_profile_image_view.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

class HomeOrderView extends StatelessWidget {
  const HomeOrderView({
    super.key,
    required this.startEndCancelOrder,
    required this.timeTakenValueNotifier,
    required this.startedValueNotifier,
    required this.getTimer,
    required this.time,
    required this.makePhoneCall,
    required this.cubit,
    required this.initializeTimer,
    required this.orderGetMyLocation,
    required this.addDropOff,
  });

  final Function(String type, BuildContext context) startEndCancelOrder;
  final ValueNotifier<String> timeTakenValueNotifier;
  final ValueNotifier<bool> startedValueNotifier;
  final Function(int timeInSeconds) getTimer;
  final int time;
  final Function(String phoneNumber) makePhoneCall;
  final SocketCubit cubit;
  final Function() initializeTimer;
  final Function(bool val) orderGetMyLocation;
  final Function() addDropOff;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocketCubit, SocketState>(
      listener: (context, state) async {
        if (state is SocketArrivedOrderFromByDriver) {
          initializeTimer();
        } else if (state is SocketOrderStartedByDriver) {
          startedValueNotifier.value = true;
          orderGetMyLocation(true);
          if (state is UserAddedDropOffStarted ||
              state is UserAddedDropOffSecondStarted) {
            await addDropOff();
          }
        } else if (state is SocketArrivedOrderFromByDriver) {
          orderGetMyLocation(true);
          if (state is UserAddedDropOffStarted ||
              state is UserAddedDropOffSecondArrived) {
            await addDropOff();
          }
        }
      },
      builder: (context, state) {
        final cubit = SocketCubit.get(context);
        final tripStarted =
            state is SocketOrderStartedByDriver || state is SocketTripRecording;
        final driverArrived = state is SocketArrivedOrderFromByDriver ||
            state is SocketOrderAlertTimeOut;
        return AnimatedSize(
          duration: const Duration(milliseconds: 50),
          curve: Curves.easeIn,
          child: Container(
            height: tripStarted ? 32.h : 40.h,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBlue : AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                CustomListViewItem(
                  height: 12.h,
                  onClick: null,
                  backgroundColor: AppColors.midBlue,
                  leading: SizedBox(
                    height: 7.h,
                    width: 7.h,
                    child: CustomProfileImageView(
                      view: true,
                      avatarIconPadding: 2.w,
                      networkImage:
                          cubit.orderResponse?.orderModel?.user?.image != null
                              ? Image.network(
                                  "${EndPoints.imageBaseUrl}${cubit.orderResponse?.orderModel?.user?.image}",
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  leadingTitleSpacing: 3.w,
                  titleText: cubit.orderResponse?.orderModel?.user?.name ?? '',
                  titleFontSize: 13.sp,
                  titleFontWeight: FontWeight.w500,
                  titleColor: AppColors.white,
                  trailing: ValueListenableBuilder<bool>(
                    valueListenable: startedValueNotifier,
                    builder: (context, started, child) {
                      return started == false
                          ? Row(
                              children: [
                                Material(
                                  color: AppColors.transparent,
                                  type: MaterialType.circle,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, AppRouterNames.chat);
                                    },
                                    child: Image.asset(AppAssets.icChat),
                                  ),
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Material(
                                  color: AppColors.transparent,
                                  type: MaterialType.circle,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: InkWell(
                                    onTap: () {
                                      makePhoneCall(cubit.orderResponse
                                              ?.orderModel?.user?.phone ??
                                          " ");
                                    },
                                    child: Image.asset(AppAssets.icCall),
                                  ),
                                ),
                              ],
                            )
                          : Container();
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 10.h,
                  width: 100.w,
                  color: isDark ? AppColors.darkBlue : AppColors.white,
                  child: ValueListenableBuilder<String>(
                      valueListenable: timeTakenValueNotifier,
                      builder: (context, timeTaken, child) {
                        return DefaultAppText(
                          text: driverArrived
                              ? getTimer(time)
                              : context.away(timeTaken),
                          textAlign: TextAlign.center,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        );
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: DefaultAppButton(
                    text: tripStarted
                        ? context.endTheTrip
                        : driverArrived
                            ? context.startTheTrip
                            : context.arrived,
                    width: 60.w,
                    height: 5.h,
                    backgroundColor: AppColors.white,
                    textColor: AppColors.midBlue,
                    enableBorder: true,
                    borderColor: AppColors.midBlue,
                    onTap: () => tripStarted
                        ? startEndCancelOrder(
                            'end',
                            context,
                          )
                        : driverArrived
                            ? startEndCancelOrder(
                                'start',
                                context,
                              )
                            : startEndCancelOrder(
                                'arrive',
                                context,
                              ),
                  ),
                ),
                if (!tripStarted)
                  CustomListViewItem(
                    height: 8.h,
                    trailing: const SizedBox(),
                    backgroundColor:
                        isDark ? AppColors.darkBlue : AppColors.white,
                    textAlign: TextAlign.center,
                    titleText: context.cancel,
                    titleFontSize: 13.sp,
                    titleFontWeight: FontWeight.w500,
                    titleColor: AppColors.red,
                    enableBorder: true,
                    borderColor: isDark ? AppColors.white : AppColors.black,
                    onClick: () => startEndCancelOrder(
                      'cancel',
                      context,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
