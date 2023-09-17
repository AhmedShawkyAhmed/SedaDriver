import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:seda_driver/src/constants/constant_methods.dart';
import 'package:seda_driver/src/constants/constants_variables.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/constants/tools/toast.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class SelectLocationMapView extends StatefulWidget {
  const SelectLocationMapView({super.key});

  @override
  State<SelectLocationMapView> createState() => _SelectLocationMapViewState();
}

class _SelectLocationMapViewState extends State<SelectLocationMapView> {
  @override
  void initState() {
    try {
      initMyLocation();
    } catch (e) {
      logError('Select Location Get My Location Error:  $e');
    }

    super.initState();
  }

  bool _mapType = false;
  final _markers = <String, Marker>{};
  final _mapController = Completer<GoogleMapController>();
  final _result = <String, dynamic>{};
  double _padding = 0.0;
  static const LatLng _center = LatLng(45.343434, -122.545454);
  LatLng _lastMapPosition = _center;
  bool _enable = false;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Future<void> addMarker(LatLng position) async {
    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 3.0),
      AppAssets.icMyLocation,
    );
    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: const MarkerId("location"),
        icon: icon,
        position: position,
      );
      _markers["location"] = marker;
    });
  }

  Future initMyLocation() async {
    await getMyLocation((location, address) async {
      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              location.latitude,
              location.longitude,
            ),
            zoom: 18,
          ),
        ),
      );
      await getAddress();
      await addMarker(LatLng(location.latitude, location.longitude));
      setState(() {
        _enable = true;
      });
    }, context);
  }

  Future<void> getAddress() async {
    getLatLngDetails(
        lat: _lastMapPosition.latitude,
        lon: _lastMapPosition.longitude,
        afterSuccess: (data) {
          _result["latitude"] = _lastMapPosition.latitude;
          _result["longitude"] = _lastMapPosition.longitude;
          _result["address"] =
              "${data.houseNumber ?? ''} ${data.neighbourhood ?? ''}${data.road ?? ''} ${data.state ?? ''} ${data.country ?? ''}";
          setState(() {
            _padding = 0.0;
          });
        },
        context: context);
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _padding = 3.0;
    });
    _lastMapPosition = position.target;
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _mapController.future;
    controller.dispose();
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SizedBox(
        width: 100.w,
        height: 95.h,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              child: GoogleMap(
                initialCameraPosition: initial,
                onCameraMove: _onCameraMove,
                zoomControlsEnabled: false,
                rotateGesturesEnabled: true,
                buildingsEnabled: false,
                onCameraIdle: getAddress,
                myLocationButtonEnabled: false,
                mapType: _mapType ? MapType.satellite : MapType.normal,
                markers: _markers.values.toSet(),
                onMapCreated: (GoogleMapController googleMapController) {
                  if (mapTheme.isNotEmpty) {
                    googleMapController.setMapStyle(mapTheme);
                  }
                  _controller.complete(googleMapController);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
                left: 20,
                right: 20,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => WillPopScope(
                        onWillPop: () => Future.value(false),
                        child: const LoadingIndicator(),
                      ),
                    );
                    Future.delayed(const Duration(seconds: 1)).then((value) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    height: 13.w,
                    width: 13.w,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkGrey : AppColors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? AppColors.darkGrey.withOpacity(0.7)
                              : AppColors.grey.withOpacity(0.7),
                          spreadRadius: 4,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: isDark ? AppColors.white : AppColors.darkGrey,
                        size: 15.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 20.h,
                left: 20,
                right: 20,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _mapType = !_mapType;
                    });
                  },
                  child: Container(
                    height: 13.w,
                    width: 13.w,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkGrey : AppColors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey.withOpacity(0.7),
                          spreadRadius: 4,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _mapType
                            ? Icons.map_rounded
                            : Icons.satellite_alt_rounded,
                        color:
                            isDark ? AppColors.lightGrey : AppColors.darkGrey,
                        size: 15.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 12.h,
                left: 20,
                right: 20,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    initMyLocation();
                  },
                  child: Container(
                    height: 13.w,
                    width: 13.w,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkGrey : AppColors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey.withOpacity(0.7),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                        child: Icon(
                      Icons.my_location,
                      color: isDark ? AppColors.lightBlue : AppColors.darkGrey,
                      size: 23,
                    )),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 85.h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: IgnorePointer(
                    ignoring: !_enable,
                    child: DefaultAppButton(
                      backgroundColor: _enable ? null : AppColors.grey,
                      onTap: () {
                        if (_result['latitude'] != null &&
                            _result['longitude'] != null &&
                            _result['address'] != null) {
                          showDialog(
                            context: context,
                            builder: (context) => const LoadingIndicator(),
                          );
                          logWarning(
                            "new LocationLat: ${_result['latitude']}",
                          );
                          logWarning(
                            "new LocationLon: ${_result['longitude']}",
                          );
                          logWarning(
                            "new LocationAddress: ${_result['address']}",
                          );

                          Future.delayed(const Duration(milliseconds: 1500))
                              .then(
                            (value) {
                              Navigator.pop(context);
                              Navigator.pop(context, _result);
                            },
                          );
                        } else {
                          showToast(
                            context.selectLocation,
                            ToastState.warning,
                          );
                        }
                      },
                      text: context.confirm,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 15.w,
                height: _padding == 0 ? 9.h : 11.h,
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _padding == 0 ? 9.w : 9.w,
                      height: 9.w,
                      decoration: BoxDecoration(
                        color: AppColors.midBlue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: _padding == 0
                            ? Image.asset(
                                AppAssets.icMyLocation,
                                width: 9.w,
                              )
                            : LoadingAnimationWidget.halfTriangleDot(
                                color: AppColors.white,
                                size: 15,
                              ),
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 3.5.h,
                      decoration: BoxDecoration(
                        color: AppColors.darkGrey.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    _padding == 0
                        ? const SizedBox()
                        : Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 1.5.w,
                            height: 1.5.w,
                            decoration: BoxDecoration(
                              color: AppColors.midBlue.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
