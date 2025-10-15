import 'package:boole_apps/features/culture/domain/entities/cultural_highlights_entity.dart';

class CulturalHighlightsModel extends CulturalHighlights {
  CulturalHighlightsModel({required super.heritage, required super.landmarks});

  factory CulturalHighlightsModel.fromJson(Map<String, dynamic> json) =>
      CulturalHighlightsModel(
        heritage: json["heritage"]?.toString() ?? '',
        landmarks: (json["landmarks"] is List)
            ? List<String>.from(json["landmarks"].map((x) => x.toString()))
            : [],
      );

  Map<String, dynamic> toJson() => {
    "heritage": heritage,
    "landmarks": List<dynamic>.from(landmarks.map((x) => x)),
  };

  factory CulturalHighlightsModel.fromEntity(CulturalHighlights entity) =>
      CulturalHighlightsModel(
        heritage: entity.heritage,
        landmarks: entity.landmarks,
      );
  CulturalHighlights toEntity() =>
      CulturalHighlights(heritage: heritage, landmarks: landmarks);
}
