import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/data/models/new/rides.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/views/custom_profile_image_view.dart';
import 'package:seda_driver/src/presentation/views/request_rides_screen_views/offer_ride_suggest_price_bottom_sheet.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

class OfferRideBottomSheet extends StatelessWidget {
  const OfferRideBottomSheet({
    Key? key,
    required this.page,
    required this.rides,
  }) : super(key: key);

  final String page;
  final Rides rides;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          topLeft: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 0.7.h,
            width: 20.w,
            margin: EdgeInsets.only(bottom: 3.h),
            decoration: BoxDecoration(
              color: AppColors.midBlue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 0.5.h,
            ),
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
                            width: 10.w,
                            height: 2.5.h,
                            decoration: BoxDecoration(
                              color: AppColors.midBlue,
                              borderRadius: BorderRadius.circular(35),
                            ),
                            alignment: Alignment.center,
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
                      width: 18.w,
                      height: 2.5.h,
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      alignment: Alignment.center,
                      child: DefaultAppText(
                        text: context.cash,
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
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 0.5.h,
            ),
            child: Column(
              children: [
                CustomListViewItem(
                  height: 4.5.h,
                  padding: EdgeInsets.zero,
                  titleText: rides.date,
                  titleFontWeight: FontWeight.w400,
                  titleColor: AppColors.black,
                  titleFontSize: 10.sp,
                  leading: Image.asset(
                    AppAssets.icClock,
                    scale: 0.75,
                  ),
                  trailing: const SizedBox(),
                  onClick: null,
                ),
                CustomListViewItem(
                  height: 4.5.h,
                  padding: EdgeInsets.zero,
                  titleText: rides.startLocation,
                  titleFontWeight: FontWeight.w400,
                  titleColor: AppColors.black,
                  titleFontSize: 10.sp,
                  leading: Image.asset(
                    AppAssets.icStartLocation,
                    scale: 0.75,
                  ),
                  trailing: const SizedBox(),
                  onClick: null,
                ),
                CustomListViewItem(
                  height: 4.5.h,
                  padding: EdgeInsets.zero,
                  titleText: rides.endLocation,
                  titleFontWeight: FontWeight.w400,
                  titleColor: AppColors.black,
                  titleFontSize: 10.sp,
                  leading: Image.asset(
                    AppAssets.icEndLocation,
                    scale: 0.75,
                  ),
                  trailing: const SizedBox(),
                  onClick: null,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 1.h,
              horizontal: 5.w,
            ),
            child: const Divider(
              thickness: 2,
              height: 2,
              color: AppColors.midGrey,
            ),
          ),
          CustomListViewItem(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultAppText(
                  text: rides.user.userName,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: AppColors.black,
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                DefaultAppText(
                  text: rides.user.userFromDate,
                  fontWeight: FontWeight.w500,
                  fontSize: 9.sp,
                  color: AppColors.grey,
                ),
              ],
            ),
            trailing: const SizedBox(),
            leading: SizedBox(
              height: 6.h,
              width: 6.h,
              child: CustomProfileImageView(
                view: true,
                networkImage: Image.asset(
                  rides.user.userImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            leadingTitleSpacing: 4.w,
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            onClick: null,
          ),
          DefaultAppButton(
            text: context.suggestPrice,
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: const Color(0xFF757575),
                  builder: (context) {
                    return const OfferRideSuggestPriceBottomSheet();
                  });
            },
            fontSize: 13.sp,
            width: 80.w,
            margin: EdgeInsets.symmetric(vertical: 3.h),
          ),
          DefaultAppButton(
            width: 80.w,
            margin: EdgeInsets.only(bottom: 3.h),
            backgroundColor: AppColors.transparent,
            text: context.close,
            enableBorder: true,
            borderColor: AppColors.midBlue,
            textColor: AppColors.midBlue,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
