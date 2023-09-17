import 'package:seda_driver/src/models/response/auth/check_register_response/check_register_data.dart';

class CheckRegisterResponse {
  String? message;
  CheckRegisterData? checkRegisterData;

  CheckRegisterResponse({this.message, this.checkRegisterData});

  CheckRegisterResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    checkRegisterData =
        json['data'] != null ? CheckRegisterData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (checkRegisterData != null) {
      data['data'] = checkRegisterData!.toJson();
    }
    return data;
  }
}
