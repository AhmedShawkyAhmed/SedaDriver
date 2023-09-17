import 'package:seda_driver/src/models/driver_images.dart';
import 'package:seda_driver/src/models/vehicle_info.dart';

class UserBasicInfo {
  int? id;
  String? name;
  String? phone;
  String? nickName;
  String? birth;
  String? email;
  String? code;
  String? idNumber;
  String? address;
  String? type;
  String? userName;
  bool? isOnline;
  String? rate;
  String? image;
  DriverImages? driverImages;

  UserBasicInfo({
    this.id,
    this.name,
    this.phone,
    this.nickName,
    this.birth,
    this.email,
    this.code,
    this.idNumber,
    this.address,
    this.type,
    this.userName,
    this.isOnline,
    this.rate,
    this.image,
    this.driverImages,
  });

  UserBasicInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    nickName = json['nickName'];
    birth = json['birth'];
    email = json['email'];
    code = json['code'];
    idNumber = json['id_number'];
    address = json['address'];
    type = json['type'];
    userName = json['userName'];
    isOnline = json['is_online'];
    rate = json['rate'];
    image = json['image'];
    driverImages = json['driverImages'] != null
        ? DriverImages.fromJson(json['driverImages'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['nickName'] = nickName;
    data['birth'] = birth;
    data['email'] = email;
    data['code'] = code;
    data['id_number'] = idNumber;
    data['address'] = address;
    data['type'] = type;
    data['userName'] = userName;
    data['is_online'] = isOnline;
    data['rate'] = rate;
    data['image'] = image;
    if (driverImages != null) {
      data['driverImages'] = driverImages!.toJson();
    }
    return data;
  }
}
