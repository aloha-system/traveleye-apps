import 'package:boole_apps/features/culture/domain/entities/culture_entity.dart';
import 'package:boole_apps/features/culture/domain/repositories/culture_repository.dart';

class GetCultureUsecase {
  final CultureRepository repository;

  const GetCultureUsecase(this.repository);

  Future<List<Culture>> call() async {
    return await repository.getCulture();
  }
}