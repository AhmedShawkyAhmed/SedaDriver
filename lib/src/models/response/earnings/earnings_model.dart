import 'package:seda_driver/src/models/response/earnings/daily_earning.dart';

class EarningsModel {
  String? message;
  Data? data;

  EarningsModel({this.message, this.data});

  EarningsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  DailyEarning? dailyEarning;
  List<DailyEarning>? previousEarning;

  Data({this.dailyEarning, this.previousEarning});

  Data.fromJson(Map<String, dynamic> json) {
    dailyEarning = json['dailyEaring'] != null
        ? DailyEarning.fromJson(json['dailyEaring'])
        : null;
    if (json['previousEaring'] != null) {
      previousEarning = <DailyEarning>[];
      json['previousEaring'].forEach((v) {
        previousEarning!.add(DailyEarning.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dailyEarning != null) {
      data['dailyEaring'] = dailyEarning!.toJson();
    }
    if (previousEarning != null) {
      data['previousEaring'] = previousEarning!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
