import 'package:seda_driver/src/models/response/earnings/today_earning.dart';

class TodayEarningStatistics {
  String? message;
  Data? data;

  TodayEarningStatistics({this.message, this.data});

  TodayEarningStatistics.fromJson(Map<String, dynamic> json) {
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
  TodayEarning? dailyEarning;

  Data({this.dailyEarning});

  Data.fromJson(Map<String, dynamic> json) {
    dailyEarning = json['dailyEaring'] != null
        ? TodayEarning.fromJson(json['dailyEaring'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dailyEarning != null) {
      data['dailyEaring'] = dailyEarning!.toJson();
    }
    return data;
  }
}
