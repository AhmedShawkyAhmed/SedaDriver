import 'package:latlong2/latlong.dart';
import 'package:latlong2/latlong.dart' as Distance;

LatLng findNearestPoint(LatLng givenPoint, List<LatLng> polylineCoordinates) {
  double shortestDistance = double.infinity;
  LatLng nearestPoint = LatLng(0, 0);

  for (int i = 0; i < polylineCoordinates.length - 1; i++) {
    LatLng start = polylineCoordinates[i];
    LatLng end = polylineCoordinates[i + 1];

    double distance = Distance.Distance().as(
      Distance.LengthUnit.Meter,
      givenPoint,
      start,
    );

    if (distance < shortestDistance) {
      shortestDistance = distance;
      nearestPoint = start;
    }

    distance = Distance.Distance().as(
      Distance.LengthUnit.Meter,
      givenPoint,
      end,
    );

    if (distance < shortestDistance) {
      shortestDistance = distance;
      nearestPoint = end;
    }
  }

  // Check if the given point is outside the polyline
  if (polylineCoordinates.isNotEmpty) {
    double startDistance = Distance.Distance().as(
      Distance.LengthUnit.Meter,
      givenPoint,
      polylineCoordinates.first,
    );

    double endDistance = Distance.Distance().as(
      Distance.LengthUnit.Meter,
      givenPoint,
      polylineCoordinates.last,
    );

    if (startDistance < shortestDistance) {
      shortestDistance = startDistance;
      nearestPoint = polylineCoordinates.first;
    }

    if (endDistance < shortestDistance) {
      shortestDistance = endDistance;
      nearestPoint = polylineCoordinates.last;
    }
  }

  return nearestPoint;
}
