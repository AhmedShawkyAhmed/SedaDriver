class Transaction {
  int? id;
  int? transableId;
  String? transableType;
  String? amount;
  String? type;
  String? createdAt;
  String? updatedAt;

  Transaction(
      {this.id,
      this.transableId,
      this.transableType,
      this.amount,
      this.type,
      this.createdAt,
      this.updatedAt});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transableId = json['transable_id'];
    transableType = json['transable_type'];
    amount = json['amount'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transable_id'] = transableId;
    data['transable_type'] = transableType;
    data['amount'] = amount;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
