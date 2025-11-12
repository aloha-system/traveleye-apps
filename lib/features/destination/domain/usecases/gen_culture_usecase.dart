import 'package:boole_apps/features/destination/domain/repositories/gen_culture_repository.dart';
import 'package:boole_apps/features/destination/domain/entities/cultural_insight.dart';

class GenCultureUsecase {
  final GenCultureRepository repository;
  const GenCultureUsecase(this.repository);

  Future<CulturalInsight> call(String destinationCity) async {
    return repository.generateCulturaInsight(destinationCity);
  }
}
