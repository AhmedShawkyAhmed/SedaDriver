import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seda_driver/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/models/order_model.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_profile_image_view.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_trip_request_draggable_view.dart';
import 'package:seda_driver/src/presentation/widgets/custom_progress_indicator.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';

class HomeTripRequestCardView extends StatefulWidget {
  const HomeTripRequestCardView({
    Key? key,
    required this.onAccept,
    required this.onCancel,
    required this.orderModel,
  }) : super(key: key);

  final OrderModel orderModel;
  final Function() onAccept;
  final Function() onCancel;

  @override
  State<HomeTripRequestCardView> createState() =>
      _HomeTripRequestCardViewState();
}

class _HomeTripRequestCardViewState extends State<HomeTripRequestCardView> {
  @override
  void initState() {
    GlobalCubit.getDistanceMatrix(
        fromLat: widget.orderModel.fromLocation!.latitude!,
        fromLon: widget.orderModel.fromLocation!.longitude!,
        toLat: widget.orderModel.toLocation!.last.latitude!,
        toLon: widget.orderModel.toLocation!.last.longitude!,
        afterSuccess: (t, d) {
          time = t.text!;
          setState(() {});
        });
    decreaseTime();
    super.initState();
  }

  String time = '';

  int _requestTime = 15;
  Timer? _decreaseTimer;
  void decreaseTime() {
    _decreaseTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_requestTime > 0) {
          setState(() {
            _requestTime--;
          });
        } else {
          _decreaseTimer?.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    _decreaseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeTripRequestDraggableView(
      onDragUp: widget.onAccept,
      onDragDown: widget.onCancel,
      child: SizedBox(
        height: widget.orderModel.toLocation?.length == 3
            ? 48.h
            : widget.orderModel.toLocation?.length == 2
                ? 44.h
                : 40.h,
        width: 100.w,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              top: 4.h,
              child: Container(
                width: 100.w,
                height: 100.h,
                margin: EdgeInsets.symmetric(
                  horizontal: 0.w,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBlue : AppColors.white,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(50), bottom: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? AppColors.white
                          : AppColors.black.withOpacity(0.25),
                      offset: const Offset(0, -2),
                      blurRadius: 3,
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                  vertical: 2.h,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 4.w,
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.orderModel.toLocation!.length + 1,
                            itemBuilder: (_, index) => index == 0
                                ? Container(
                                    width: 3.w,
                                    height: 3.w,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 0.5.w),
                                    decoration: BoxDecoration(
                                        color: AppColors.darkBlue,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  )
                                : Container(
                                    width: 3.w,
                                    height: 3.w,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 0.5.w),
                                    decoration: BoxDecoration(
                                        color: AppColors.midRed,
                                        borderRadius: BorderRadius.circular(3)),
                                  ),
                            separatorBuilder: (_, index) => Container(
                              width: 1,
                              height: 5.5.h + 4 * index,
                              margin: EdgeInsets.symmetric(horizontal: 1.7.w),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.lightGrey
                                    : AppColors.darkGrey,
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        SizedBox(
                          width: 58.w,
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.orderModel.toLocation!.length + 1,
                            itemBuilder: (_, index) => DefaultAppText(
                              text: index == 0
                                  ? (widget.orderModel.fromLocation?.address ??
                                      '')
                                  : (widget.orderModel.toLocation![index - 1]
                                          .address ??
                                      ''),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                            separatorBuilder: (_, index) => Container(
                              width: 1,
                              height: 3.5.h + 4 * index,
                              margin: EdgeInsets.symmetric(horizontal: 1.7.w),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        SizedBox(
                          width: 30.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  DefaultAppText(
                                    text:
                                        widget.orderModel.paymentTypeId?.name ??
                                            "",
                                    fontSize: 18.sp,
                                    color: AppColors.darkBlue,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                  ),
                                  SvgPicture.asset(
                                    AppAssets.icCashIcon,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Container(
                                padding: EdgeInsets.all(2.w),
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DefaultAppText(
                                  text: time.replaceAll(' ', '\n'),
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: AppColors.lightGrey,
                      thickness: 1.5,
                      height: 4.h,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 5.h,
                          width: 5.h,
                          child: CustomProfileImageView(
                            avatarIconPadding: 7,
                            view: true,
                            networkImage: widget.orderModel.user?.image != null
                                ? Image.network(
                                    "${EndPoints.imageBaseUrl}${widget.orderModel.user?.image}",
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        DefaultAppText(
                          text: widget.orderModel.user?.name ?? '',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.keyboard_double_arrow_down_rounded,
                                color:
                                    isDark ? AppColors.white : AppColors.black,
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              DefaultAppText(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                text: context.swipeDownCancel,
                                color: AppColors.red,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DefaultAppText(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w500,
                                text: context.swipeUpAccept,
                                color: AppColors.green,
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              Icon(
                                Icons.keyboard_double_arrow_up_rounded,
                                color:
                                    isDark ? AppColors.white : AppColors.black,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 1.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomProgressIndicator(
                    value: _requestTime / 15,
                    height: 6.h + 6,
                    width: 20.w + 6,
                    borderRadius: 30,
                    backgroundColor: AppColors.lightBlue.withOpacity(0.5),
                    progressColor: AppColors.midBlue,
                  ),
                  DefaultAppText(
                    text: '${widget.orderModel.price}',
                    fontSize: 20.sp,
                    color: isDark
                        ? AppColors.midBlue
                        : AppColors.white.withOpacity(_requestTime / 15),
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
