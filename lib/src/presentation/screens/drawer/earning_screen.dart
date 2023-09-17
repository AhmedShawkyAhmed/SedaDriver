import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/views/custom_tab_bar.dart';
import 'package:seda_driver/src/presentation/views/earning_screen_views/earning_daily_profit_view.dart';
import 'package:seda_driver/src/presentation/views/earning_screen_views/earning_previous_earns_view.dart';
import 'package:seda_driver/src/presentation/views/earning_screen_views/earning_previous_trips_view.dart';

import '../../../business_logic/orders_cubit/orders_cubit.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({Key? key}) : super(key: key);

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  List<String> _titles(BuildContext context) => [
        context.dailyProfit,
        context.previousEarns,
        context.previousTrips,
      ];

  @override
  void initState() {
    OrdersCubit.get(context).getDriverEarnings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.earning,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            CustomTabBar(
              tabs: _titles(context),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  EarningDailyProfitView(),
                  EarningPreviousEarnsView(),
                  EarningPreviousTripsView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
