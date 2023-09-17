import 'package:seda_driver/src/models/user_basic_info.dart';

class UpdateProfileResponseModel {
  UpdateProfileResponseModel({
    this.message,
    this.data,
  });

  UpdateProfileResponseModel.fromJson(dynamic json)
      : message = json['message'],
        data =
        json['data'] != null ? UserBasicInfo.fromJson(json['data']) : null;

  String? message;
  UserBasicInfo? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}