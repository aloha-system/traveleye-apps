import 'package:boole_apps/features/culture/domain/entities/culture_entities/culture_entity.dart';

abstract class CultureRepository {
  Future<List<Culture>> getCulture();

  // get culture by id
  Future<Culture> getDetailCultureById(String id);
}
