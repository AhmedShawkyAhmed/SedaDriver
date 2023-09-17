import 'package:seda_driver/src/models/response/wallet_&_points/points.dart';

class PointsResponse {
  String? message;
  Data? data;

  PointsResponse({this.message, this.data});

  PointsResponse.fromJson(Map<String, dynamic> json) {
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
  Points? points;

  Data({this.points});

  Data.fromJson(Map<String, dynamic> json) {
    points = json['Points'] != null ? Points.fromJson(json['Points']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (points != null) {
      data['Points'] = points!.toJson();
    }
    return data;
  }
}
