import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:boole_apps/features/navigation/domain/usecases/get_route_usecase.dart';
import 'package:boole_apps/features/navigation/data/datasources/directions_remote_datasource.dart';

class RouteProvider extends ChangeNotifier {
  final GetRouteUsecase _getRoute;

  RouteProvider({required GetRouteUsecase getRoute}) : _getRoute = getRoute;

  Position? _origin;
  DirectionsResult? _route;
  Object? _error;
  bool _loading = false;

  Position? get origin => _origin;
  DirectionsResult? get route => _route;
  Object? get error => _error;
  bool get loading => _loading;

  Future<void> loadRoute({
    required double destLat,
    required double destLng,
    String mode = 'driving',
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final hasPermission = await _ensureLocationPermission();
      if (!hasPermission) throw Exception('Location permission denied');

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      _origin = pos;

      try {
        final res = await _getRoute(
          originLat: pos.latitude,
          originLng: pos.longitude,
          destLat: destLat,
          destLng: destLng,
          mode: mode,
        );
        _route = res;
      } catch (e) {
        final msg = e.toString();
        final isZeroResults = msg.contains('ZERO_RESULTS');
        final isDriving = mode == 'driving';
        if (isZeroResults && isDriving) {
          // Fallback to walking
          final res = await _getRoute(
            originLat: pos.latitude,
            originLng: pos.longitude,
            destLat: destLat,
            destLng: destLng,
            mode: 'walking',
          );
          _route = res;
        } else {
          rethrow;
        }
      }
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> _ensureLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }
}
