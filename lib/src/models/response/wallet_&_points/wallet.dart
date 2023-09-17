import 'package:seda_driver/src/models/response/wallet_&_points/transaction.dart';

class Wallet {
  int? id;
  int? userId;
  String? balance;
  String? createdAt;
  String? updatedAt;
  List<Transaction>? transaction;

  Wallet(
      {this.id,
      this.userId,
      this.balance,
      this.createdAt,
      this.updatedAt,
      this.transaction});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    balance = json['balance'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['transaction'] != null) {
      transaction = <Transaction>[];
      json['transaction'].forEach((v) {
        transaction!.add(Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['balance'] = balance;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (transaction != null) {
      data['transaction'] = transaction!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
