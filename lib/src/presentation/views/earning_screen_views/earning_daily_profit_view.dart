import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/earning_screen_views/earning_common_view.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../business_logic/orders_cubit/orders_cubit.dart';
import '../../../constants/constants_variables.dart';

class EarningDailyProfitView extends StatefulWidget {
  const EarningDailyProfitView({Key? key}) : super(key: key);

  @override
  State<EarningDailyProfitView> createState() => _EarningDailyProfitViewState();
}

class _EarningDailyProfitViewState extends State<EarningDailyProfitView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
      final cubit = OrdersCubit.get(context);
      return EarningCommonView(
        id: 1,
        earningPageIdentifierView: Column(
          children: [
            DefaultAppText(
              text:
                  '${cubit.dailyEarning?.dayStr ?? "-"}, ${cubit.dailyEarning?.day ?? "-"}',
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: isDark ? AppColors.white : AppColors.darkBlue,
            ),
            SizedBox(
              height: 1.5.h,
            ),
            DefaultAppText(
              text: '${cubit.dailyEarning?.earning ?? "-"} SAR',
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ],
        ),
      );
    });
  }
}
