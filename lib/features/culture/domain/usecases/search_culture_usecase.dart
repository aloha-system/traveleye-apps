import 'package:boole_apps/features/culture/domain/entities/culture_entities/culture_entity.dart';
import 'package:boole_apps/features/culture/domain/repositories/culture_repository.dart';

class SearchCultureUsecase {
  final CultureRepository repository;

  const SearchCultureUsecase(this.repository);

  Future<List<Culture>> call(String query) async {
    return await repository.searchCulture(query);
  }
}
