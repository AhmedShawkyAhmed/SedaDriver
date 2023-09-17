// ignore_for_file: non_constant_identifier_names

class GovernOrderResponse {
  Data? data;
  String? message;

  GovernOrderResponse({this.data, this.message});

  factory GovernOrderResponse.fromJson(Map<String, dynamic> json) {
    return GovernOrderResponse(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  Order? order;

  Data({this.order});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      order: json['order'] != null ? Order.fromJson(json['order']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (order != null) {
      data['order'] = order?.toJson();
    }
    return data;
  }
}

class Order {
  int? created_at;
  String? created_at_str;
  Driver? driver;
  FromLocation? fromLocation;
  int? id;
  List<dynamic>? passenger;
  String? payment_type_id;
  List<Point>? points;
  String? status;
  ToLocation? toLocation;
  bool? valid;

  Order(
      {this.created_at,
      this.created_at_str,
      this.driver,
      this.fromLocation,
      this.id,
      this.passenger,
      this.payment_type_id,
      this.points,
      this.status,
      this.toLocation,
      this.valid});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      created_at: json['created_at'],
      created_at_str: json['created_at_str'],
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
      fromLocation: json['fromLocation'] != null
          ? FromLocation.fromJson(json['fromLocation'])
          : null,
      id: json['id'],
      passenger: json['passenger'] != null
          ? (json['passenger'] as List).map((i) => i).toList()
          : null,
      payment_type_id: json['payment_type_id'],
      points: json['points'] != null
          ? (json['points'] as List).map((i) => Point.fromJson(i)).toList()
          : null,
      status: json['status'],
      toLocation: json['toLocation'] != null
          ? ToLocation.fromJson(json['toLocation'])
          : null,
      valid: json['valid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = created_at;
    data['created_at_str'] = created_at_str;
    data['id'] = id;
    data['payment_type_id'] = payment_type_id;
    data['status'] = status;
    data['valid'] = valid;
    if (driver != null) {
      data['driver'] = driver?.toJson();
    }
    if (fromLocation != null) {
      data['fromLocation'] = fromLocation?.toJson();
    }
    if (passenger != null) {
      data['passenger'] = passenger?.map((v) => v.toJson()).toList();
    }
    if (points != null) {
      data['points'] = points?.map((v) => v.toJson()).toList();
    }
    if (toLocation != null) {
      data['toLocation'] = toLocation?.toJson();
    }
    return data;
  }
}

class FromLocation {
  dynamic address;
  int? created_at;
  String? created_at_str;
  int? id;
  double? latitude;
  double? longitude;
  String? type;

  FromLocation(
      {this.address,
      this.created_at,
      this.created_at_str,
      this.id,
      this.latitude,
      this.longitude,
      this.type});

  factory FromLocation.fromJson(Map<String, dynamic> json) {
    return FromLocation(
      address: json['address'],
      created_at: json['created_at'],
      created_at_str: json['created_at_str'],
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = created_at;
    data['created_at_str'] = created_at_str;
    data['id'] = id;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['type'] = type;
    data['address'] = address;
    return data;
  }
}

class Driver {
  dynamic birth;
  DriverImages? driverImages;
  dynamic email;
  int? id;
  dynamic image;
  bool? is_online;
  String? name;
  dynamic nickName;
  String? phone;
  String? rate;
  String? type;

  Driver(
      {this.birth,
      this.driverImages,
      this.email,
      this.id,
      this.image,
      this.is_online,
      this.name,
      this.nickName,
      this.phone,
      this.rate,
      this.type});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      birth: json['birth'],
      driverImages: json['driverImages'] != null
          ? DriverImages.fromJson(json['driverImages'])
          : null,
      email: json['email'],
      id: json['id'],
      image: json['image'],
      is_online: json['is_online'],
      name: json['name'],
      nickName: json['nickName'],
      phone: json['phone'],
      rate: json['rate'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_online'] = is_online;
    data['name'] = name;
    data['phone'] = phone;
    data['rate'] = rate;
    data['type'] = type;
    data['birth'] = birth;
    if (driverImages != null) {
      data['driverImages'] = driverImages?.toJson();
    }
    data['email'] = email;
    data['image'] = image;

    data['nickName'] = nickName;

    return data;
  }
}

class DriverImages {
  String? capten_leciens;

  DriverImages({this.capten_leciens});

  factory DriverImages.fromJson(Map<String, dynamic> json) {
    return DriverImages(
      capten_leciens: json['capten_leciens'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['capten_leciens'] = capten_leciens;
    return data;
  }
}

class Point {
  dynamic address;
  int? created_at;
  String? created_at_str;
  int? id;
  double? latitude;
  double? longitude;
  String? type;

  Point(
      {this.address,
      this.created_at,
      this.created_at_str,
      this.id,
      this.latitude,
      this.longitude,
      this.type});

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      address: json['address'],
      created_at: json['created_at'],
      created_at_str: json['created_at_str'],
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = created_at;
    data['created_at_str'] = created_at_str;
    data['id'] = id;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['type'] = type;
    if (address != null) {
      data['address'] = address.toJson();
    }
    return data;
  }
}

class ToLocation {
  dynamic address;
  int? created_at;
  String? created_at_str;
  int? id;
  double? latitude;
  double? longitude;
  String? type;

  ToLocation(
      {this.address,
      this.created_at,
      this.created_at_str,
      this.id,
      this.latitude,
      this.longitude,
      this.type});

  factory ToLocation.fromJson(Map<String, dynamic> json) {
    return ToLocation(
      address: json['address'],
      created_at: json['created_at'],
      created_at_str: json['created_at_str'],
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = created_at;
    data['created_at_str'] = created_at_str;
    data['id'] = id;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['type'] = type;
    data['address'] = address;
    return data;
  }
}
