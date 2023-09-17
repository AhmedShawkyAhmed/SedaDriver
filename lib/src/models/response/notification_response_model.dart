import '../notification.dart';

class NotificationResponseModel {
  String? message;
  Data? data;

  NotificationResponseModel({this.message, this.data});

  NotificationResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<Notification>? massages;

  Data({this.massages});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['massages'] != null) {
      massages = <Notification>[];
      json['massages'].forEach((v) {
        massages!.add(Notification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (massages != null) {
      data['massages'] = massages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

