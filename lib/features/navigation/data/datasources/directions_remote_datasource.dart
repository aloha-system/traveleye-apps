import 'dart:convert';
import 'package:boole_apps/env/env.dart';
import 'package:http/http.dart' as http;

class DirectionsRemoteDatasource {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json';

  Future<DirectionsResult> getRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String mode = 'driving',
  }) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'origin': '$originLat,$originLng',
        'destination': '$destLat,$destLng',
        'mode': mode,
        'key': Env.googleMapsApiKey,
      },
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Directions API error: HTTP ${res.statusCode}');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final status = data['status'] as String?;
    if (status != 'OK') {
      final err = data['error_message'] ?? status ?? 'Unknown error';
      throw Exception('Directions API failed: $err');
    }

    final routes = (data['routes'] as List).cast<Map<String, dynamic>>();
    if (routes.isEmpty) throw Exception('No routes found');

    final route = routes.first;
    final overview = route['overview_polyline'] as Map<String, dynamic>;
    final polyline = overview['points'] as String;
    final legs = (route['legs'] as List).cast<Map<String, dynamic>>();

    int distanceMeters = 0;
    int durationSeconds = 0;
    for (final leg in legs) {
      distanceMeters += (leg['distance']?['value'] ?? 0) as int;
      durationSeconds += (leg['duration']?['value'] ?? 0) as int;
    }

    return DirectionsResult(
      encodedPolyline: polyline,
      distanceMeters: distanceMeters,
      durationSeconds: durationSeconds,
    );
  }
}

class DirectionsResult {
  final String encodedPolyline;
  final int distanceMeters;
  final int durationSeconds;

  DirectionsResult({
    required this.encodedPolyline,
    required this.distanceMeters,
    required this.durationSeconds,
  });
}
