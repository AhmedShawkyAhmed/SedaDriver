import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/services/notification_service.dart';

bool isDark = false;

int defaultStatusCode = 100;
int successStatusCode = 200;
int defaultId = 0;

double myLocationLat = 0.0;
double myLocationLon = 0.0;

TextEditingController myLocationAddressController = TextEditingController();

CameraPosition initial = const CameraPosition(
  target: LatLng(30.054740517818406, 31.3741537684258),
  zoom: 15,
);

String mapTheme = '';

XFile? frontImage;
XFile? backImage;
XFile? frontImage2;
XFile? frontImage3;

late MethodChannel methodChannel;
late final NotificationService service;

enum OrderType {
  hours(AppAssets.icHourTrip, AppColors.orange),
  price(AppAssets.icPriceTrip, AppColors.lightBlue),
  offer(AppAssets.icOfferTrip, AppColors.midGreen);

  const OrderType(this.icon, this.color);

  final String icon;
  final Color color;
}

enum PaymentMethods {
  cash(3, 'Cash'),
  online(2, 'Credit'),
  wallet(1, 'Wallet');

  const PaymentMethods(this.id, this.name);

  final String name;
  final int id;
}
