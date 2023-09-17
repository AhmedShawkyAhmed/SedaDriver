import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../business_logic/orders_cubit/orders_cubit.dart';
import '../../constants/constants_variables.dart';

class HistoryDetailsScreen extends StatefulWidget {
  const HistoryDetailsScreen({Key? key}) : super(key: key);

  @override
  State<HistoryDetailsScreen> createState() => _HistoryDetailsScreenState();
}

class _HistoryDetailsScreenState extends State<HistoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title:
            'Id : ${OrdersCubit.get(context).orderDetails!.data!.orders!.id}',
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
        final order = OrdersCubit.get(context).orderDetails!.data!.orders;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            margin: EdgeInsets.only(right: 20, left: 20, bottom: 7.h, top: 3.h),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1,
                color: isDark ? AppColors.white : AppColors.darkGrey,
              ),
              color: isDark ? AppColors.darkBlue : AppColors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultAppText(
                        text: order!.createdAtStr!.split(' ').first,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                      ),
                      Container(
                        height: 3.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                          color: order.status == "end"
                              ? AppColors.midGreen
                              : AppColors.red,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DefaultAppText(
                              text: order.status == "end"
                                  ? context.completed
                                  : context.cancelled,
                              fontWeight: FontWeight.w400,
                              fontSize: 10.sp,
                              color: AppColors.white,
                            ),
                            order.status == "end"
                                ? Icon(
                                    Icons.check,
                                    color: AppColors.white,
                                    size: 10.sp,
                                  )
                                : Icon(
                                    Icons.close_rounded,
                                    color: AppColors.white,
                                    size: 10.sp,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                            Column(
                                children: List.generate(
                              order.toLocation!.length,
                              (index) => Column(
                                children: [
                                  Container(
                                    height: 48+(2.0*index),
                                    width: 2,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    decoration: const BoxDecoration(
                                      color: AppColors.blue,
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                    width: 10,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    decoration: BoxDecoration(
                                        color: AppColors.red,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(10)),
                                child: DefaultAppText(
                                  text: order.fromLocation!.address ?? "-",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.sp,
                                  color: AppColors.black,
                                  maxLines: 1,
                                ),
                              ),
                              Column(
                                  children: List.generate(
                                order.toLocation!.length,
                                (index) => Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                      color: AppColors.lightGrey,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DefaultAppText(
                                    text: order.toLocation![index].address!,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10.sp,
                                    color: AppColors.black,
                                    maxLines: 1,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  color: AppColors.lightGrey,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: DefaultAppText(
                                text: context.distance,
                                fontWeight: FontWeight.w400,
                                fontSize: 10.sp,
                                color: AppColors.black,
                              ),
                            ),
                            DefaultAppText(
                              text:
                                  "${(double.parse(order.distance??'-') / 1000).ceil()} km",
                              fontWeight: FontWeight.w400,
                              fontSize: 10.sp,
                              textAlign: TextAlign.center,
                              color: AppColors.midBlue,
                            ),
                          ],
                        ),
                        const VerticalDivider(
                          thickness: 1,
                          width: 0,
                          color: AppColors.black,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: DefaultAppText(
                                text: context.time,
                                fontWeight: FontWeight.w400,
                                fontSize: 10.sp,
                                color: AppColors.black,
                              ),
                            ),
                            DefaultAppText(
                              text: order.timeTaken ?? '-',
                              fontWeight: FontWeight.w400,
                              fontSize: 10.sp,
                              textAlign: TextAlign.center,
                              color: AppColors.midBlue,
                            ),
                          ],
                        ),
                        const VerticalDivider(
                          thickness: 1,
                          width: 0,
                          color: AppColors.black,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: DefaultAppText(
                                text: context.rate,
                                fontWeight: FontWeight.w400,
                                fontSize: 10.sp,
                                color: AppColors.black,
                              ),
                            ),
                            Row(
                              children: [
                                DefaultAppText(
                                  text: order.user?.rate??'-',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.sp,
                                  color: AppColors.black,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Icon(
                                  Icons.star,
                                  color: AppColors.yellow,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultAppText(
                            text: 'Trip Fares',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                          DefaultAppText(
                            text: '50.00 SAR',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultAppText(
                            text: 'App Fees',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                          DefaultAppText(
                            text: '5 SAR',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultAppText(
                            text: 'Tax',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                          DefaultAppText(
                            text: '50.00 SAR',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultAppText(
                            text: 'Tolls',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                          DefaultAppText(
                            text: '50.00 SAR',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultAppText(
                            text: 'Discount',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                          DefaultAppText(
                            text: '50.00 SAR',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultAppText(
                            text: 'Top up added',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                          DefaultAppText(
                            text: '20.00 SAR',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 20),
                  child: Divider(
                    color: isDark ? AppColors.white : AppColors.darkGrey,
                    thickness: 1,
                    height: 0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultAppText(
                        text: 'Total Earning',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: isDark ? AppColors.white : AppColors.midBlue,
                      ),
                      DefaultAppText(
                        text: '200.14 SAR',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: isDark ? AppColors.white : AppColors.midBlue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
