import 'package:seda_driver/src/models/response/subscription/subscription.dart';

class SubscribedData {
  int? id;
  int? subscriptionsId;
  int? userId;
  int? isActive;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  Subscription? subscription;

  SubscribedData(
      {this.id,
      this.subscriptionsId,
      this.userId,
      this.isActive,
      this.startDate,
      this.endDate,
      this.createdAt,
      this.updatedAt,
      this.subscription});

  SubscribedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionsId = json['subscriptions_id'];
    userId = json['user_id'];
    isActive = json['is_active'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    subscription = json['subscription'] != null
        ? Subscription.fromJson(json['subscription'])
        : null;
  }
}
