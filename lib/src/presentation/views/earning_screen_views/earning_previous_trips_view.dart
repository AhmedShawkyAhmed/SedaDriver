import 'package:flutter/material.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/earning_screen_views/earning_common_view.dart';
import 'package:seda_driver/src/presentation/views/earning_screen_views/linear_pie_chart_view.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';

class EarningPreviousTripsView extends StatefulWidget {
  const EarningPreviousTripsView({Key? key}) : super(key: key);

  @override
  State<EarningPreviousTripsView> createState() =>
      _EarningPreviousTripsViewState();
}

class _EarningPreviousTripsViewState extends State<EarningPreviousTripsView> {
  @override
  Widget build(BuildContext context) {
    return EarningCommonView(
      id: 3,
      earningPageIdentifierView: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? AppColors.white : AppColors.darkBlue,
                ),
                DefaultAppText(
                  text: 'Mon, 12 Feb 2023',
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: isDark ? AppColors.white : AppColors.darkBlue,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDark ? AppColors.white : AppColors.darkBlue,
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
                  maxUi: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
