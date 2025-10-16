import 'package:boole_apps/features/culture/data/datasource/culture_remote_datasource.dart';
import 'package:boole_apps/features/culture/domain/entities/culture_entity.dart';
import 'package:boole_apps/features/culture/domain/repositories/culture_repository.dart';

class CultureRepositoryImp implements CultureRepository {
  final CultureRemoteDatasource remoteDatasource;

  const CultureRepositoryImp(this.remoteDatasource);

  @override
  Future<List<Culture>> getCulture() async {
    try {
      final models = await remoteDatasource.fetchCultures();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to fetch culture data: $e');
    }
  }
}
