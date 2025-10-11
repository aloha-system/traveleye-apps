import 'dart:async';
import 'package:flutter/material.dart';
import 'package:boole_apps/features/destination/domain/usecases/search_destinations_usecase.dart';

class SearchItem {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final String ratingText;

  const SearchItem({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.ratingText,
  });
}

typedef DestinationMapper = SearchItem Function(Object entity);

class DestinationProvider extends ChangeNotifier {
  final SearchDestinationsUsecase _usecase;
  final DestinationMapper _mapper;

  DestinationProvider({
    required SearchDestinationsUsecase useCase,
    required DestinationMapper mapper,
  })  : _usecase = useCase,
        _mapper = mapper;

  String _keyword = '';
  bool _popularOnly = false;
  bool _nearbyOnly = false;
  int? _maxBudget;
  DateTimeRange? _dateRange;

  bool _loading = false;
  Object? _error;
  List<SearchItem> _results = const [];

  Timer? _debounce;

  String get keyword => _keyword;
  bool get popularOnly => _popularOnly;
  bool get nearbyOnly => _nearbyOnly;
  int? get maxBudget => _maxBudget;
  DateTimeRange? get dateRange => _dateRange;

  bool get loading => _loading;
  Object? get error => _error;
  List<SearchItem> get results => _results;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void prefill(String value) => _keyword = value;
  void setPopular(bool value) => _popularOnly = value;

  void onKeywordChanged(String value) {
    _keyword = value;
    _debouncedSearch();
    notifyListeners();
  }

  void togglePopular() {
    _popularOnly = !_popularOnly;
    _instantSearch();
    notifyListeners();
  }

  void toggleNearby() {
    _nearbyOnly = !_nearbyOnly;
    _instantSearch();
    notifyListeners();
  }

  void setBudget(int? newBudget) {
    _maxBudget = newBudget;
    _instantSearch();
    notifyListeners();
  }

  void setDateRange(DateTimeRange? range) {
    _dateRange = range;
    _instantSearch();
    notifyListeners();
  }

  void clearAll() {
    _keyword = '';
    _popularOnly = false;
    _nearbyOnly = false;
    _maxBudget = null;
    _dateRange = null;
    _instantSearch();
    notifyListeners();
  }

  void _debouncedSearch() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _search);
  }

  void _instantSearch() {
    _debounce?.cancel();
    _search();
  }

  Future<void> initialSearchIfNeeded() async => _search();
  Future<void> retry() async => _search();

  Future<void> _search() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final q = SearchParams(
        keyword: _keyword,
        popularOnly: _popularOnly,
        nearbyOnly: _nearbyOnly,
        maxBudget: _maxBudget,
        startDate: _dateRange?.start,
        endDate: _dateRange?.end,
      );

      final entities = await _usecase(q);
      _results = entities.map<SearchItem>(_mapper).toList(growable: false);
    } catch (e) {
      _error = e;
      _results = const [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
