import 'package:boole_apps/features/emergency/data/models/emergency_number_model.dart';
import 'package:boole_apps/features/emergency/domain/entities/emergency_service_entity.dart';

class EmergencyServiceModel extends EmergencyServiceEntity {
  const EmergencyServiceModel({
    required super.id,
    required super.name,
    required super.category,
    super.description,
    required super.coverageLevel,
    super.coverageName,
    super.latitude,
    super.longitude,
    required super.languages,
    super.contactHours,
    required super.priority,
    super.verifiedAt,
    required super.sourceName,
    super.sourceUrl,
    required super.numbers,
    required super.tags,
  });

  factory EmergencyServiceModel.fromJson(Map<String, dynamic> json) {
    return EmergencyServiceModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      coverageLevel: json['coverage_level'],
      coverageName: json['coverage_name'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      languages: List<String>.from(json['languages'] ?? ['id']),
      contactHours: json['contact_hours'],
      priority: json['priority'],
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'])
          : null,
      sourceName: json['source_name'],
      sourceUrl: json['source_url'],
      numbers:
          (json['numbers'] as List?)
              ?.map((e) => EmergencyNumberModel.fromJson(e))
              .toList() ??
          [],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'coverage_level': coverageLevel,
      'coverage_name': coverageName,
      'latitude': latitude,
      'longitude': longitude,
      'languages': languages,
      'contact_hours': contactHours,
      'priority': priority,
      'verified_at': verifiedAt?.toIso8601String(),
      'source_name': sourceName,
      'source_url': sourceUrl,
      'numbers': numbers
          .map((e) => (e as EmergencyNumberModel).toJson())
          .toList(),
      'tags': tags,
    };
  }
}
