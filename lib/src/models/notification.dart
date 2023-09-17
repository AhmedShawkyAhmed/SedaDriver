class Notification {
  int? id;
  int? userId;
  String? title;
  String? massage;
  int? isSeen;
  int? notificationId;
  int? createdAt;
  String? createdAtStr;

  Notification(
      {this.id,
        this.userId,
        this.title,
        this.massage,
        this.isSeen,
        this.notificationId,
        this.createdAt,
        this.createdAtStr});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    massage = json['massage'];
    isSeen = json['is_seen'];
    notificationId = json['notification_id'];
    createdAt = json['created_at'];
    createdAtStr = json['created_at_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['massage'] = massage;
    data['is_seen'] = isSeen;
    data['notification_id'] = notificationId;
    data['created_at'] = createdAt;
    data['created_at_str'] = createdAtStr;
    return data;
  }
}
