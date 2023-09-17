
import 'package:seda_driver/src/models/order_model.dart';

class OrderResponse{
  String? event;
  String? message;
  OrderModel? orderModel;

  OrderResponse({
     this.event,
     this.message,
     this.orderModel,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
    event: json["event"] ?? "",
    message: json["message"] ?? "",
    orderModel: json["data"] == null
        ? null
        : OrderModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "event": event,
    "message": message,
    "data": orderModel,
  };
}