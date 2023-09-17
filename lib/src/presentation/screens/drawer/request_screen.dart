import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/data/models/new/rides.dart';
import 'package:seda_driver/src/data/models/new/user_ride.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view.dart';
import 'package:seda_driver/src/presentation/views/custom_tab_bar.dart';
import 'package:seda_driver/src/presentation/views/request_rides_screen_views/ride_type_page_item_view.dart';
import 'package:seda_driver/src/presentation/views/request_rides_screen_views/rides_requests_item_view.dart';
import 'package:sizer/sizer.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _pages = <List<dynamic>>[
    [
      'Price',
      true,
      AppAssets.icPrice,
    ],
    [
      'Hours',
      false,
      AppAssets.icClock,
    ],
    [
      'City To City',
      false,
      AppAssets.icCityToCity,
    ],
    [
      'City Rides',
      false,
      AppAssets.icCityRide,
    ],
  ];
  int pageIndex = 0;
  String _page = 'Price';
  final _filterPages = <List<dynamic>>[
    ['Archived 10', true],
    ['Pending 10', false],
    ['Accepted 10', false],
  ];

  final List<Rides> _rides = [
    const Rides(
      1,
      'Fri 10 March - 06:00 PM ',
      'Cairo (القاهره), EL- Maadi ',
      'Cairo (القاهره), Nasr city',
      20,
      3,
      1,
      UserRide(
        1,
        'Ahmed Mohamed ',
        'assets/img_user_profile.png',
        'From 16 hours ago',
      ),
    ),
    const Rides(
      1,
      'Fri 10 March - 06:00 PM ',
      'Cairo (القاهره), EL- Maadi ',
      'Cairo (القاهره), Nasr city',
      20,
      3,
      1,
      UserRide(
        1,
        'Ahmed Mohamed ',
        'assets/img_user_profile.png',
        'From 16 hours ago',
      ),
    ),
    const Rides(
      1,
      'Fri 10 March - 06:00 PM ',
      'Cairo (القاهره), EL- Maadi ',
      'Cairo (القاهره), Nasr city',
      20,
      3,
      1,
      UserRide(
        1,
        'Ahmed Mohamed ',
        'assets/img_user_profile.png',
        'From 16 hours ago',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.requestRides,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 4.w,
                right: 2.w,
                top: 3.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  _pages.length,
                  (index) => Expanded(
                    flex: index == 2 || index == 3 ? 4 : 3,
                    child: RideTypePageItemView(
                      data: _pages[index],
                      onTap: () {
                        setState(() {
                          for (var i in _pages) {
                            i[1] = false;
                          }
                          _pages[index][1] = true;
                          pageIndex = index;
                          _page = _pages[index][0];
                          // print(page);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            CustomTabBar(
              tabs: _filterPages
                  .map(
                    (e) => (e[0] as String),
                  )
                  .toList(),
              onTap: (int index) {
                setState(() {
                  for (var i in _filterPages) {
                    i[1] = false;
                  }
                  _filterPages[index][1] = true;
                });
              },
            ),
            Expanded(
              child: TabBarView(
                children: List.generate(
                  _filterPages.length,
                  (index) => CustomListView(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    isScrollable: true,
                    enableBorder: false,
                    enableDivider: false,
                    separatorHeight: 1.h,
                    children: _rides
                        .map(
                          (e) => RidesRequestsItemView(
                            page: _page,
                            rides: e,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
