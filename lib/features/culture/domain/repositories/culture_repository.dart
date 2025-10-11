import 'package:boole_apps/features/culture/domain/entities/culture_entity.dart';

abstract class CultureRepository {
  Future<List<Culture>> getCulture();
}
