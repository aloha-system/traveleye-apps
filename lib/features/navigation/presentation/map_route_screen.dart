import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:boole_apps/features/navigation/presentation/providers/route_provider.dart';

class MapRouteScreen extends StatefulWidget {
  final double destinationLat;
  final double destinationLng;
  final String title;

  const MapRouteScreen({
    super.key,
    required this.destinationLat,
    required this.destinationLng,
    this.title = 'Route',
  });

  @override
  State<MapRouteScreen> createState() => _MapRouteScreenState();
}

class _MapRouteScreenState extends State<MapRouteScreen> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  String _mode = 'driving'; // driving | walking | transit

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RouteProvider>().loadRoute(
        destLat: widget.destinationLat,
        destLng: widget.destinationLng,
        mode: _mode,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<RouteProvider>();

    final dest = LatLng(widget.destinationLat, widget.destinationLng);

    if (c.origin != null) {
      _markers = {
        Marker(
          markerId: const MarkerId('origin'),
          position: LatLng(c.origin!.latitude, c.origin!.longitude),
        ),
        Marker(markerId: const MarkerId('destination'), position: dest),
      };
    } else {
      _markers = {
        Marker(markerId: const MarkerId('destination'), position: dest),
      };
    }

    _polylines = {};
    if (c.route != null) {
      final points = _decodePolyline(
        c.route!.encodedPolyline,
      ).map((e) => LatLng(e.$1, e.$2)).toList(growable: false);

      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: Theme.of(context).colorScheme.primary,
          width: 5,
        ),
      };
    }

    final initial = c.origin != null
        ? CameraPosition(
            target: LatLng(c.origin!.latitude, c.origin!.longitude),
            zoom: 13,
          )
        : CameraPosition(target: dest, zoom: 13);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // Mode selector
          PopupMenuButton<String>(
            tooltip: 'Travel mode',
            initialValue: _mode,
            onSelected: (m) {
              if (m == _mode) return;
              setState(() => _mode = m);
              context.read<RouteProvider>().loadRoute(
                destLat: widget.destinationLat,
                destLng: widget.destinationLng,
                mode: _mode,
              );
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'driving', child: Text('Driving')),
              PopupMenuItem(value: 'walking', child: Text('Walking')),
              PopupMenuItem(value: 'transit', child: Text('Transit')),
            ],
            icon: const Icon(Icons.tune),
          ),
          if (c.route != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Text(
                  _formatDistanceDuration(
                    c.route!.distanceMeters,
                    c.route!.durationSeconds,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initial,
            onMapCreated: (ctrl) => _controller = ctrl,
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
          ),
          if (c.loading)
            const Positioned.fill(
              child: IgnorePointer(
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          if (c.error != null && !c.loading)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Material(
                color: Colors.red.shade700,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    '${c.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (c.origin != null) {
            _fitToBounds(LatLng(c.origin!.latitude, c.origin!.longitude), dest);
          }
        },
        child: const Icon(Icons.route),
      ),
    );
  }

  String _formatDistanceDuration(int meters, int seconds) {
    final km = (meters / 1000).toStringAsFixed(1);
    final mins = (seconds / 60).round();
    return '$km km • ${mins}m';
  }

  void _fitToBounds(LatLng a, LatLng b) {
    final southWest = LatLng(
      math.min(a.latitude, b.latitude),
      math.min(a.longitude, b.longitude),
    );
    final northEast = LatLng(
      math.max(a.latitude, b.latitude),
      math.max(a.longitude, b.longitude),
    );
    final bounds = LatLngBounds(southwest: southWest, northeast: northEast);
    _controller?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  // Minimal polyline decoder (no dependency)
  List<(double, double)> _decodePolyline(String encoded) {
    List<(double, double)> points = [];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add((lat / 1e5, lng / 1e5));
    }

    return points;
  }
}
