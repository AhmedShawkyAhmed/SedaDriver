import 'package:seda_driver/src/models/response/wallet_&_points/transaction.dart';

class Points {
  int? id;
  String? points;
  List<Transaction>? transaction;

  Points({this.id, this.points, this.transaction});

  Points.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    points = json['points'];
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
    data['points'] = points;
    if (transaction != null) {
      data['transaction'] = transaction!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
