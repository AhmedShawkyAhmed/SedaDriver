class VehicleType {
  VehicleType({
    this.company,
  });

  VehicleType.fromJson(dynamic json) {
    company = json['company'];
  }

  String? company;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['company'] = company;
    return map;
  }
}
