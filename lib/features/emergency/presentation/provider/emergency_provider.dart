import 'package:boole_apps/features/emergency/domain/entities/emergency_service_entity.dart';
import 'package:boole_apps/features/emergency/domain/usecases/get_all_services_usecase.dart';
import 'package:boole_apps/features/emergency/domain/usecases/get_priority_services_usecase.dart';
import 'package:boole_apps/features/emergency/domain/usecases/get_service_by_id_usecase.dart';
import 'package:boole_apps/features/emergency/domain/usecases/get_services_by_category_usecase.dart';
import 'package:boole_apps/features/emergency/domain/usecases/search_services_usecase.dart';
import 'package:flutter/material.dart';

enum EmergencyStatus { initial, loading, loaded, error }

class EmergencyProvider extends ChangeNotifier {
  final GetAllServicesUsecase getAllServicesUsecase;
  final GetServicesByCategoryUsecase getServicesByCategoryUsecase;
  final SearchServicesUsecase searchServicesUsecase;
  final GetPriorityServicesUsecase getPriorityServicesUsecase;
  final GetServiceByIdUsecase getServiceByIdUsecase;

  EmergencyProvider({
    required this.getAllServicesUsecase,
    required this.getServicesByCategoryUsecase,
    required this.searchServicesUsecase,
    required this.getPriorityServicesUsecase,
    required this.getServiceByIdUsecase,
  });

  // State
  EmergencyStatus _status = EmergencyStatus.initial;
  List<EmergencyServiceEntity> _services = [];
  EmergencyServiceEntity? _selectedService;
  String? _errorMessage;
  String _selectedCategory = 'all';

  // Getters
  EmergencyStatus get status => _status;
  List<EmergencyServiceEntity> get services => _services;
  EmergencyServiceEntity? get selectedService => _selectedService;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _status == EmergencyStatus.loading;
  bool get hasError => _status == EmergencyStatus.error;

  // Methods
  Future<void> loadAllServices() async {
    _setLoading();
    try {
      _services = await getAllServicesUsecase();
      _selectedCategory = 'all';
      _setLoaded();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> loadServicesByCategory(String category) async {
    _setLoading();
    try {
      if (category == 'all') {
        _services = await getAllServicesUsecase();
      } else {
        _services = await getServicesByCategoryUsecase(category);
      }
      _selectedCategory = category;
      _setLoaded();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> searchServices(String query) async {
    if (query.isEmpty) {
      await loadAllServices();
      return;
    }

    _setLoading();
    try {
      _services = await searchServicesUsecase(query);
      _setLoaded();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> loadPriorityServices() async {
    _setLoading();
    try {
      _services = await getPriorityServicesUsecase();
      _selectedCategory = 'priority';
      _setLoaded();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> loadServiceById(String id) async {
    _setLoading();
    try {
      _selectedService = await getServiceByIdUsecase(id);
      _setLoaded();
    } catch (e) {
      _setError(e.toString());
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading() {
    _status = EmergencyStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = EmergencyStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = EmergencyStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}
