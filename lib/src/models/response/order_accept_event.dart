// ignore_for_file: non_constant_identifier_names

import 'package:seda_driver/src/models/order_model.dart';

class OrderAcceptEvent {
  OrderModel? data;
  String? event;
  String? message;

  OrderAcceptEvent({this.data, this.event, this.message});

  factory OrderAcceptEvent.fromJson(Map<String, dynamic> json) {
    return OrderAcceptEvent(
      data: json['data'] != null ? OrderModel.fromJson(json['data']) : null,
      event: json['event'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}
