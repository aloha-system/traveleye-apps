import 'package:boole_apps/features/search/domain/entities/destination.dart';
import 'package:boole_apps/features/search/domain/repositories/search_repository.dart';
import 'package:boole_apps/features/search/domain/usecases/search_destinations_usecase.dart';
import 'package:boole_apps/features/search/data/datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDatasource remote;
  SearchRepositoryImpl(this.remote);

  @override
  Future<List<Destination>> search(SearchParams params) async {
    final rows = await remote.searchRaw(
      keyword: params.keyword,
      popularOnly: params.popularOnly,
      nearbyOnly: params.nearbyOnly,
      maxBudget: params.maxBudget,
    );

    return rows.map((r) {
      return Destination(
        id: r['id'] ?? '',
        name: r['name'] ?? '',
        description: r['description'] ?? '',
        city: r['city'] ?? '',
        province: r['province'] ?? '',
        rating: (r['rating'] is num) ? (r['rating'] as num).toDouble() : 0.0,
        ticketPrice: (r['ticket_price'] is num) ? (r['ticket_price'] as num).toInt() : 0,
        latitude: (r['latitude'] is num) ? (r['latitude'] as num).toDouble() : null,
        longitude: (r['longitude'] is num) ? (r['longitude'] as num).toDouble() : null,
        category: r['category'] ?? '',
        facilities: (r['facilities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
        openingHours: (r['opening_hours'] as Map<String, dynamic>?)
            ?.map((k, v) => MapEntry(k, v.toString())) ?? const {},
        imageUrls: (r['image_urls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      );
    }).toList();
  }
}
