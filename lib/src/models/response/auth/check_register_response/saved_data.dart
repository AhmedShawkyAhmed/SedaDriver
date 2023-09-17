import 'package:seda_driver/src/models/response/auth/check_register_response/basic_info.dart';
import 'package:seda_driver/src/models/response/auth/check_register_response/registeration_image_model.dart';
import 'package:seda_driver/src/models/vehicle_info.dart';

class SavedData {
  BasicInfo? basicInfo;
  VehicleInfo? vehicle;
  List<RegisterImageModel>? nationalId;
  List<RegisterImageModel>? driverLicense;
  List<RegisterImageModel>? driverCriminalRecorder;
  List<RegisterImageModel>? vehicleLicense;
  List<RegisterImageModel>? vehiclePlatNumber;
  List<RegisterImageModel>? vehicleImage;

  SavedData(
      {this.basicInfo,
      this.vehicle,
      this.nationalId,
      this.driverLicense,
      this.driverCriminalRecorder,
      this.vehicleLicense,
      this.vehiclePlatNumber,
      this.vehicleImage});

  SavedData.fromJson(Map<String, dynamic> json) {
    basicInfo = json['basicInfo'] != null
        ? BasicInfo.fromJson(json['basicInfo'])
        : null;
    vehicle =
        json['Vehicle'] != null ? VehicleInfo.fromJson(json['Vehicle']) : null;
    nationalId = json['nationalId'] != null
        ? RegisterImageModel.fromJsonList(json['nationalId'])
        : null;
    driverLicense = json['driverLicense'] != null
        ? RegisterImageModel.fromJsonList(json['driverLicense'])
        : null;
    driverCriminalRecorder = json['DriverCriminalRecorder'] != null
        ? RegisterImageModel.fromJsonList(json['DriverCriminalRecorder'])
        : null;
    vehicleLicense = json['vehicleLicense'] != null
        ? RegisterImageModel.fromJsonList(json['vehicleLicense'])
        : null;
    vehiclePlatNumber = json['vehiclePlatNumber'] != null
        ? RegisterImageModel.fromJsonList(json['vehiclePlatNumber'])
        : null;
    vehicleImage = json['vehicleImage'] != null
        ? RegisterImageModel.fromJsonList(json['vehicleImage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['basicInfo'] = basicInfo?.toJson();
    data['Vehicle'] = vehicle?.toJson();

    data['nationalId'] = nationalId?.map((e) => e.toJson()).toList();
    data['driverLicense'] = driverLicense?.map((e) => e.toJson()).toList();
    data['DriverCriminalRecorder'] =
        driverCriminalRecorder?.map((e) => e.toJson()).toList();
    data['vehicleLicense'] = vehicleLicense?.map((e) => e.toJson()).toList();
    data['vehiclePlatNumber'] =
        vehiclePlatNumber?.map((e) => e.toJson()).toList();
    data['vehicleImage'] = vehicleImage?.map((e) => e.toJson()).toList();
    return data;
  }
}
