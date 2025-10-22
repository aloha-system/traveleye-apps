import 'package:boole_apps/features/emergency/domain/entities/emergency_service_entity.dart';

abstract class EmergencyRepository {
  Future<List<EmergencyServiceEntity>> getAllServices();
  Future<List<EmergencyServiceEntity>> getServicesByCategory(String category);
  Future<List<EmergencyServiceEntity>> searchServices(String query);
  Future<List<EmergencyServiceEntity>> getPriorityServices();
  Future<EmergencyServiceEntity?> getServiceById(String id);
}
