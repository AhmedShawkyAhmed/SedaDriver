// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui' as ui;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;
import 'package:permission_handler/permission_handler.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/services/notification_service.dart';

import '../models/api_location_adress_model/api_location_address_response.dart';

final _imagePicker = ImagePicker();

Future pickImage({
  required ImageSource source,
  required Function(XFile image) onImageSelect,
}) async {
  XFile? image = await _imagePicker.pickImage(
    source: source,
    maxHeight: 1024,
    maxWidth: 1024,
    imageQuality: 50,
  );
  if (image != null) {
    logSuccess("PickedImage: ${image.path}");
    onImageSelect(image);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _handeler(message) async {
  logSuccess('when app in backGround ----  $message');
}

Future initialize(NotificationService service) async {
  if (Platform.isIOS) {}
  logWarning('Firebase Messaging init');
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    logSuccess('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    logSuccess('User granted provisional permission');
  } else {
    logError('User declined or has not accepted permission');
  }
  //onMessage
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    logSuccess('when app is open ----  ${message.notification!.body}');
    service.showNotification(id: 1, title: 'title', body: 'body');
  });

  //onResume
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    logSuccess('when app is open after tap----  $message');
  });
  FirebaseMessaging.onBackgroundMessage(_handeler);

  //onLaunch
  final RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    logSuccess('when app is open from terminated ----  $initialMessage');
  }
}

Future getLatLngDetails({
  required double lat,
  required double lon,
  required BuildContext context,
  required Function(ApiLocationAddress geoLocationData)? afterSuccess,
}) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
  final loc = placemarks.first;
  ApiLocationAddress locationAddress = ApiLocationAddress(
      houseNumber: loc.name,
      road: loc.street,
      neighbourhood: loc.locality,
      suburb: loc.subAdministrativeArea,
      state: loc.administrativeArea,
      iSO31662Lvl4: loc.isoCountryCode,
      postcode: loc.postalCode,
      country: loc.country,
      countryCode: '+20');
  if (afterSuccess != null) {
    await afterSuccess(locationAddress);
  } else {
    return locationAddress;
  }
}

Future getMyLocation(Function(Position location, String address) afterSuccess,
    BuildContext context) async {
  if ((await Permission.locationWhenInUse.status) != PermissionStatus.granted ||
      (await Permission.locationAlways.status) != PermissionStatus.granted) {
    await Permission.locationAlways.request();
    await Permission.locationWhenInUse.request();
  }
  final myLocation = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.bestForNavigation,
  );
  final lat = myLocation.latitude;
  final lon = myLocation.longitude;
  await getLatLngDetails(
    lat: lat,
    lon: lon,
    context: context,
    afterSuccess: (data) {
      final add =
          "${data.houseNumber ?? ''} ${data.road ?? ''}${data.neighbourhood ?? ''} ${data.state ?? ''} ${data.country ?? ''}";
      afterSuccess(myLocation, add);
    },
  );
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    BuildContext context, String assetName) async {
  // Read SVG file as String
  String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
  // Create DrawableRoot from SVG String
  DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, 'null');

  // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
  MediaQueryData queryData = MediaQuery.of(context);
  double devicePixelRatio = queryData.devicePixelRatio;
  double width = 10 * devicePixelRatio; // where 32 is your SVG's original width
  double height = 10 * devicePixelRatio; // same thing

  // Convert to ui.Picture
  ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

  // Convert to ui.Image. toImage() takes width and height as parameters
  // you need to find the best size to suit your needs and take into account the
  // screen DPI
  ui.Image image = await picture.toImage(width.toInt(), height.toInt());
  ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}

/// calculate distance between point and line segment
double pointToLineDistance(
  toolkit.LatLng point,
  toolkit.LatLng start,
  toolkit.LatLng end,
) {
  double distance = 0.0;
  double slope =
      (end.longitude - start.longitude) / (end.latitude - start.latitude);
  double intercept = start.longitude - (slope * start.latitude);
  double perpendicularSlope = -1 / slope;

  double perpIntercept =
      point.longitude - (perpendicularSlope * point.latitude);

  double intersectionLat =
      (intercept - perpIntercept) / (perpendicularSlope - slope);
  double intersectionLng = (slope * intersectionLat) + intercept;

  if (intersectionLat < start.latitude ||
      intersectionLat > end.latitude ||
      intersectionLng < start.longitude ||
      intersectionLng > end.longitude) {
    // closest point is not on the line segment, so calculate distance to start and end points
    double startDistance =
        toolkit.SphericalUtil.computeDistanceBetween(point, start).toDouble();
    double endDistance =
        toolkit.SphericalUtil.computeDistanceBetween(point, end).toDouble();
    distance = startDistance > endDistance ? endDistance : startDistance;
  } else {
    // closest point is on the line segment, so calculate distance to that point
    toolkit.LatLng closestPoint =
        toolkit.LatLng(intersectionLat, intersectionLng);
    distance = toolkit.SphericalUtil.computeDistanceBetween(
      point,
      closestPoint,
    ).toDouble();
  }

  return distance;
}
