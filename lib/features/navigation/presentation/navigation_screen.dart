import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:boole_apps/app/app_router.dart';
import 'package:boole_apps/features/destination/domain/usecases/search_destinations_usecase.dart';
import 'package:boole_apps/features/destination/domain/entities/destination.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  CameraPosition _initial = const CameraPosition(
    target: LatLng(-6.2, 106.8),
    zoom: 11,
  ); // Jakarta fallback
  bool _loading = true;
  String? _error;
  final TextEditingController _searchCtrl = TextEditingController();
  bool _searching = false;
  List<Destination> _results = const [];
  Destination? _selected;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _runSearch(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _searching = true;
      _results = const [];
    });
    try {
      final usecase = context.read<SearchDestinationsUsecase>();
      final entities = await usecase(
        SearchParams(keyword: query, popularOnly: false, nearbyOnly: false),
      );
      setState(() {
        _results = entities.cast<Destination>();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Search failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _searching = false;
        });
      }
    }
  }

  Future<void> _initLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = 'Location services are disabled.';
          _loading = false;
        });
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'Location permission denied';
            _loading = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'Location permissions are permanently denied';
          _loading = false;
        });
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        _initial = CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 14,
        );
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(
                        hintText: 'Search destination…',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (q) => _runSearch(q),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => _runSearch(_searchCtrl.text),
                    child: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
            if (_searching) const LinearProgressIndicator(minHeight: 2),
            if (_results.isNotEmpty && _selected == null)
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final d = _results[i];
                    return ListTile(
                      leading: const Icon(Icons.place_outlined),
                      title: Text(d.name),
                      subtitle: Text('${d.city}, ${d.province}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        if (d.latitude != null && d.longitude != null) {
                          Navigator.pushNamed(
                            context,
                            AppRouter.mapRoute,
                            arguments: {
                              'lat': d.latitude!,
                              'lng': d.longitude!,
                              'title': d.name,
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Selected destination has no coordinates',
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              )
            else
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: _initial,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    ),
                    if (_loading)
                      const Positioned.fill(
                        child: IgnorePointer(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    if (_error != null && !_loading)
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
                              _error!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
