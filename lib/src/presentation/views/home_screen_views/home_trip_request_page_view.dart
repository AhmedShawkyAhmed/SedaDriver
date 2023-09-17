import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:seda_driver/src/business_logic/orders_cubit/orders_cubit.dart';
import 'package:seda_driver/src/business_logic/socket_cubit/socket_cubit.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_trip_request_card_view.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:seda_driver/src/presentation/widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class HomeTripRequestPageView extends StatelessWidget {
  const HomeTripRequestPageView({
    super.key,
    required this.pageController,
    required this.currentPageIndex,
    required this.showTripRequest,
    required this.showTripProgress,
    required this.setPolyLine,
    required this.cubit,
    required this.getDropLocation, required this.onAcceptOrder,
  });

  final SocketCubit cubit;
  final PageController pageController;
  final ValueNotifier<int> currentPageIndex;
  final ValueNotifier<bool> showTripRequest;
  final ValueNotifier<bool> showTripProgress;
  final Function() getDropLocation;
  final Function() onAcceptOrder;
  final Function(
    PointLatLng origin,
    PointLatLng destination,
    BuildContext context,
  ) setPolyLine;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        itemCount: cubit.orderResponses.length,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (int index) {
          currentPageIndex.value = index;
        },
        itemBuilder: (context, index) {
          return ValueListenableBuilder(
              valueListenable: currentPageIndex,
              builder: (context, pageIndex, child) {
                log(pageIndex.toString(),name: "Fuck!!!!!!");
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.h, horizontal: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (pageIndex != 0)
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (pageIndex > 0) {
                                    currentPageIndex.value--;
                                    final pageIndex = currentPageIndex.value;
                                    pageController.animateToPage(pageIndex,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut);
                                    setPolyLine(
                                            PointLatLng(
                                              cubit
                                                  .orderResponses[pageIndex]
                                                  .orderModel!
                                                  .fromLocation!
                                                  .latitude!,
                                              cubit
                                                  .orderResponses[pageIndex]
                                                  .orderModel!
                                                  .fromLocation!
                                                  .longitude!,
                                            ),
                                            PointLatLng(
                                              cubit
                                                  .orderResponses[pageIndex]
                                                  .orderModel!
                                                  .toLocation!
                                                  .last
                                                  .latitude!,
                                              cubit
                                                  .orderResponses[pageIndex]
                                                  .orderModel!
                                                  .toLocation!
                                                  .last
                                                  .longitude!,
                                            ),
                                            context)
                                        .then(
                                      (value) => getDropLocation(),
                                    );
                                  }
                                },
                                child: DefaultAppText(
                                  text: '<<< previous',
                                  color: AppColors.darkBlue,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          if (pageIndex != (cubit.orderResponses.length - 1))
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (pageIndex < cubit.orderResponses.length) {
                                    currentPageIndex.value++;
                                    final pageIndex = currentPageIndex.value;
                                    pageController.animateToPage(pageIndex,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut);
                                    setPolyLine(
                                            PointLatLng(
                                              cubit
                                                  .orderResponses[pageIndex]
                                                  .orderModel!
                                                  .fromLocation!
                                                  .latitude!,
                                              cubit
                                                  .orderResponses[pageIndex]
                                                  .orderModel!
                                                  .fromLocation!
                                                  .longitude!,
                                            ),
                                            PointLatLng(
                                              cubit
                                                  .orderResponses[pageIndex]
                                                  .orderModel!
                                                  .toLocation!
                                                  .last
                                                  .latitude!,
                                              cubit
                                                  .orderResponses[pageIndex]
                                                  .orderModel!
                                                  .toLocation!
                                                  .last
                                                  .longitude!,
                                            ),
                                            context)
                                        .then(
                                      (value) => getDropLocation(),
                                    );
                                  }
                                },
                                child: DefaultAppText(
                                  text: 'next >>>',
                                  textAlign: TextAlign.right,
                                  color: AppColors.darkBlue,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    HomeTripRequestCardView(
                      onAccept: () {
                        if (cubit.orderResponses[index].orderModel?.id !=
                            null) {
                          showDialog(
                            context: context,
                            builder: (_) => WillPopScope(
                              onWillPop: () => Future.value(false),
                              child: const LoadingIndicator(),
                            ),
                          );
                          OrdersCubit.get(context).acceptedByDriver(
                            orderId:
                                cubit.orderResponses[index].orderModel!.id!,
                            afterSuccess: () {
                              showTripRequest.value = false;
                              cubit.emitState(
                                SocketOrderAcceptedByDriver(),
                              );
                              cubit.orderResponse = cubit.orderResponses[index];
                              cubit.clearOrdersList();
                              onAcceptOrder.call();
                              showTripProgress.value = true;
                              Navigator.pop(context);
                            },
                            afterError: () => Navigator.pop(context),
                          );
                        } else {
                          logError('Order Id is null');
                        }
                      },
                      onCancel: () {
                        if (cubit.orderResponses[index].orderModel?.id !=
                            null) {
                          showDialog(
                            context: context,
                            builder: (_) => WillPopScope(
                              onWillPop: () => Future.value(false),
                              child: const LoadingIndicator(),
                            ),
                          );
                          OrdersCubit.get(context).canceledByDriver(
                            orderId:
                                cubit.orderResponses[index].orderModel!.id!,
                            afterSuccess: () {
                              Navigator.pop(context);
                              SocketCubit.get(context).changeStatus();
                              cubit.orderResponses.removeWhere((e) =>
                                  e.orderModel?.id ==
                                  cubit.orderResponses[index].orderModel!.id);
                              if(cubit.orderResponses.isNotEmpty){
                                currentPageIndex.value = 0;
                                pageController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                              if (cubit.orderResponses.isEmpty) {
                                showTripRequest.value = false;
                              }
                            },
                            cancelReason: 'some reason',
                            afterError: () => Navigator.pop(context),
                          );
                        } else {
                          logError('Order Id is null');
                        }
                      },
                      orderModel: cubit.orderResponses[index].orderModel!,
                    ),
                  ],
                );
              });
        });
  }
}
