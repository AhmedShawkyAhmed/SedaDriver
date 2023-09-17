import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';

class LinearPieChartView extends StatelessWidget {
  const LinearPieChartView({Key? key, required this.maxUi}) : super(key: key);

  final bool maxUi;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      mainBarData(),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool max = false,
    bool min = false,
    Color? barColor,
    double width = 30,
  }) {
    barColor ??= AppColors.grey;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: max
              ? AppColors.midGreen
              : min
                  ? AppColors.red
                  : AppColors.grey,
          width: width,
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: AppColors.midGreen, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: false,
          ),
        ),
      ],
      // showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 40);
          case 1:
            return makeGroupData(1, 55);
          case 2:
            return makeGroupData(2, 100, max: maxUi);
          case 3:
            return makeGroupData(3, 35);
          case 4:
            return makeGroupData(4, 65);
          case 5:
            return makeGroupData(5, 80);
          case 6:
            return makeGroupData(6, 73);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const DefaultAppText(
          text: 'Sat',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGrey,
        );
        break;
      case 1:
        text = const DefaultAppText(
          text: 'Sun',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGrey,
        );
        break;
      case 2:
        text = const DefaultAppText(
          text: 'Mon',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGrey,
        );
        break;
      case 3:
        text = const DefaultAppText(
          text: 'Tue',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGrey,
        );
        break;
      case 4:
        text = const DefaultAppText(
          text: 'Wed',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGrey,
        );
        break;
      case 5:
        text = const DefaultAppText(
          text: 'Tur',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGrey,
        );
        break;
      case 6:
        text = const DefaultAppText(
          text: 'Fri',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGrey,
        );
        break;
      default:
        text = const DefaultAppText(
          text: '',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGrey,
        );
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}
