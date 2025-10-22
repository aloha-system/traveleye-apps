import 'package:boole_apps/features/emergency/domain/entities/emergency_service_entity.dart';
import 'package:boole_apps/features/emergency/domain/repositories/emergency_repository.dart';

class GetAllServicesUsecase {
  final EmergencyRepository repository;

  GetAllServicesUsecase(this.repository);

  Future<List<EmergencyServiceEntity>> call() {
    return repository.getAllServices();
  }
}
