import 'package:boole_apps/features/culture/domain/entities/culture_entities/culture_entity.dart';
import 'package:boole_apps/features/culture/domain/repositories/culture_repository.dart';

class GetCultureByIdUsecase {
  final CultureRepository repository;

  const GetCultureByIdUsecase(this.repository);
  Future<Culture> call(String id) async {
    return await repository.getDetailCultureById(id);
  }
}
