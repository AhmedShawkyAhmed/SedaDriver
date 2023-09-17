import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class RegisterRequest {
  final String name;
  final int vehicleId;
  final int colorId;
  final int carNumber;
  final int carPurchaseYear;
  final double locationLatitude;
  final double locationLongitude;
  final String locationAddress;
  final String? nickName;
  final String? email;
  final String? birthDate;
  final XFile? image;

  RegisterRequest({
    required this.name,
    required this.vehicleId,
    required this.colorId,
    required this.carNumber,
    required this.carPurchaseYear,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.locationAddress,
    this.nickName,
    this.email,
    this.image,
    this.birthDate,
  });

  Map<String, dynamic> toJson() {
    final body = <String, dynamic>{
      'name': name,
      'userDetails[type]': 'captain',
      'vehicle[vehicle_types_id]': vehicleId,
      'vehicle[Vehicle_color_id]': colorId,
      'vehicle[car_number]': carNumber,
      'vehicle[purchase_year]': carPurchaseYear,
      'location[longitude]': locationLongitude,
      'location[latitude]': locationLatitude,
      'location[address]': locationAddress,
    };
    if (nickName != null) {
      body['nickName'] = nickName;
    }
    if (email != null) {
      body['email'] = email;
    }
    if (birthDate != null) {
      body['birth'] = birthDate;
    }
    if (image != null) {
      body['image'] = MultipartFile.fromFileSync(
        image!.path,
        filename: image!.name,
      );
    }
    return body;
  }
}
