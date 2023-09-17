import 'ride_type.dart';

class VehicleCompanyType {
  VehicleCompanyType({
    this.id,
    this.company,
    this.type,
    this.model,
    this.passengers,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.rideTypesId,
    this.rideType,
  });

  VehicleCompanyType.fromJson(dynamic json) {
    id = json['id'];
    company = json['company'];
    type = json['type'];
    model = json['model'];
    passengers = json['passengers'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
    rideTypesId = json['ride_types_id'];
    rideType =
        json['ride_type'] != null ? RideType.fromJson(json['ride_type']) : null;
  }

  int? id;
  String? company;
  String? type;
  String? model;
  int? passengers;
  String? createdAt;
  String? updatedAt;
  int? isActive;
  int? rideTypesId;
  RideType? rideType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['company'] = company;
    map['type'] = type;
    map['model'] = model;
    map['passengers'] = passengers;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['is_active'] = isActive;
    map['ride_types_id'] = rideTypesId;
    if (rideType != null) {
      map['ride_type'] = rideType?.toJson();
    }
    return map;
  }
}
