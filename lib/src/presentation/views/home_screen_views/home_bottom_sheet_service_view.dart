import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:sizer/sizer.dart';

import '../../router/app_routes_names.dart';
import '../../styles/app_assets.dart';
import '../../styles/app_colors.dart';
import '../../widgets/default_app_text.dart';
import '../custom_list_view.dart';
import '../custom_list_view_item.dart';

class ServicesView extends StatefulWidget {
  const ServicesView({
    super.key,
    required this.service,
  });
  final String service;
  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  _features(BuildContext context) => <List<dynamic>>[
        [
          context.subscriptionFeatureCityRides,
          AppAssets.imgCityRides,
        ],
        [
          context.subscriptionFeatureCityToCity,
          AppAssets.imgCityToCity,
        ],
        [
          context.subscriptionFeatureReservationOfHour,
          AppAssets.imgReservationOFHour,
        ],
        [
          context.subscriptionFeatureCustomisedPrice,
          AppAssets.imgCustomizedPrice,
        ],
      ];

  final List<bool> _featuresStatus = [false, false, false, false];

  int featureCount = 0;
  late String value;
  @override
  void initState() {
    super.initState();
    setState(() {
      value = widget.service;
      for (int i = 0; i < _featuresStatus.length; i++) {
        if (value == "City rides") {
          _featuresStatus[0] = true;
        } else if (value == "City to city") {
          _featuresStatus[1] = true;
        } else if (value == "Reservation of hour") {
          _featuresStatus[2] = true;
        } else if (value == "Reservation of hour") {
          _featuresStatus[3] = true;
        } else {
          _featuresStatus[i] = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50.h,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Navigator.pop(context, value);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.darkBlue,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(bottom: 3.h, top: 1.h, left: 4.w, right: 4.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: DefaultAppText(
                text: context.services,
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                color: AppColors.black,
              ),
            ),
          ),
          CustomListView(
            enableDivider: false,
            enableBorder: false,
            separatorHeight: 2.5.h,
            children: List.generate(
              _featuresStatus.length,
              (index) => Column(
                children: [
                  CustomListViewItem(
                    titleText: _features(context)[index][0],
                    titleFontSize: 12.sp,
                    titleFontWeight: FontWeight.w400,
                    leading: Image.asset(_features(context)[index][1]),
                    trailing: Row(
                      children: [
                        if (_featuresStatus[index] == true)
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.lightBlue,
                          ),
                        if (_featuresStatus[index] == true)
                          SizedBox(
                            width: 3.w,
                          ),
                        if (index == 1 || index == 2)
                          IconButton(
                            onPressed: () {
                              if (index == 1) {
                                Navigator.pushNamed(context, AppRouterNames.cityToCity);
                              } else {
                                Navigator.pushNamed(
                                    context, AppRouterNames.reservationOfHour);
                              }
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.lightBlue,
                              size: 15.sp,
                            ),
                          ),
                      ],
                    ),
                    onClick: () {
                      setState(() {
                        value = _features(context)[index][0];
                        _featuresStatus[index] = !_featuresStatus[index];
                        for (int i = 0; i < _featuresStatus.length; i++) {
                          if (_features(context)[i][0] != value) {
                            _featuresStatus[i] = false;
                          }
                        }
                        if (_featuresStatus[index] == true) {
                          featureCount++;
                        } else if (_featuresStatus[index] == false) {
                          if (featureCount != 0) {
                            featureCount--;
                          }
                        }
                      });
                    },
                  ),
                  if (index != 3)
                    Divider(
                      thickness: 1,
                      indent: 8.w,
                      endIndent: 8.w,
                    )
                ],
              ),
            ),
          ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }
}
