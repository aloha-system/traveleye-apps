import 'package:boole_apps/features/emergency/domain/entities/emergency_service_entity.dart';
import 'package:boole_apps/features/emergency/domain/repositories/emergency_repository.dart';

class GetServicesByCategoryUsecase {
  final EmergencyRepository repository;

  GetServicesByCategoryUsecase(this.repository);

  Future<List<EmergencyServiceEntity>> call(String category) {
    return repository.getServicesByCategory(category);
  }
}
