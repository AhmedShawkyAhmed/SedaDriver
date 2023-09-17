import 'package:seda_driver/src/models/user_basic_info.dart';
import 'package:seda_driver/src/models/vehicle_info.dart';

class UserModel {
  UserBasicInfo? userBasicInfo;
  VehicleInfo? vehicleInfo;

  UserModel({
    this.userBasicInfo,
    this.vehicleInfo,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userBasicInfo =
        json['user'] != null ? UserBasicInfo.fromJson(json['user']) : null;
    vehicleInfo =
        json['Vehicle'] != null ? VehicleInfo.fromJson(json['Vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = userBasicInfo?.toJson();
    data['Vehicle'] = vehicleInfo?.toJson();
    return data;
  }
}
