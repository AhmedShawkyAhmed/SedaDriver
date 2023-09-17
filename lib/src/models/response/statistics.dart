class Statistics {
  String? totalTime;
  int? orderCount;
  num? cancellationPercent;
  String? level;

  Statistics(
      {this.totalTime, this.orderCount, this.cancellationPercent, this.level});

  Statistics.fromJson(Map<String, dynamic> json) {
    totalTime = json['totalTime'];
    orderCount = json['orderCount'];
    cancellationPercent = json['cancellationPercent'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalTime'] = totalTime;
    data['orderCount'] = orderCount;
    data['cancellationPercent'] = cancellationPercent;
    data['level'] = level;
    return data;
  }
}
