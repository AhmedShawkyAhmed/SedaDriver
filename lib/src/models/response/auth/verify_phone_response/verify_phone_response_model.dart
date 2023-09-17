import 'data.dart';

class VerifyPhoneResponseModel {
  VerifyPhoneResponseModel({
    this.message,
    this.data,
  });

  VerifyPhoneResponseModel.fromJson(dynamic json)
      : message = json['message'],
        data = json['data'] != null
            ? Data.fromJson(
                json['data'],
              )
            : null;

  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}
