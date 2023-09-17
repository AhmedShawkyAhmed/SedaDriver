import 'benefits.dart';

class Subscription {
  int? id;
  String? name;
  String? description;
  Benefits? benefits;
  int? price;
  int? duration;
  int? newCommission;
  String? appKey;
  String? createdAt;
  String? updatedAt;

  Subscription(
      {this.id,
      this.name,
      this.description,
      this.benefits,
      this.price,
      this.duration,
      this.newCommission,
      this.appKey,
      this.createdAt,
      this.updatedAt});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    benefits = json['benefits'] != null
        ? new Benefits.fromJson(json['benefits'])
        : null;
    price = json['price'];
    duration = json['duration'];
    newCommission = json['newCommission'];
    appKey = json['appKey'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    if (this.benefits != null) {
      data['benefits'] = this.benefits!.toJson();
    }
    data['price'] = this.price;
    data['duration'] = this.duration;
    data['newCommission'] = this.newCommission;
    data['appKey'] = this.appKey;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
