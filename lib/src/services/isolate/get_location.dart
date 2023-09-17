import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/constant_methods.dart';

Future<void> getCurrentLocation(
    Function(Position location, String address) afterSuccess,
    BuildContext context) async {
  Isolate.run(await _getMyLocation(afterSuccess, context));
}

Future _getMyLocation(Function(Position location, String address) afterSuccess,
    BuildContext context) async {
  if ((await Permission.locationWhenInUse.status) != PermissionStatus.granted ||
      (await Permission.locationAlways.status) != PermissionStatus.granted) {
    await Permission.locationAlways.request();
    await Permission.locationWhenInUse.request();
  }
  final myLocation = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  final lat = myLocation.latitude;
  final lon = myLocation.longitude;
  await getLatLngDetails(
    lat: lat,
    lon: lon,
    afterSuccess: (data) {
      final add =
          "${data.houseNumber ?? ''} ${data.neighbourhood ?? ''}${data.road ?? ''} ${data.state ?? ''} ${data.country ?? ''}";
      afterSuccess(myLocation, add);
    },
    context: context,
  );
}
