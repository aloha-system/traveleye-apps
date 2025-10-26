import 'package:boole_apps/features/navigation/data/datasources/directions_remote_datasource.dart';

abstract class DirectionsRepository {
  Future<DirectionsResult> getRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String mode,
  });
}
