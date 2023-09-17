import 'package:seda_driver/src/models/response/auth/profile_response/user_model.dart';

class ProfileResponseModel {
  ProfileResponseModel({
    this.message,
    this.data,
  });

  ProfileResponseModel.fromJson(dynamic json)
      : message = json['message'],
        data = json['data'] != null ? UserModel.fromJson(json['data']) : null;

  String? message;
  UserModel? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}
