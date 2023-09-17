class RideType {
  RideType({
    this.id,
    this.name,
    this.isActive,
    this.appKey,
    this.createdAt,
    this.updatedAt,
    this.image,
  });

  RideType.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
    appKey = json['appKey'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
  }

  int? id;
  String? name;
  int? isActive;
  String? appKey;
  dynamic createdAt;
  dynamic updatedAt;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['is_active'] = isActive;
    map['appKey'] = appKey;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['image'] = image;
    return map;
  }
}
