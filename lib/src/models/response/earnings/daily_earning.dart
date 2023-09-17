class DailyEarning {
  int? userId;
  int? tripsNum;
  num? captainPrice;
  num? captainTax;
  num? earning;
  num? discount;
  num? hours;
  String? day;
  String? dayStr;

  DailyEarning(
      {this.userId,
      this.tripsNum,
      this.captainPrice,
      this.captainTax,
      this.earning,
      this.discount,
      this.hours,
      this.day,
      this.dayStr});

  DailyEarning.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    tripsNum = json['trips_num'];
    captainPrice = json['captainPrice'];
    captainTax = json['captainTax'];
    earning = json['earing'];
    discount = json['discount'];
    hours = json['hours'];
    day = json['day'];
    dayStr = json['day_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['trips_num'] = tripsNum;
    data['captainPrice'] = captainPrice;
    data['captainTax'] = captainTax;
    data['earing'] = earning;
    data['discount'] = discount;
    data['hours'] = hours;
    data['day'] = day;
    data['day_str'] = dayStr;
    return data;
  }
}
