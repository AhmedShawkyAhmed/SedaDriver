import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class DriverImagesUploadRequest {
  final List<DriverImage> images;

  DriverImagesUploadRequest({
    required this.images,
  });

  Map<String, dynamic> toJson() {
    final body = <String, dynamic>{};
    for (int i = 0; i < images.length; i++) {
      body['images[$i][image]'] = MultipartFile.fromFileSync(
        images[i].image.path,
      );
      body['images[$i][mediaable_type]'] =
          images[i].imageType.mediableType.mediableType;
      body['images[$i][type]'] = images[i].imageType.type;
      body['images[$i][Second_type]'] =
          images[i].imageType.secondType.secondType;
    }
    return body;
  }
}

class DriverImage {
  final XFile image;
  final DriverImageType imageType;

  DriverImage({
    required this.image,
    required this.imageType,
  });
}

enum DriverImageType {
  nationalIdFront(
    MediableType.user,
    "nationalId",
    SecondType.front,
  ),
  nationalIdBack(
    MediableType.user,
    "nationalId",
    SecondType.back,
  ),
  driverLicenseFront(
    MediableType.user,
    "driverLicense",
    SecondType.front,
  ),
  driverLicenseBack(
    MediableType.user,
    "driverLicense",
    SecondType.back,
  ),
  vehicleLicenseFront(
    MediableType.vehicle,
    "vehicleLicense",
    SecondType.front,
  ),
  vehicleLicenseBack(
    MediableType.vehicle,
    "vehicleLicense",
    SecondType.back,
  ),
  driverCriminalRecorder(
    MediableType.user,
    "DriverCriminalRecorder",
    SecondType.front,
  ),
  vehiclePlateNumber(
    MediableType.vehicle,
    "vehiclePlatNumber",
    SecondType.front,
  ),
  vehicleImage(
    MediableType.vehicle,
    "vehicleImage",
    SecondType.front,
  );

  const DriverImageType(
    this.mediableType,
    this.type,
    this.secondType,
  );

  final MediableType mediableType;
  final String type;
  final SecondType secondType;
}

enum MediableType {
  user("user"),
  vehicle("vehicle");

  const MediableType(this.mediableType);

  final String mediableType;
}

enum SecondType {
  front("front"),
  back("back");

  const SecondType(this.secondType);

  final String secondType;
}
