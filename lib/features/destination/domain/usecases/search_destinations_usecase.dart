import 'package:boole_apps/features/destination/domain/entities/destination.dart';
import 'package:boole_apps/features/destination/domain/repositories/destination_repository.dart';

/// Parameter pencarian destinasi wisata
class SearchParams {
  final String keyword;
  final bool popularOnly;   // filter rating >= 4.7
  final bool nearbyOnly;    // TODO: bisa dipakai untuk filter jarak (belum aktif)
  final int? maxBudget;     // filter harga tiket
  final DateTime? startDate; // opsional (misal untuk event-based)
  final DateTime? endDate;   // opsional

  const SearchParams({
    this.keyword = '',
    this.popularOnly = false,
    this.nearbyOnly = false,
    this.maxBudget,
    this.startDate,
    this.endDate,
  });

  SearchParams copyWith({
    String? keyword,
    bool? popularOnly,
    bool? nearbyOnly,
    int? maxBudget,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return SearchParams(
      keyword: keyword ?? this.keyword,
      popularOnly: popularOnly ?? this.popularOnly,
      nearbyOnly: nearbyOnly ?? this.nearbyOnly,
      maxBudget: maxBudget ?? this.maxBudget,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

/// Usecase untuk mencari destinasi wisata
class SearchDestinationsUsecase {
  final DestinationRepository _repository;
  const SearchDestinationsUsecase(this._repository);

  Future<List<Destination>> call(SearchParams params) {
    return _repository.search(params);
  }
}
