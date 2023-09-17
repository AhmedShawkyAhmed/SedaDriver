class VehicleColor {
  VehicleColor({
    this.id,
    this.name,
    this.code,
    this.createdAt,
    this.updatedAt,
  });

  VehicleColor.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  int? id;
  String? name;
  String? code;
  dynamic createdAt;
  dynamic updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
