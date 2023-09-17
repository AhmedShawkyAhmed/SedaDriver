class TodayEarning {
  int? userId;
  int? tripsNum;
  num? dailyEarning;

  TodayEarning({this.userId, this.tripsNum, this.dailyEarning});

  TodayEarning.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    tripsNum = json['trips_num'];
    dailyEarning = json['dailyEaring'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['trips_num'] = tripsNum;
    data['dailyEaring'] = dailyEarning;
    return data;
  }
}
