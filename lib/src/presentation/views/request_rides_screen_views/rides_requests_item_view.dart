import 'package:flutter/material.dart';
import 'package:seda_driver/src/data/models/new/rides.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/views/request_rides_screen_views/offer_ride_bottom_sheet.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

class RidesRequestsItemView extends StatelessWidget {
  const RidesRequestsItemView({
    Key? key,
    required this.page,
    required this.rides,
  }) : super(key: key);

  final String page;
  final Rides rides;

  @override
  Widget build(BuildContext context) {
    return CustomListViewItem(
      height: 32.h,
      enableBorder: true,
      trailing: const SizedBox(),
      borderRadius: BorderRadius.circular(12),
      borderColor: AppColors.midBlue,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DefaultAppText(
                  text: page == 'Price'
                      ? 'Negotiable Fare for ${rides.passenger} passenger'
                      : page == 'Hours'
                          ? '${rides.estimatedTime?.toInt()} hours  for ${rides.passenger} passenger'
                          : 'Fare for ${rides.passenger} passenger',
                  fontWeight: FontWeight.w400,
                  fontSize: 10.sp,
                  color: AppColors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    page == 'Hours'
                        ? Container(
                            height: 3.5.h,
                            width: 8.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.midBlue,
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: DefaultAppText(
                              text: '${rides.cost?.toInt()}',
                              fontWeight: FontWeight.w400,
                              fontSize: 10.sp,
                              color: AppColors.white,
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(
                      width: 2.w,
                    ),
                    Container(
                      height: 3.5.h,
                      width: 15.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.midGrey,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: DefaultAppText(
                        text: 'Cash',
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          child: Row(
                            children: [
                              Image.asset(
                                AppAssets.icClock,
                                scale: 0.75,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              DefaultAppText(
                                text: rides.date,
                                fontWeight: FontWeight.w400,
                                fontSize: 10.sp,
                                color: AppColors.black,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          child: Row(
                            children: [
                              Image.asset(
                                AppAssets.icStartLocation,
                                scale: 0.75,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              DefaultAppText(
                                text: rides.startLocation,
                                fontWeight: FontWeight.w400,
                                fontSize: 10.sp,
                                color: AppColors.black,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          child: Row(
                            children: [
                              Image.asset(
                                AppAssets.icEndLocation,
                                scale: 0.75,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              DefaultAppText(
                                text: rides.endLocation,
                                fontWeight: FontWeight.w400,
                                fontSize: 10.sp,
                                color: AppColors.black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRouterNames.historyDetails,
                          arguments: {
                            'id': "asdasdasd",
                          },
                        );
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.midBlue,
                        size: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child: const Divider(
              thickness: 2,
              height: 0,
              color: AppColors.grey,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(rides.user.userImage),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultAppText(
                      text: rides.user.userName,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: AppColors.black,
                    ),
                    DefaultAppText(
                      text: rides.user.userFromDate,
                      fontWeight: FontWeight.w400,
                      fontSize: 8.sp,
                      color: AppColors.grey,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      onClick: page == "Price"
          ? () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: const Color(0xFF757575),
                builder: (context) {
                  return OfferRideBottomSheet(
                    page: page,
                    rides: rides,
                  );
                },
              );
            }
          : null,
    );
  }
}
