import '../../../vehicle_color.dart';
import '../../../vehicle_type.dart';

class Data {
  Data({
    this.vehicleColor,
    this.vehicleType,
  });

  Data.fromJson(dynamic json) {
    if (json['vehicle_color'] != null) {
      vehicleColor = [];
      json['vehicle_color'].forEach((v) {
        vehicleColor?.add(VehicleColor.fromJson(v));
      });
    }
    if (json['vehicle_type'] != null) {
      vehicleType = [];
      json['vehicle_type'].forEach((v) {
        vehicleType?.add(VehicleType.fromJson(v));
      });
    }
  }

  List<VehicleColor>? vehicleColor;
  List<VehicleType>? vehicleType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (vehicleColor != null) {
      map['vehicle_color'] = vehicleColor?.map((v) => v.toJson()).toList();
    }
    if (vehicleType != null) {
      map['vehicle_type'] = vehicleType?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
