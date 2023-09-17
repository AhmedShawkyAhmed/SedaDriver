import 'package:seda_driver/src/models/response/auth/check_register_response/flags.dart';
import 'package:seda_driver/src/models/response/auth/check_register_response/saved_data.dart';

class CheckRegisterData {
  int? complete;
  Flags? flags;
  SavedData? savedData;

  CheckRegisterData({this.complete, this.flags, this.savedData});

  CheckRegisterData.fromJson(Map<String, dynamic> json) {
    complete = json['complete'];
    flags = json['flags'] != null ? Flags.fromJson(json['flags']) : null;
    savedData = json['data'] != null ? SavedData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['complete'] = complete;
    if (flags != null) {
      data['flags'] = flags!.toJson();
    }
    if (savedData != null) {
      data['data'] = savedData!.toJson();
    }
    return data;
  }
}
