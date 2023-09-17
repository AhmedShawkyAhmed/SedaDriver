import 'package:seda_driver/src/models/order_model.dart';

class EndOrderResponse {
  List<OrderModel>? data;
  String? message;

  EndOrderResponse({this.data, this.message});

  factory EndOrderResponse.fromJson(Map<String, dynamic> json) {
    return EndOrderResponse(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((i) => OrderModel.fromJson(i))
              .toList()
          : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
