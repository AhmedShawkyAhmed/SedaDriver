import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:seda_driver/src/business_logic/orders_cubit/orders_cubit.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/views/history_screen_views/history_item_view.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';
import '../../router/app_routes_names.dart';
import '../../widgets/loading_indicator.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  double rate = 5;
  int currentPage = 1;
  bool loadMore = false;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    OrdersCubit.get(context).getHistory(
        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        afterSuccess: () {});
    _controller.addListener(() async {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          if (kDebugMode) {
            print('At the top');
          }
        } else {
          if (kDebugMode) {
            print('At the bottom');
          }
          if (currentPage < OrdersCubit.get(context).pages && !loadMore) {
            loadMore = true;
            currentPage += 1;
            await OrdersCubit.get(context).getHistory(
                date: DateFormat('dd-MM-yyyy').format(date),
                afterSuccess: () {},
                page: currentPage);
            loadMore = false;
          }
        }
      }
    });
    super.initState();
  }

  String shownDay = DateFormat('EE,  dd MMM yyyy').format(DateTime.now());
  int index = 0;
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 5.h,
        title: context.history,
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
        final historyOrders =
            OrdersCubit.get(context).ordersHistory.data.orders;
        return Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.midBlue,
              //   margin: EdgeInsets.only(bottom: 2.h,),
              padding: EdgeInsets.only(
                  left: 10.w, right: 10.w, bottom: 2.h, top: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        index = 1;
                        currentPage = 1;
                      });
                      if (index != 0) {
                        date = date.subtract(Duration(days: index));
                        OrdersCubit.get(context).getHistory(
                            date: DateFormat('dd-MM-yyyy').format(date),
                            afterSuccess: () {
                              setState(() {
                                shownDay =
                                    DateFormat('EE,  dd MMM yyyy').format(date);
                                index++;
                              });
                            });
                      }
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.white,
                    ),
                  ),
                  DefaultAppText(
                    text: shownDay,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: AppColors.white,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        index = 1;
                        currentPage = 1;
                      });
                      if (index != 0) {
                        date = date.add(Duration(days: index));
                        OrdersCubit.get(context).getHistory(
                            date: DateFormat('dd-MM-yyyy').format(date),
                            afterSuccess: () {
                              setState(() {
                                shownDay =
                                    DateFormat('EE,  dd MMM yyyy').format(date);
                                index++;
                              });
                            });
                      }
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              color: isDark ? AppColors.white : AppColors.darkGrey,
            ),
            Expanded(
              child: SizedBox(
                  width: 100.w,
                  height: 70.h,
                  child: state is GetOrderHistorySuccessState &&
                          historyOrders.isEmpty
                      ? Center(
                          child: DefaultAppText(
                            text: context.noHistoryHere,
                            color: isDark ? AppColors.white : AppColors.black,
                            fontSize: 20.sp,
                          ),
                        )
                      : ListView.builder(
                          controller: _controller,
                          padding: EdgeInsets.zero,
                          itemCount: state is GetOrderHistoryLoadingState
                              ? historyOrders.length + 1
                              : historyOrders.length,
                          itemBuilder: (context, position) {
                            // print(historyOrders[position].status);
                            if (state is GetOrderHistoryLoadingState &&
                                position == historyOrders.length) {
                              return SizedBox(
                                height: 70.h,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: HistoryItemView(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const LoadingIndicator(),
                                  );
                                  OrdersCubit.get(context).getOrderDetails(
                                    afterSuccess: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                        context,
                                        AppRouterNames.historyDetails,
                                      );
                                    },
                                    afterError: () => Navigator.pop(context),
                                    id: historyOrders[position].id,
                                  );
                                },
                                tripHistory: historyOrders[position],
                              ),
                            );
                          })),
            ),
          ],
        );
      }),
    );
  }
}
