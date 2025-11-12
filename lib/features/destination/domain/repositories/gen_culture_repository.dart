import 'package:boole_apps/features/destination/domain/entities/cultural_insight.dart';

abstract class GenCultureRepository {
  Future<CulturalInsight> generateCulturaInsight(String destinationCity);
}
