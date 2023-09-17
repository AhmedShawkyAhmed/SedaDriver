import 'package:seda_driver/src/models/response/subscription/subscribed_data.dart';

class CheckSubscriptionModel {
  String? message;
  Data? data;

  CheckSubscriptionModel({this.message, this.data});

  CheckSubscriptionModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  bool? flag;
  bool? activeSubscription;
  SubscribedData? subscribedData;

  Data({this.flag, this.subscribedData});

  Data.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    activeSubscription = json['is_active'];
    subscribedData =
        json['data'] != null ? SubscribedData.fromJson(json['data']) : null;
  }
}
