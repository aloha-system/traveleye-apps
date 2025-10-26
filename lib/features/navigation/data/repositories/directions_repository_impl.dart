import 'package:boole_apps/features/navigation/data/datasources/directions_remote_datasource.dart';
import 'package:boole_apps/features/navigation/domain/repositories/directions_repository.dart';

class DirectionsRepositoryImpl implements DirectionsRepository {
  final DirectionsRemoteDatasource _remote;
  DirectionsRepositoryImpl(this._remote);

  @override
  Future<DirectionsResult> getRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String mode = 'driving',
  }) {
    return _remote.getRoute(
      originLat: originLat,
      originLng: originLng,
      destLat: destLat,
      destLng: destLng,
      mode: mode,
    );
  }
}
