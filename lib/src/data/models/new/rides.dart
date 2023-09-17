import 'package:seda_driver/src/data/models/new/user_ride.dart';

class Rides {
  const Rides(
      this.id,
      this.date,
      this.startLocation,
      this.endLocation,
      this.cost,
      this.estimatedTime,
      this.passenger,
      this.user,
      );

  final int id;
  final String date;
  final String startLocation;
  final String endLocation;
  final double? cost;
  final double? estimatedTime;
  final int passenger;
  final UserRide user;
}