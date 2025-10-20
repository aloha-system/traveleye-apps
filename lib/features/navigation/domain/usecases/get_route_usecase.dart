import 'package:boole_apps/features/navigation/data/datasources/directions_remote_datasource.dart';
import 'package:boole_apps/features/navigation/domain/repositories/directions_repository.dart';

class GetRouteUsecase {
  final DirectionsRepository _repo;
  GetRouteUsecase(this._repo);

  Future<DirectionsResult> call({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String mode = 'driving',
  }) => _repo.getRoute(
        originLat: originLat,
        originLng: originLng,
        destLat: destLat,
        destLng: destLng,
        mode: mode,
      );
}
