import '../../../vehicle_company_type.dart';

class Data {
  Data({
    this.vehicleType,
  });

  Data.fromJson(dynamic json) {
    if (json['vehicle_type'] != null) {
      vehicleType = [];
      json['vehicle_type'].forEach((v) {
        vehicleType?.add(VehicleCompanyType.fromJson(v));
      });
    }
  }

  List<VehicleCompanyType>? vehicleType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (vehicleType != null) {
      map['vehicle_type'] = vehicleType?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
