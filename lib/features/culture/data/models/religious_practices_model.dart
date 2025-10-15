import 'package:boole_apps/features/culture/domain/entities/religious_practices_entity.dart';

class ReligiousPracticesModel extends ReligiousPractices {
  ReligiousPracticesModel({
    required super.practices,
    required super.predominantReligion,
  });

  factory ReligiousPracticesModel.fromJson(Map<String, dynamic> json) =>
      ReligiousPracticesModel(
        practices: json["practices"]?.toString() ?? '',
        predominantReligion: json["predominant_religion"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
    "practices": practices,
    "predominant_religion": predominantReligion,
  };

  factory ReligiousPracticesModel.fromEntity(ReligiousPractices entity) =>
      ReligiousPracticesModel(
        practices: entity.practices,
        predominantReligion: entity.predominantReligion,
      );

  ReligiousPractices toEntity() => ReligiousPractices(
    practices: practices,
    predominantReligion: predominantReligion,
  );
}
