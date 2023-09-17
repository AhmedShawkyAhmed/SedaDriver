import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/earning_screen_views/earning_common_view.dart';
import 'package:seda_driver/src/presentation/views/earning_screen_views/linear_pie_chart_view.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../business_logic/orders_cubit/orders_cubit.dart';
import '../../../constants/constants_variables.dart';

class EarningPreviousEarnsView extends StatefulWidget {
  const EarningPreviousEarnsView({Key? key}) : super(key: key);

  @override
  State<EarningPreviousEarnsView> createState() =>
      _EarningPreviousEarnsViewState();
}

class _EarningPreviousEarnsViewState extends State<EarningPreviousEarnsView> {
  int index = 0;
  int length = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
      final cubit = OrdersCubit.get(context);
      length = cubit.previousEarning!.length;
      return EarningCommonView(
        id: 2,
        index: index,
        earningPageIdentifierView: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      index--;
                      if (index >= 0) {
                        setState(() {});
                      } else {
                        index++;
                      }
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: isDark ? AppColors.white : AppColors.darkBlue,
                    ),
                  ),
                  Column(
                    children: [
                      DefaultAppText(
                        text:
                            '${cubit.previousEarning?[index].dayStr ?? "-"}, ${cubit.previousEarning?[index].day ?? "-"}',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: isDark ? AppColors.white : AppColors.darkBlue,
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      DefaultAppText(
                        text:
                            '${cubit.previousEarning?[index].earning ?? "-"} SAR',
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      index++;
                      if (index <= (length - 1)) {
                        setState(() {});
                      } else {
                        index--;
                      }
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: isDark ? AppColors.white : AppColors.darkBlue,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            SizedBox(
              height: 27.h,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: LinearPieChartView(
                    maxUi: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
