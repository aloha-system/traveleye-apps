import 'package:boole_apps/features/search/domain/entities/destination.dart';
import 'package:boole_apps/features/search/domain/usecases/search_destinations_usecase.dart';

/// Kontrak repository untuk fitur Search
/// yang menghubungkan antara Domain ↔ Data layer
abstract class SearchRepository {
  /// Cari destinasi wisata berdasarkan parameter
  Future<List<Destination>> search(SearchParams params);
}
