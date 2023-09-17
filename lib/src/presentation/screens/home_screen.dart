// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seda_driver/src/business_logic/SubscriptionCubit/subscription_cubit.dart';
import 'package:seda_driver/src/business_logic/app_cubit/app_cubit.dart';
import 'package:seda_driver/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda_driver/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda_driver/src/business_logic/orders_cubit/orders_cubit.dart';
import 'package:seda_driver/src/business_logic/socket_cubit/socket_cubit.dart';
import 'package:seda_driver/src/business_logic/walletCubit/wallet_cubit.dart';
import 'package:seda_driver/src/constants/constant_methods.dart';
import 'package:seda_driver/src/constants/constants_variables.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/constants/tools/toast.dart';
import 'package:seda_driver/src/models/order_model.dart';
import 'package:seda_driver/src/models/response/google_map_directions_reponse/google_map_directions_reponse.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_bottom_sheet.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_main_view.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_order_receipt_view.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_order_view.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_trip_request_page_view.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:seda_driver/src/presentation/widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.orderModel}) : super(key: key);

  final OrderModel? orderModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _controller;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.013056, 31.208853),
    zoom: 14.4746,
  );
  final ValueNotifier<Map<String, Marker>> _markers = ValueNotifier(
    <String, Marker>{},
  );
  final ValueNotifier<Set<Polyline>> _polyline = ValueNotifier(<Polyline>{});
  final ValueNotifier<bool> _showTripRequest = ValueNotifier(false);
  final ValueNotifier<bool> _showTripProgress = ValueNotifier(false);
  final ValueNotifier<bool> _gettingMyLocation = ValueNotifier(false);
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPageIndex = ValueNotifier(0);

  Future _requestLocationPermission() async {
    await getMyLocation((location, address) async {
      _controller?.animateCamera(
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
      _addMarker(LatLng(location.latitude, location.longitude), "myLocation",
          AppAssets.icMyLocation);
    }, context);
  }

  @override
  void initState() {
    super.initState();
    _requestRecordPermissions();
    _initialiseControllers();
    SocketCubit.get(context).orderResponses.clear();
    AuthCubit.get(context).profile();
    WalletCubit.get(context).getWallet();
    SubscriptionCubit.get(context).checkSubscription();
    SubscriptionCubit.get(context).getSubscription();
    OrdersCubit.get(context).getTodayEarningStatistics();
    _requestLocationPermission();
    if ((SocketCubit.get(context).state is! SocketNewOrder &&
            SocketCubit.get(context).state is! SocketSecondNewOrder) &&
        AuthCubit.get(context).isConnected == true) {
      GlobalCubit.get(context).startUpdateActiveLocation(context);
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      sendFcm(context);
      logSuccess("User Token Updated: $event");
    });
    FirebaseMessaging.onMessage.listen((event) {
      logSuccess("New Notification Received");
      service.showNotification(
        id: Random().nextInt(9999999),
        title: "${event.notification?.title}",
        body: "${event.notification?.body}",
      );
    });
    sendFcm(context);
    _fetchMapStyle();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.orderModel != null) {
        if (widget.orderModel?.status == "accept") {
          SocketCubit.get(context).emitState(SocketOrderAcceptedByDriver());
        } else if (widget.orderModel?.status == "arrived") {
          SocketCubit.get(context).emitState(SocketArrivedOrderFromByDriver());
        } else if (widget.orderModel?.status == "start") {
          SocketCubit.get(context).emitState(SocketOrderStartedByDriver());
        }
        _showTripProgress.value = true;
        _onOrderStart();
      }
    });
    _resetView();
  }

  Future _fetchMapStyle() async {
    if (isDark) {
      final theme = await DefaultAssetBundle.of(context)
          .loadString(AppAssets.mapThemeDark);
      mapTheme = theme;
    } else {
      final theme = await DefaultAssetBundle.of(context)
          .loadString(AppAssets.mapThemeLight);
      mapTheme = theme;
    }
    _setMapStyle();
  }

  Future _setMapStyle() async {
    _controller?.setMapStyle(mapTheme);
  }

  sendFcm(context) async {
    FirebaseMessaging.instance.getToken().then((value) {
      if (value != null) {
        logSuccess("firebase token: $value");
        AuthCubit.get(context).sendFCM(fcm: value, afterSuccess: () {});
      }
    });
  }

  Future<void> setPolyLine(
      PointLatLng origin, PointLatLng destination, BuildContext context) async {
    final cubit = SocketCubit.get(context);
    _polyline.value = Set<Polyline>.of(_polyline.value)..clear();
    final wayPoints = <PolylineWayPoint>[];
    if (cubit.orderResponse?.orderModel?.toLocation?.length != 1) {
      for (int i = 0;
          i < ((cubit.orderResponse?.orderModel?.toLocation?.length)! - 1);
          i++) {
        wayPoints.add(
          PolylineWayPoint(
            location:
                "${cubit.orderResponse?.orderModel!.toLocation?[i].latitude}"
                ","
                "${cubit.orderResponse?.orderModel!.toLocation?[i].longitude}",
          ),
        );
      }
    }
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        EndPoints.googleMapKey, origin, destination,
        wayPoints: wayPoints);
    if (result.status == 'OK') {
      _polyline.value = Set.of(_polyline.value)
        ..add(
          Polyline(
            polylineId: const PolylineId('polyline'),
            width: 4,
            color: AppColors.darkGrey,
            jointType: JointType.round,
            points: result.points
                .map(
                  (point) => LatLng(
                    point.latitude,
                    point.longitude,
                  ),
                )
                .toList(),
          ),
        );
    }
  }

  Future<void> getDropLocation() async {
    //animate to dropoff location
    final toLocations =
        SocketCubit.get(context).orderResponse!.orderModel!.toLocation!;
    final fromLocation =
        SocketCubit.get(context).orderResponse!.orderModel!.fromLocation!;
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
          toLocations.last.latitude!,
          toLocations.last.longitude!,
        )

            // zoom: 16,
            ),
      ),
    );
    for (int i = 0; i < toLocations.length; i++) {
      logWarning("PPPPPPPPPPPPPPPPPPPPPp${toLocations.length}");
      _addMarker(
        LatLng(
          toLocations[i].latitude!,
          toLocations[i].longitude!,
        ),
        "dropOffMarker${i + 1}",
        '',
        await bitmapDescriptorFromSvgAsset(
          context,
          AppAssets.icDropOff,
        ),
      );
      logWarning("PPPPPPPPPPPPPPPPPPPPPp${toLocations[i].latitude}");
    }
    await Future.delayed(const Duration(milliseconds: 800), () {});
    // animate to pickup location
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            fromLocation.longitude!,
            fromLocation.longitude!,
          ),
          // zoom: 16,
        ),
      ),
    );
    _addMarker(
      LatLng(
        fromLocation.longitude!,
        fromLocation.longitude!,
      ),
      "pickupMarker",
      '',
      await bitmapDescriptorFromSvgAsset(
        context,
        AppAssets.icPickUp,
      ),
    );
    _setMapFitToTour(_polyline.value);
  }

  void _setMapFitToTour(Set<Polyline> p) {
    double minLat = p.first.points.first.latitude;
    double minLong = p.first.points.first.longitude;
    double maxLat = p.last.points.last.latitude;
    double maxLong = p.last.points.last.longitude;
    for (var poly in p) {
      for (var point in poly.points) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      }
    }
    _controller?.moveCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLong),
          northeast: LatLng(maxLat, maxLong),
        ),
        50,
      ),
    );
  }

  _resetView() async {
    _showTripRequest.value = false;
    _markers.value = Map<String, Marker>.of(_markers.value)..clear();
    _polyline.value = Set<Polyline>.of(_polyline.value)..clear();
    await getMyLocation((location, address) async {
      _controller?.animateCamera(
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
      _addMarker(
        LatLng(location.latitude, location.longitude),
        "myLocation",
        AppAssets.icMyLocation,
      );
    }, context);
  }

  final ValueNotifier<bool> _startedValueNotifier = ValueNotifier(false);
  final ValueNotifier<String> _navigatorValueNotifier = ValueNotifier('');
  final ValueNotifier<String> _timeTakenValueNotifier = ValueNotifier('');
  Timer? _timer;
  GoogleMapDirections? _directions;

  _resetOrderState() {
    _showTripProgress.value = false;
    _startedValueNotifier.value = false;
    _navigatorValueNotifier.value = '';
    _timeTakenValueNotifier.value = '';
    _markers.value = Map.of(_markers.value)..clear();
    _polyline.value = Set.of(_polyline.value)..clear();
    _timer?.cancel();
    _timer = null;
    _directions = null;
  }

  Future<void> _orderGetMyLocation([
    bool forceUpdate = false,
  ]) async {
    getMyLocation((location, address) async {
      logWarning('kklkllklklklklkl${location.speed}');
      await _addMarker(
        LatLng(location.latitude, location.longitude),
        'Driver',
        AppAssets.icDriverCar,
      );

      /// remove first point from to locations when reached
      if (_startedValueNotifier.value) {
        final distToFirstEnd = toolkit.SphericalUtil.computeDistanceBetween(
          toolkit.LatLng(location.latitude, location.longitude),
          toolkit.LatLng(
            SocketCubit.get(context)
                .orderResponse!
                .orderModel!
                .toLocation![0]
                .latitude!,
            SocketCubit.get(context)
                .orderResponse!
                .orderModel!
                .toLocation![0]
                .longitude!,
          ),
        ).toDouble();
        if (distToFirstEnd <= 20) {
          SocketCubit.get(context)
              .orderResponse!
              .orderModel!
              .toLocation!
              .removeAt(0);
        }
      }

      Map<String, dynamic> event;
      double? minDistance;
      int index = 0;
      int legIndex = 0;

      ///  check if driver is on polyline or took another road to update map polyline
      ///  using minDistance between driver location and polyline
      if (_directions != null && _startedValueNotifier.value) {
        minDistance = double.infinity;
        final legs = _directions!.routes![0].legs!;
        final steps = _directions!.routes![0].legs![0].steps!;
        final points = steps.length >= 2
            ? [
                ...steps[0].polyline!.points!,
                ...steps[1].polyline!.points!,
              ]
            : legs.length >= 2
                ? [
                    ...steps[0].polyline!.points!,
                    ...legs[1].steps![0].polyline!.points!,
                  ]
                : steps[0].polyline!.points!;

        for (int i = 0; i < points.length - 1; i++) {
          double distance = pointToLineDistance(
            toolkit.LatLng(
              location.latitude,
              location.longitude,
            ),
            toolkit.LatLng(points[i].latitude, points[i].longitude),
            toolkit.LatLng(points[i + 1].latitude, points[i + 1].longitude),
          );
          if (distance < minDistance!) {
            minDistance = distance;
            index = i < steps[0].polyline!.points!.length ? 0 : 1;
            legIndex =
                index == 1 && steps.length == 1 && legs.length > 1 ? 1 : 0;
          }
        }

        if (minDistance! <= 20) {
          logSuccess("On the current polyline");
        } else {
          logError("Out of the current polyline");
        }
      }

      /// check multiple to decide when update polyline or removing past steps or past legs
      if (minDistance == null || minDistance > 20 || forceUpdate) {
        if (index == 0) {
          if (_startedValueNotifier.value) {
            logSuccess(
              "++++++++++++++++++++++++++++Started======================",
            );
            // ll.LatLng nearestPoint = findNearestPoint(ll.LatLng(location.latitude,location.longitude), polyline);
            await _setUpPolyLines(
              LatLng(location.latitude, location.longitude),
              SocketCubit.get(context)
                  .orderResponse!
                  .orderModel!
                  .toLocation!
                  .map(
                    (e) => LatLng(
                      e.latitude!,
                      e.longitude!,
                    ),
                  )
                  .toList(),
            );
          } else {
            logSuccess(
              "++++++++++++++++++++++++++Accepted======================",
            );
            await _setUpPolyLines(
              LatLng(location.latitude, location.longitude),
              [
                LatLng(
                  SocketCubit.get(context)
                      .orderResponse!
                      .orderModel!
                      .fromLocation!
                      .latitude!,
                  SocketCubit.get(context)
                      .orderResponse!
                      .orderModel!
                      .fromLocation!
                      .longitude!,
                ),
              ],
            );
          }
        } else {
          if (legIndex == 0) {
            _directions!.routes![0].legs![0].steps!.removeAt(0);
          } else {
            _directions!.routes![0].legs!.removeAt(0);
          }
        }
      }

      _orderSetMapFitToTour();

      /// send live location to user before and after trip starts
      if (_startedValueNotifier.value) {
        logSuccess("++++++++++++++++++++++++++++Started======================");
        _markers.value = Map.of(_markers.value)
          ..removeWhere((key, element) => element.markerId.value == 'User');
        event = {
          "event": "driverLocationStart",
          "message": '',
          "data": {
            "lat": location.latitude,
            "lng": location.longitude,
            "heading": location.heading
          }
        };
        OrdersCubit.get(context).lngLine.add(location.longitude);
        OrdersCubit.get(context).latLine.add(location.latitude);
        final orderId = SocketCubit.get(context).orderResponse?.orderModel?.id;
        OrdersCubit.get(context).shareTrip(
          orderId: orderId!,
          lat: location.latitude,
          lon: location.longitude,
        );
      } else {
        logSuccess("++++++++++++++++++++++++++Accepted======================");
        event = {
          "event": "driverLocation",
          "message": 'j',
          "data": {
            "lat": location.latitude,
            "lng": location.longitude,
            "heading": location.heading
          }
        };
      }
      SocketCubit.get(context).sendLocationToUser({
        'room': "${EndPoints.appKey}.users.",
        'to': SocketCubit.get(context)
            .orderResponse!
            .orderModel!
            .user!
            .id!
            .toString(),
        'data': jsonEncode(event)
      });
    }, context);
  }

  Future<void> _addMarker(
    LatLng position,
    String markerId,
    String imageIcon, [
    BitmapDescriptor? svgIcon,
  ]) async {
    BitmapDescriptor icon = svgIcon ??
        BitmapDescriptor.fromBytes(
          (await getBytesFromAsset(imageIcon, 50)),
        );

    final marker = Marker(
      markerId: MarkerId(markerId),
      icon: icon,
      position: position,
    );
    _markers.value = Map.of(_markers.value)
      ..removeWhere((key, element) => element.markerId.value == markerId)
      ..[markerId] = marker;
  }

  Future<void> _getDropLocation() async {
    if (_timer == null || _timer?.isActive == false) return;
    final toLocations =
        SocketCubit.get(context).orderResponse!.orderModel!.toLocation!;
    for (int i = 0; i < toLocations.length; i++) {
      logWarning("PPPPPPPPPPPPPPPPPPPPPp${toLocations.length}");
      _addMarker(
        LatLng(
          toLocations[i].latitude!,
          toLocations[i].longitude!,
        ),
        "dropOffMarker${i + 1}",
        "",
        await bitmapDescriptorFromSvgAsset(
          context,
          AppAssets.icDropOff,
        ),
      );
      logWarning("PPPPPPPPPPPPPPPPPPPPPp${toLocations[i].latitude}");
    }
  }

  // List<ll.LatLng> polyline = <ll.LatLng>[];
  Future _setUpPolyLines(LatLng origin, List<LatLng> destination) async {
    final direction = await SocketCubit.get(context).getDirections(
      origin,
      destination,
    );
    if (direction != null) {
      _navigatorValueNotifier.value = direction
              .routes![0].legs![0].steps![0].htmlInstructions
              ?.replaceAll('<b>', '')
              .replaceAll(
                '</b>',
                '',
              ) ??
          '';
      _timeTakenValueNotifier.value =
          direction.routes![0].legs![0].duration!.text!;
      _polyline.value = Set.of(_polyline.value)..clear();
      final polylineCoordinates = <LatLng>[];
      _directions = direction;
      for (var element in direction.routes![0].legs!) {
        for (var element in element.steps!) {
          for (var element in element.polyline!.points!) {
            polylineCoordinates.add(
              LatLng(
                element.latitude,
                element.longitude,
              ),
            );
            // polyline.add(
            //   ll.LatLng(
            //     element.latitude,
            //     element.longitude,
            //   ),
            // );
          }
        }
      }
      _polyline.value = Set.of(_polyline.value)
        ..add(
          Polyline(
            polylineId: const PolylineId('polyline'),
            width: 4,
            color: AppColors.green,
            jointType: JointType.round,
            points: polylineCoordinates,
          ),
        );
      final toLocations =
          SocketCubit.get(context).orderResponse!.orderModel!.toLocation!;
      for (int i = 0; i < toLocations.length; i++) {
        logWarning("PPPPPPPPPPPPPPPPPPPPPp${toLocations.length}");
        _addMarker(
          LatLng(
            toLocations[i].latitude!,
            toLocations[i].longitude!,
          ),
          "dropOffMarker${i + 1}",
          "",
          await bitmapDescriptorFromSvgAsset(
            context,
            AppAssets.icDropOff,
          ),
        );
        logWarning("PPPPPPPPPPPPPPPPPPPPPp${toLocations[i].latitude}");
      }
      _orderSetMapFitToTour();
    }
  }

  Future<void> _orderSetMapFitToTour() async {
    await getMyLocation((location, address) async {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                location.latitude,
                location.longitude,
              ),
              zoom: 18,
              bearing: -150),
        ),
      );
    }, context);
  }

  void _startEndCancelOrder(String type, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: const LoadingIndicator(),
      ),
    );
    final orderId = SocketCubit.get(context).orderResponse?.orderModel?.id;
    switch (type) {
      case 'end':
        OrdersCubit.get(context).endedByDriver(
          orderId: orderId!,
          afterSuccess: (orderModel) async {
            final appDir = await getApplicationDocumentsDirectory();
            final directory = Directory(
              "${appDir.path}/Seda/Records/$orderId",
            );
            if (directory.existsSync()) {
              await directory.delete(recursive: true);
            }
            SocketCubit.get(context).orderResponse?.orderModel = orderModel;
            logError(";;;;;;;;;;;;");
            if (SocketCubit.get(context).isRecordingTrip) {
              final path =
                  await SocketCubit.get(context).recorderController.stop();
              SocketCubit.get(context).isRecordingTrip = false;
              SocketCubit.get(context).isRecordingTripCompleted = true;
              if (SocketCubit.get(context).isRecordingTripCompleted) {
                await SocketCubit.get(context).sendRecord(
                    mediaFile: path!,
                    afterSuccess: () {
                      SocketCubit.get(context).recorderController.reset();
                      final record = File(path);
                      if (record.existsSync()) {
                        record.deleteSync();
                      }
                      SocketCubit.get(context).recorderController.dispose();
                    });
              }
              SocketCubit.get(context).isRecordingTripCompleted = false;
            }
            SocketCubit.get(context).changeStatus();
            _resetOrderState();
            _resetView();
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              backgroundColor: AppColors.transparent,
              builder: (context) => const ReceiptView(),
            );
          },
          afterError: () => Navigator.pop(context),
        );
        break;
      case 'arrive':
        getMyLocation((location, address) async {
          OrdersCubit.get(context).arrivedOrderFromByDriver(
            orderId: orderId!,
            lat: location.latitude,
            lon: location.longitude,
            afterSuccess: () {
              Navigator.pop(context);
              SocketCubit.get(context)
                  .emitState(SocketArrivedOrderFromByDriver());
            },
            afterError: () => Navigator.pop(context),
          );
        }, context);
        break;
      case 'start':
        OrdersCubit.get(context).startedByDriver(
          orderId: orderId!,
          afterSuccess: () {
            Navigator.pop(context);
            SocketCubit.get(context).emitState(SocketOrderStartedByDriver());
          },
          afterError: () => Navigator.pop(context),
        );
        break;
      case 'cancel':
        OrdersCubit.get(context).canceledByDriver(
          orderId: orderId!,
          cancelReason: 'some Reason',
          afterSuccess: () {
            SocketCubit.get(context).changeStatus();
            Navigator.of(context).pop(context);
            _resetOrderState();
          },
          afterError: () => Navigator.pop(context),
        );
        break;
    }
  }

  void _onOrderStart() {
    _orderGetMyLocation();
    _addMarker(
      LatLng(
        SocketCubit.get(context)
            .orderResponse!
            .orderModel!
            .fromLocation!
            .latitude!,
        SocketCubit.get(context)
            .orderResponse!
            .orderModel!
            .fromLocation!
            .longitude!,
      ),
      'User',
      AppAssets.icUserLocation,
    );
    _getDropLocation();
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) {
        if (mounted) {
          _orderGetMyLocation();
        }
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  _launchMap(BuildContext context, lat, lng) async {
    try {
      var url = Uri.parse("google.navigation:q=$lat,$lng");
      var urlAppleMaps =
          Uri.parse('https://maps.apple.com/?daddr=$lat,$lng&dirflg=d');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else if (await canLaunchUrl(urlAppleMaps)) {
        await launchUrl(urlAppleMaps);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      logError("_launchMap error: $e");
    }
  }

  Timer? _countDownTimer;
  int _time = 300;

  String _getTimer(int timeInSeconds) {
    final min = (timeInSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (timeInSeconds % 60).toString().padLeft(2, '0');
    final time = '$min : $sec';
    return time;
  }

  void _initializeTimer() {
    _countDownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_time == 0) {
            _countDownTimer?.cancel();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: DefaultAppText(
                  text: context.cancelTrip,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                content: DefaultAppText(
                  text: context.doYouWantCancelTrip,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
                actionsPadding:
                    EdgeInsets.only(bottom: 2.h, right: 4.w, left: 4.w),
                actions: [
                  DefaultAppText(
                    text: context.yes,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  DefaultAppText(
                    text: context.no,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ],
              ),
            ).then((value) {
              if (value == true) {
                _startEndCancelOrder(
                  'cancel',
                  context,
                );
              } else {
                _countDownTimer?.cancel();
              }
            });
          } else {
            _time--;
          }
        });
      },
    );
  }

  Future<void> addDropOff() async {
    _getDropLocation();
    await getMyLocation((location, address) async {
      await _setUpPolyLines(
        LatLng(location.latitude, location.longitude),
        SocketCubit.get(context)
            .orderResponse!
            .orderModel!
            .toLocation!
            .map(
              (e) => LatLng(
                e.latitude!,
                e.longitude!,
              ),
            )
            .toList(),
      );
    }, context);
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, ' .  ');
  }

  void _record() {
    if (_recordAllowed) {
      _startOrStopRecording();
    } else {
      showToast(
        context.recordPermissionsError,
        ToastState.error,
      );
      _requestRecordPermissions();
    }
  }

  String? _path;
  Directory? directory;
  bool _recordAllowed = false;

  Future<void> _getDir() async {
    directory = Directory(
      "${(await getApplicationDocumentsDirectory()).path}/Seda/Records",
    );
    if (directory?.existsSync() == false) {
      await directory?.create(recursive: true);
    }
    _path = "${directory?.path}/trip_record.opus";
    setState(() {});
  }

  void _requestRecordPermissions() async {
    _recordAllowed = ((await Permission.storage.request()) ==
            PermissionStatus.granted) &&
        ((await Permission.microphone.request()) == PermissionStatus.granted);
    setState(() {});

    if ((await Permission.microphone.status) != PermissionStatus.granted) {
      showToast(context.micPermissionError, ToastState.error);
    }
    if ((await Permission.storage.status) != PermissionStatus.granted) {
      showToast(context.storagePermissionError, ToastState.error);
    }

    if (_recordAllowed) {
      await _getDir();
    }
  }

  void _initialiseControllers() {
    SocketCubit.get(context).recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.opus
      ..androidOutputFormat = AndroidOutputFormat.ogg
      ..iosEncoder = IosEncoder.kAudioFormatOpus
      ..sampleRate = 44100;
  }

  void _startOrStopRecording() async {
    try {
      if (!SocketCubit.get(context).isRecordingTrip) {
        await SocketCubit.get(context).recorderController.record(path: _path);
        SocketCubit.get(context).isRecordingTrip = true;
      }
    } catch (e) {
      debugPrint(e.toString());
      SocketCubit.get(context).isRecordingTrip = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.transparent,
        ),
      ),
      child: BlocConsumer<AppCubit, AppState>(listener: (_, state) {
        if (state is AppThemeUpdateState) {
          _fetchMapStyle();
        }
        if (state is AppInternetDisconnectedState) {
          Navigator.pushNamed(context, AppRouterNames.noInternet);
        }
      }, builder: (context, state) {
        return BlocListener<GlobalCubit, GlobalState>(
          listener: (context, state) {
            if (state is ActiveLocationSuccessState) {
              _addMarker(
                LatLng(state.position.latitude, state.position.longitude),
                "myLocation",
                AppAssets.icMyLocation,
              );
            }
          },
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is ToggleOnlineSuccess) {
                final bool online = AuthCubit.get(context).isConnected ?? false;
                if (online) {
                  if (GlobalCubit.get(context).activeLocationStream == null) {
                    GlobalCubit.get(context).startUpdateActiveLocation(context);
                  }
                } else {
                  if (GlobalCubit.get(context).activeLocationStream != null) {
                    GlobalCubit.get(context).endUpdateActiveLocation();
                  }
                }
              } else if (state is ProfileSuccess) {
                if (AuthCubit.get(context).isConnected == true &&
                    GlobalCubit.get(context).activeLocationStream == null) {
                  GlobalCubit.get(context).startUpdateActiveLocation(context);
                }
                SocketCubit.get(context).connectSocket(
                  AuthCubit.get(context).currentUser?.userBasicInfo?.id,
                );
                AuthCubit.get(context).resetState();
              }
            },
            child: BlocListener<OrdersCubit, OrdersState>(
              listener: (context, state) {
                if (state is OrdersStartSuccess) {
                  // _resetView();
                  _countDownTimer?.cancel();
                } else if (state is OrdersCancelSuccess) {
                  if (SocketCubit.get(context).orderResponses.isEmpty) {
                    _resetView();
                    _countDownTimer?.cancel();
                  }
                } else if (state is ArrivedOrderFromByDriverSuccess) {
                  setState(() {
                    _time = 300;
                  });
                }
              },
              child: BlocConsumer<SocketCubit, SocketState>(
                listener: (context, state) async {
                  final cubit = SocketCubit.get(context);
                  if (state is SocketTripRecording) {
                    _record();
                  }
                  if (state is SocketNewOrder ||
                      state is SocketSecondNewOrder) {
                    _showTripRequest.value = true;
                    setPolyLine(
                            PointLatLng(
                              cubit.orderResponse!.orderModel!.fromLocation!
                                  .latitude!,
                              cubit.orderResponse!.orderModel!.fromLocation!
                                  .longitude!,
                            ),
                            PointLatLng(
                              cubit.orderResponse!.orderModel!.toLocation!.last
                                  .latitude!,
                              cubit.orderResponse!.orderModel!.toLocation!.last
                                  .longitude!,
                            ),
                            context)
                        .then(
                      (value) => getDropLocation(),
                    );
                  } else if (state is SocketOrderGone) {
                    _resetOrderState();
                    // _resetView();
                  } else if (state is OrderCancelByUser) {
                    cubit.orderResponses.removeWhere((e) =>
                        e.orderModel?.id ==
                        cubit.orderResponse?.orderModel?.id);
                    _countDownTimer?.cancel();
                    if (cubit.orderResponses.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (_) => WillPopScope(
                          onWillPop: () => Future.value(true),
                          child: const LoadingIndicator(),
                        ),
                      );
                      Future.delayed(const Duration(seconds: 1)).then(
                        (value) => Navigator.pop(context),
                      );
                      _resetOrderState();
                      _resetView();
                    }
                  } else if (state is AutoCancelDriver ||
                      state is AutoSecondCancelDriver) {
                    logSuccess(
                        "++++++++++++++++++++++++${cubit.orderResponses.length}");
                    if (cubit.orderResponses.isNotEmpty) {
                      _currentPageIndex.value = 0;
                      _pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _resetOrderState();
                      _resetView();
                    }
                  }
                },
                builder: (context, state) {
                  final cubit = SocketCubit.get(context);
                  return Scaffold(
                    body: Stack(
                      children: [
                        ValueListenableBuilder(
                            valueListenable: _polyline,
                            builder: (context, polyline, child) {
                              return ValueListenableBuilder(
                                  valueListenable: _markers,
                                  builder: (context, markers, child) {
                                    return GoogleMap(
                                      key: const ValueKey(1),
                                      markers: markers.values.toSet(),
                                      initialCameraPosition: _kGooglePlex,
                                      zoomControlsEnabled: false,
                                      myLocationEnabled: false,
                                      myLocationButtonEnabled: false,
                                      polylines: polyline,
                                      rotateGesturesEnabled: true,
                                      padding: EdgeInsets.only(bottom: 30.h),
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _controller = controller;
                                      },
                                    );
                                  });
                            }),
                        ValueListenableBuilder(
                            valueListenable: _showTripProgress,
                            builder: (context, showTripProgress, child) {
                              return ValueListenableBuilder(
                                valueListenable: _showTripRequest,
                                builder: (context, showTipRequest, child) {
                                  return (!showTipRequest && !showTripProgress)
                                      ? HomeMainView(
                                          key: const ValueKey(
                                            "HomeMainView",
                                          ),
                                          controller: _controller,
                                          gettingMyLocation: _gettingMyLocation,
                                          addMarker: _addMarker,
                                        )
                                      : Container();
                                },
                              );
                            }),
                        ValueListenableBuilder(
                          valueListenable: _showTripProgress,
                          builder: (context, showTripProgress, child) {
                            return showTripProgress
                                ? Positioned(
                                    top: 7.h,
                                    left: 10.w,
                                    right: 10.w,
                                    child: CustomListViewItem(
                                      onClick: () async {
                                        _launchMap(
                                            context,
                                            SocketCubit.get(context)
                                                .orderResponse
                                                ?.orderModel
                                                ?.toLocation
                                                ?.first
                                                .latitude,
                                            SocketCubit.get(context)
                                                .orderResponse
                                                ?.orderModel
                                                ?.toLocation
                                                ?.first
                                                .longitude);
                                      },
                                      trailing: const SizedBox(),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: AppColors.white,
                                            size: 20.sp,
                                          ),
                                          SizedBox(
                                            width: 1.w,
                                          ),
                                          Expanded(
                                            child:
                                                ValueListenableBuilder<String>(
                                                    valueListenable:
                                                        _navigatorValueNotifier,
                                                    builder: (context, address,
                                                        child) {
                                                      return DefaultAppText(
                                                        key: ValueKey(address),
                                                        text: removeAllHtmlTags(
                                                            address),
                                                        color: AppColors.white,
                                                        fontSize: 10.sp,
                                                        maxLines: 100,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      );
                                                    }),
                                          ),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      backgroundColor: AppColors.midBlue,
                                    ),
                                  )
                                : Container();
                          },
                        ),
                      ],
                    ),
                    bottomSheet: ValueListenableBuilder(
                        valueListenable: _showTripProgress,
                        builder: (context, showTripProgress, child) {
                          return ValueListenableBuilder(
                            valueListenable: _showTripRequest,
                            builder: (context, showTipRequest, child) =>
                                showTipRequest
                                    ? HomeTripRequestPageView(
                                        cubit: cubit,
                                        getDropLocation: getDropLocation,
                                        pageController: _pageController,
                                        currentPageIndex: _currentPageIndex,
                                        setPolyLine: setPolyLine,
                                        showTripRequest: _showTripRequest,
                                        showTripProgress: _showTripProgress,
                                        onAcceptOrder: _onOrderStart,
                                      )
                                    : showTripProgress
                                        ? HomeOrderView(
                                            startEndCancelOrder:
                                                _startEndCancelOrder,
                                            timeTakenValueNotifier:
                                                _timeTakenValueNotifier,
                                            startedValueNotifier:
                                                _startedValueNotifier,
                                            getTimer: _getTimer,
                                            time: _time,
                                            makePhoneCall: _makePhoneCall,
                                            cubit: cubit,
                                            initializeTimer: _initializeTimer,
                                            orderGetMyLocation:
                                                _orderGetMyLocation,
                                            addDropOff: addDropOff,
                                          )
                                        : const HomeBottomSheet(),
                          );
                        }),
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
