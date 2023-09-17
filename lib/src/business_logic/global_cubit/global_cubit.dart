import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seda_driver/src/constants/constant_methods.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/shared_preference_keys.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/models/response/distance_matrix_response.dart';
import 'package:seda_driver/src/services/cache_helper.dart';
import 'package:seda_driver/src/services/dio_helper.dart';

part 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  static GlobalCubit get(context) => BlocProvider.of(context);

  Timer? activeLocationStream;

  static void getDistanceMatrix({
    required double fromLat,
    required double fromLon,
    required double toLat,
    required double toLon,
    required Function(Distance time, Distance distance) afterSuccess,
  }) async {
    try {
      final response = await Dio().get(
          'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$toLat,$toLon&origins=$fromLat,$fromLon&key=${EndPoints.googleMapKey}');
      final responseData = DistanceMatrixResponse.fromJson(response.data);
      logSuccess(
          "distance text: ${responseData.rows?[0].elements?[0].distance?.text}");
      logSuccess(
          "distance value: ${responseData.rows?[0].elements?[0].distance?.value}");
      logSuccess(
          "time text: ${responseData.rows?[0].elements?[0].duration?.text}");
      logSuccess(
          "time value: ${responseData.rows?[0].elements?[0].duration?.value}");
      if (responseData.rows?[0].elements?[0].duration != null &&
          responseData.rows?[0].elements?[0].distance != null) {
        afterSuccess(
          responseData.rows![0].elements![0].duration!,
          responseData.rows![0].elements![0].distance!,
        );
      }
    } catch (e) {
      logError(e.toString());
    }
  }

  Future checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        logSuccess('Internet Connected');
        CacheHelper.saveDataSharedPreference(
            key: SharedPreferenceKeys.isConnected, value: true);
      }
    } on SocketException catch (_) {
      CacheHelper.saveDataSharedPreference(
          key: SharedPreferenceKeys.isConnected, value: false);
      logError('Internet Disconnected');
    }
  }

  Future navigate({required VoidCallback afterSuccess}) async {
    await Future.delayed(const Duration(seconds: 5), () {});
    afterSuccess();
  }

  Future determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future startUpdateActiveLocation(BuildContext context) async {
    if ((await Permission.locationAlways.status) == PermissionStatus.granted ||
        (await Permission.locationWhenInUse.status) ==
            PermissionStatus.granted) {
      await Permission.locationAlways.request();
      await Permission.locationWhenInUse.request();
    }
    try {
      logSuccess('Start Updating Active Location');
      activeLocationStream = Timer.periodic(
        const Duration(seconds: 10),
        (timer) async {
          await getMyLocation((location, address) async {
            logSuccess('Updating Active Location: $location');
            await activeLocation(location);
          }, context);
        },
      );
    } catch (e) {
      logError('startUpdateActiveLocation stream error: $e');
    }
  }

  Future getAddress(LatLng position) async {
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final address =
        "${placeMarks[0].street!}, ${placeMarks[0].subAdministrativeArea!}, ${placeMarks[0].administrativeArea!}, ${placeMarks[0].country!}";
    logSuccess(address);
    return address;
  }

  Future endUpdateActiveLocation() async {
    activeLocationStream?.cancel();
    activeLocationStream = null;
  }

  Future activeLocation(Position position) async {
    const tag = 'activeLocationLocation';
    logSuccess(
        'activeLocationLocation: (Lat, Long) => (${position.latitude}, ${position.longitude}), (Address, ${await getAddress(LatLng(position.latitude, position.longitude))})');
    try {
      emit(ActiveLocationLoadingState());
      final lat = position.latitude;
      final long = position.longitude;
      final heading = position.heading;
      DioHelper.postData(
        url: EndPoints.activeLocation,
        body: {
          'longitude': long,
          'latitude': lat,
          'direction': heading,
        },
      ).then((value) {
        final response = value.data;
        logWarning('$tag - Response: $response');
        emit(ActiveLocationSuccessState(position));
      });
    } on DioError catch (e) {
      logError('$tag - Dio Error: $e');
      emit(ActiveLocationProblemState());
    } catch (e) {
      logError('$tag - Unknown Error: $e');
      emit(ActiveLocationFailureState());
    }
  }
}
