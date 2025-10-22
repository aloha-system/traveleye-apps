import 'package:boole_apps/features/emergency/data/datasources/e_services_remote_datasource.dart';
import 'package:boole_apps/features/emergency/domain/entities/emergency_service_entity.dart';
import 'package:boole_apps/features/emergency/domain/repositories/emergency_repository.dart';

class EmergencyRepositoryImpl implements EmergencyRepository {
  final EmergencyRemoteDatasource remoteDatasource;

  EmergencyRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<EmergencyServiceEntity>> getAllServices() async {
    try {
      return await remoteDatasource.getAllServices();
    } catch (e) {
      throw Exception('Repository: Failed to get all services - $e');
    }
  }

  @override
  Future<List<EmergencyServiceEntity>> getServicesByCategory(
    String category,
  ) async {
    try {
      return await remoteDatasource.getServicesByCategory(category);
    } catch (e) {
      throw Exception('Repository: Failed to get services by category - $e');
    }
  }

  @override
  Future<List<EmergencyServiceEntity>> searchServices(String query) async {
    try {
      return await remoteDatasource.searchServices(query);
    } catch (e) {
      throw Exception('Repository: Failed to search services - $e');
    }
  }

  @override
  Future<List<EmergencyServiceEntity>> getPriorityServices() async {
    try {
      return await remoteDatasource.getPriorityServices();

      // return data.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get priority services - $e');
    }
  }

  @override
  Future<EmergencyServiceEntity?> getServiceById(String id) async {
    try {
      return await remoteDatasource.getServiceById(id);
    } catch (e) {
      throw Exception('Repository: Failed to get service by id - $e');
    }
  }
}
