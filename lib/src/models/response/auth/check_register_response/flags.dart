class Flags {
  int? basicInfo;
  int? nationalId;
  int? driverLicense;
  int? driverCriminalRecorder;
  int? vehicleLicense;
  int? vehiclePlatNumber;
  int? vehicleImage;

  Flags(
      {this.basicInfo,
        this.nationalId,
        this.driverLicense,
        this.driverCriminalRecorder,
        this.vehicleLicense,
        this.vehiclePlatNumber,
        this.vehicleImage});

  Flags.fromJson(Map<String, dynamic> json) {
    basicInfo = json['basicInfo'];
    nationalId = json['nationalId'];
    driverLicense = json['driverLicense'];
    driverCriminalRecorder = json['DriverCriminalRecorder'];
    vehicleLicense = json['vehicleLicense'];
    vehiclePlatNumber = json['vehiclePlatNumber'];
    vehicleImage = json['vehicleImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['basicInfo'] = basicInfo;
    data['nationalId'] = nationalId;
    data['driverLicense'] = driverLicense;
    data['DriverCriminalRecorder'] = driverCriminalRecorder;
    data['vehicleLicense'] = vehicleLicense;
    data['vehiclePlatNumber'] = vehiclePlatNumber;
    data['vehicleImage'] = vehicleImage;
    return data;
  }
}