import 'package:google_maps_flutter/google_maps_flutter.dart';

class GovernCreateRequestModel {
  final LatLng fromLocation;
  final LatLng toLocation;
  final List<LatLng>? stopPoints;
  final int passenger;
  final String date;
  final int paymentTypeId;

  const GovernCreateRequestModel({
    required this.fromLocation,
    required this.toLocation,
    required this.passenger,
    required this.date,
    required this.paymentTypeId,
    this.stopPoints,
  });

  Map<String, dynamic> toJson() {
    final body = <String, dynamic>{
      'fromLocation[longitude]': fromLocation.longitude,
      'fromLocation[latitude]': fromLocation.latitude,
      'toLocation[longitude]': toLocation.longitude,
      'toLocation[latitude]': toLocation.latitude,
      'shipment_type_id': 4,
      'ride_type_id': 1,
      'payment_type_id': paymentTypeId,
      'date': date,
      'passenger': passenger,
    };
    if (stopPoints != null) {
      for (int i = 0; i < stopPoints!.length; i++) {
        body['points[$i][latitude]'] = stopPoints![i].latitude;
        body['points[$i][longitude]'] = stopPoints![i].longitude;
      }
    }
    return body;
  }
}