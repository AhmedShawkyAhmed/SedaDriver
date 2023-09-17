// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/constants/tools/toast.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view.dart';
import 'package:seda_driver/src/presentation/views/select_location_views/search_places_view/places_view.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:seda_driver/src/presentation/widgets/default_text_form_field.dart';
import 'package:seda_driver/src/presentation/widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class SearchPlacesBottomSheet extends StatefulWidget {
  const SearchPlacesBottomSheet({super.key});

  @override
  State<SearchPlacesBottomSheet> createState() =>
      _SearchPlacesBottomSheetState();
}

class _SearchPlacesBottomSheetState extends State<SearchPlacesBottomSheet> {
  late GoogleMapsPlaces _mapsPlaces;
  late TextEditingController _searchController;
  final List<Prediction> _predictions = [];
  bool _filled = false;

  autoCompleteSearch(String input) async {
    var result = await _mapsPlaces.autocomplete(input);
    if (result.errorMessage == null && mounted) {
      logWarning('${result.predictions[0].description}');
      _predictions.clear();
      _predictions.addAll(result.predictions);
    } else {
      showToast(
        result.errorMessage!,
        ToastState.error,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _mapsPlaces = GoogleMapsPlaces(apiKey: EndPoints.googleMapKey);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 1.5.h,
              ),
              DefaultAppText(
                text: context.searchPlaces,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 1.5.h,
              ),
              DefaultTextFormField(
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                controller: _searchController,
                hintText: context.search,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    _filled = true;
                    autoCompleteSearch(val);
                  } else {
                    _filled = false;
                    _predictions.clear();
                  }
                  setState(() {});
                },
                suffix: _filled
                    ? InkWell(
                        onTap: () {
                          _searchController.clear();
                          _predictions.clear();
                          setState(() {
                            _filled = false;
                          });
                        },
                        child: Image.asset(
                          AppAssets.icRemove,
                        ),
                      )
                    : null,
              ),
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                child: _predictions.isNotEmpty
                    ? CustomListView(
                        isScrollable: true,
                        enableBorder: false,
                        enableDivider: false,
                        separatorHeight: 1.h,
                        children: _predictions
                            .map(
                              (e) => PlaceView(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const LoadingIndicator(),
                                  );
                                  _mapsPlaces
                                      .getDetailsByPlaceId('${e.placeId}')
                                      .then((value) {
                                    final result = <String, dynamic>{
                                      'latitude':
                                          value.result.geometry!.location.lat,
                                      'longitude':
                                          value.result.geometry!.location.lng,
                                      'address': value.result.formattedAddress!,
                                    };
                                    Navigator.pop(context);
                                    Navigator.pop(
                                      context,
                                      result,
                                    );
                                  });
                                },
                                address: '${e.description}',
                              ),
                            )
                            .toList(),
                      )
                    : Center(
                        child: DefaultAppText(
                          text: context.noAvailPredictions,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ],
          ),
          Positioned(
            top: 15,
            right: 20,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                AppAssets.icRemove,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
