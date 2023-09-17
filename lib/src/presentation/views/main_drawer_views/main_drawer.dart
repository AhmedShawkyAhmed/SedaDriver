import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seda_driver/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda_driver/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda_driver/src/business_logic/orders_cubit/orders_cubit.dart';
import 'package:seda_driver/src/business_logic/socket_cubit/socket_cubit.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/views/custom_profile_image_view.dart';
import 'package:seda_driver/src/presentation/views/main_drawer_views/main_drawer_header.dart';
import 'package:seda_driver/src/presentation/views/main_drawer_views/settings_view.dart';
import 'package:seda_driver/src/presentation/widgets/loading_indicator.dart';
import 'package:seda_driver/src/services/cache_helper.dart';
import 'package:sizer/sizer.dart';

import '../../../business_logic/app_cubit/app_cubit.dart';
import '../../../constants/constants_variables.dart';
import '../../widgets/default_app_text.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Map<int, dynamic> _getItemViewData(BuildContext context, int index) {
    final result = <int, dynamic>{};
    switch (index) {
      case 0:
        result[0] = SvgPicture.asset(
          AppAssets.icNotification,
          color: isDark ? AppColors.white : AppColors.black,
        );
        result[1] = context.notification;
        result[2] = () => Navigator.pushNamed(
              context,
          AppRouterNames.notifications,
            );
        return result;
      case 1:
        result[0] = SvgPicture.asset(
          AppAssets.icHistory,
          color: isDark ? AppColors.white : AppColors.black,
        );
        result[1] = context.history;
        result[2] = () => Navigator.pushNamed(
              context,
          AppRouterNames.history,
            );
        return result;
      case 2:
        result[0] = SvgPicture.asset(
          AppAssets.icWallet,
          color: isDark ? AppColors.white : AppColors.black,
        );
        result[1] = context.wallet;
        result[2] = () => Navigator.pushNamed(
              context,
          AppRouterNames.wallet,
            );
        return result;
      case 3:
        result[0] = SvgPicture.asset(
          AppAssets.icEarning,
          color: isDark ? AppColors.white : AppColors.black,
        );
        result[1] = context.earning;
        result[2] = () => Navigator.pushNamed(
              context,
          AppRouterNames.earning,
            );
        return result;
      case 4:
        result[0] = SvgPicture.asset(
          AppAssets.icPoints,
          color: isDark ? AppColors.white : AppColors.black,
        );
        result[1] = context.points;
        result[2] = () => Navigator.pushNamed(
              context,
          AppRouterNames.points,
            );
        return result;
      case 5:
        result[0] = SvgPicture.asset(
          AppAssets.icPrivacy,
          color: isDark ? AppColors.white : AppColors.black,
        );
        result[1] = context.privacyPolicy;
        result[2] = () => Navigator.pushNamed(
              context,
          AppRouterNames.privacyPolicy,
            );
        return result;
      case 6:
        result[0] = SvgPicture.asset(
          AppAssets.icInviteFriends,
          color: isDark ? AppColors.white : AppColors.black,
        );
        result[1] = context.inviteFriends;
        result[2] = () => Navigator.pushNamed(
              context,
          AppRouterNames.inviteFriends,
            );
        return result;
      case 7:
        result[0] = SvgPicture.asset(
          AppAssets.icSubscriptions,
          color: isDark ? AppColors.white : AppColors.black,
        );
        result[1] = context.subscriptions;
        result[2] = () => Navigator.pushNamed(
              context,
          AppRouterNames.subscriptions,
              arguments: {'confirmed': ''},
            );
        return result;
      case 8:
        result[0] = SvgPicture.asset(
          AppAssets.icLogout,
          color: isDark ? AppColors.white : AppColors.black,
        );
        result[1] = context.logout;
        result[2] = () {
          showDialog(
            context: context,
            builder: (_) => WillPopScope(
              onWillPop: () => Future.value(false),
              child: const LoadingIndicator(),
            ),
          );
          AuthCubit.get(context).logout(
            afterSuccess: () async {
              await GlobalCubit.get(context).endUpdateActiveLocation();
              SocketCubit.get(context).socket.disconnect();
              await CacheHelper.clearData();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouterNames.login,
                (route) => false,
              );
            },
            afterError: () => Navigator.pop(context),
          );
        };
        return result;
      default:
        return result;
    }
  }

  @override
  void initState() {
    OrdersCubit.get(context).getDriverStatistics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      return BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final cubit = AuthCubit.get(context);
          return Container(
            height: 92.h,
            width: 100.w,
            color: AppColors.transparent,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 88.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBlue : AppColors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      children: [
                        MainDrawerHeader(),
                        SizedBox(
                          height: 1.h,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkBlue
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: [
                                      BoxShadow(
                                          color: isDark
                                              ? AppColors.white
                                              : AppColors.black
                                                  .withOpacity(0.2),
                                          offset: const Offset(0, 4),
                                          blurRadius: 10,
                                          spreadRadius: 0)
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: const SettingsView(),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  alignment: Alignment.center,
                                  child: CustomListView(
                                    enableBorder: false,
                                    enableDivider: false,
                                    children: List.generate(
                                      9,
                                      (index) => Column(
                                        children: [
                                          CustomListViewItem(
                                            height: 6.h,
                                            leadingTitleSpacing: 6.w,
                                            leading: _getItemViewData(
                                                context, index)[0],
                                            trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              color: isDark
                                                  ? AppColors.white
                                                  : AppColors.darkGrey
                                                      .withOpacity(0.7),
                                            ),
                                            titleText: _getItemViewData(
                                                context, index)[1],
                                            titleFontSize: 13.sp,
                                            titleColor: isDark
                                                ? AppColors.white
                                                : AppColors.darkGrey
                                                    .withOpacity(0.7),
                                            titleFontWeight: FontWeight.w500,
                                            onClick: _getItemViewData(
                                                context, index)[2],
                                          ),
                                          if (index != 10)
                                            const Divider(
                                              indent: 15,
                                              endIndent: 30,
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AppRouterNames.profile);
                          },
                          child: SizedBox(
                            height: 9.h,
                            child: CustomProfileImageView(
                              backgroundColor: AppColors.lightGrey,
                              iconColor: AppColors.white,
                              view: true,
                              networkImage:
                                  cubit.currentUser?.userBasicInfo?.image !=
                                          null
                                      ? Image.network(
                                          "${EndPoints.imageBaseUrl}${cubit.currentUser?.userBasicInfo?.image}",
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          padding: const EdgeInsets.only(
                            top: 4,
                            bottom: 4,
                            left: 8,
                            right: 8,
                          ),
                          margin: EdgeInsets.only(
                            top: 7.5.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 9.sp,
                              ),
                              SizedBox(
                                width: 0.5.w,
                              ),
                              DefaultAppText(
                                text:
                                    ' (${cubit.currentUser?.userBasicInfo?.rate ?? 0})',
                                color: AppColors.black,
                                fontSize: 8.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 6.h,
                  right: 6.w,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
