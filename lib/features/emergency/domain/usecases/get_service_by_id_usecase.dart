import 'package:boole_apps/features/emergency/domain/entities/emergency_service_entity.dart';
import 'package:boole_apps/features/emergency/domain/repositories/emergency_repository.dart';

class GetServiceByIdUsecase {
  final EmergencyRepository repository;

  GetServiceByIdUsecase(this.repository);

  Future<EmergencyServiceEntity?> call(String id) {
    return repository.getServiceById(id);
  }
}
