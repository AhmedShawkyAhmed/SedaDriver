import 'package:seda_driver/src/models/response/wallet_&_points/wallet.dart';

class WalletResponse {
  String? message;
  Data? data;

  WalletResponse({this.message, this.data});

  WalletResponse.fromJson(Map<String, dynamic> json) {
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
  Wallet? wallet;

  Data({this.wallet});

  Data.fromJson(Map<String, dynamic> json) {
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    return data;
  }
}
