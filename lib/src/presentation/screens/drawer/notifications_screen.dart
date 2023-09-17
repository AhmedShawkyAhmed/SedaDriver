import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/business_logic/notification_cubit/notification_cubit.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/data/models/new/notification.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    const NotificationItem(
      1,
      'Congratulation! 🥳 ',
      'body',
      'time',
    ),
    const NotificationItem(
      2,
      'Congratulation! 🥳 ',
      'body',
      'time',
    ),
    const NotificationItem(
      3,
      'Congratulation! 🥳 ',
      'body',
      'time',
    ),
    const NotificationItem(
      4,
      'Congratulation! 🥳 ',
      'body',
      'time',
    ),
    const NotificationItem(
      5,
      'Congratulation! 🥳 ',
      'body',
      'time',
    ),
    const NotificationItem(
      6,
      'Congratulation! 🥳 ',
      'body',
      'time',
    ),
    const NotificationItem(
      7,
      'Congratulation! 🥳 ',
      'body',
      'time',
    ),
    const NotificationItem(
      8,
      'Congratulation! 🥳 ',
      'body',
      'time',
    ),
    const NotificationItem(
      9,
      'Congratulation! 🥳 ',
      'body',
      'time',
    ),
    const NotificationItem(
      10,
      'Congratulation! 🥳 ',
      'body',
      'time',
    ),
    const NotificationItem(
      11,
      'Congratulation! 🥳 ',
      'body',
      'time',
    ),
    const NotificationItem(
      12,
      'Congratulation! 🥳 ',
      'body',
      'time',
    ),
  ];

  @override
  void initState() {
    NotificationCubit.get(context).getAllNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.notificationsSetting,
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          return state is NotificationsGetAllLoadingState?
              const Center(child: CircularProgressIndicator(color: AppColors.darkBlue,))
              :state is NotificationsGetAllFailureState?
               Center(child: DefaultAppText(
                text:context.error,
                color: AppColors.darkBlue,))
              :CustomListView(
            enableBorder: false,
            enableDivider: false,
            separatorHeight: 2.h,
            isScrollable: true,
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            children: _notifications
                .map(
                  (e) =>
                  CustomListViewItem(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.5.h,
                    ),
                    height: 11.h,
                    enableBorder: true,
                    borderRadius: BorderRadius.circular(12),
                    trailing: const SizedBox(),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultAppText(
                          text: e.title,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: 'You have obtained'),
                              TextSpan(
                                text: "  ${context.countPoints('30')} ",
                                style: const TextStyle(
                                  color: AppColors.red,
                                ),
                              ),
                              TextSpan(
                                text: '   From 6 Hours',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isDark ? AppColors.white : AppColors
                                      .grey,
                                ),
                              ),
                            ],
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.white : AppColors
                                  .darkGrey,
                            ),
                          ),
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            height: 1.5,
                            wordSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    onClick: null,
                  ),
            )
                .toList(),
          );
        },
      ),
    );
  }
}
