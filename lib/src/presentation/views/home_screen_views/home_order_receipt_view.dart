import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/business_logic/orders_cubit/orders_cubit.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_order_rate_user_view.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';
import '../../styles/app_assets.dart';
import '../../styles/app_colors.dart';
import '../../widgets/default_app_button.dart';
import '../../widgets/default_app_text.dart';

class ReceiptView extends StatelessWidget {
  const ReceiptView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          final order = OrdersCubit.get(context).endOrderResponse!.data![0];
          return Container(
            // height: 70.h,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBlue : AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 2.4.h),
                DefaultAppText(
                  text: context.receiptForTheTrip,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  height: 20.h,
                  child: Stack(
                    children: [
                      ClipPath(
                          clipper: CustomClipPath(),
                          child: Container(
                            width: 100.w,
                            height: 17.h,
                            alignment: Alignment.topLeft,
                            color: isDark
                                ? AppColors.lightGrey
                                : AppColors.lightBlue.withOpacity(0.07),
                            padding: const EdgeInsets.only(
                              left: 30,
                              right: 30,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: 2.h,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: DefaultAppText(
                                    text: order.createdAtStr ?? '',
                                    color: AppColors.darkGrey,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 2.5.h,
                                      ),
                                      DefaultAppText(
                                        text: context.totalPrice,
                                        color: AppColors.darkGrey,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      DefaultAppText(
                                        text: order.price ?? '',
                                        color: AppColors.darkGrey,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Positioned(
                          top: 8.h,
                          right: 4.w,
                          child: Image.asset(
                            AppAssets.imgCar,
                            // color: AppColors.green,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultAppText(
                        text: context.tripFares,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                      DefaultAppText(
                        text: order.userPrice ?? '',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultAppText(
                        text: context.appFees,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                      DefaultAppText(
                        text: order.discount ?? '',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultAppText(
                        text: context.tax,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                      DefaultAppText(
                        text: order.userTax ?? '',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: isDark ? AppColors.white : AppColors.black,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultAppText(
                        text: context.subtotal,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                      ),
                      DefaultAppText(
                        text: order.price ?? '',
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(AppAssets.icCash1),
                      SizedBox(
                        width: 2.w,
                      ),
                      DefaultAppText(
                        text: order.paymentTypeId!.name,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                DefaultAppButton(
                    text: context.rateUser,
                    width: 60.w,
                    height: 5.5.h,
                    backgroundColor: isDark ? AppColors.lightGrey : null,
                    textColor: isDark ? AppColors.darkBlue : AppColors.white,
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: false,
                          enableDrag: false,
                          backgroundColor: AppColors.transparent,
                          builder: (context) => const RateUserView());
                    }),
                SizedBox(height: 3.h),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  // var radius = 5.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, 12.h);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width * (2 / 3), size.height * (2 / 3));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
