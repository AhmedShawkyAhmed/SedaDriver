import 'package:seda_driver/src/models/response/statistics.dart';

class DriverStatistics {
  String? message;
  Statistics? data;

  DriverStatistics({this.message, this.data});

  DriverStatistics.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Statistics.fromJson(json['data']) : null;
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
