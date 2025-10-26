import 'package:boole_apps/features/emergency/domain/entities/emergency_number_entity.dart';

class EmergencyServiceEntity {
  final String id;
  final String name;
  final String category;
  final String? description;
  final String coverageLevel;
  final String? coverageName;
  final double? latitude;
  final double? longitude;
  final List<String> languages;
  final String? contactHours;
  final int priority;
  final DateTime? verifiedAt;
  final String sourceName;
  final String? sourceUrl;
  final List<EmergencyNumberEntity> numbers;
  final List<String> tags;

  const EmergencyServiceEntity({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    required this.coverageLevel,
    this.coverageName,
    this.latitude,
    this.longitude,
    required this.languages,
    this.contactHours,
    required this.priority,
    this.verifiedAt,
    required this.sourceName,
    this.sourceUrl,
    required this.numbers,
    required this.tags,
  });
}
