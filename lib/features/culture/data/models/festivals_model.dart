import 'package:boole_apps/features/culture/domain/entities/festivals_entity.dart';

class FestivalsModel extends Festivals {
  FestivalsModel({required super.major});

  factory FestivalsModel.fromJson(Map<String, dynamic> json) => FestivalsModel(
    major: (json["major"] is List)
        ? List<String>.from(json["major"].map((x) => x.toString()))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "major": List<dynamic>.from(major.map((x) => x)),
  };

  factory FestivalsModel.fromEntity(Festivals entity) =>
      FestivalsModel(major: entity.major);

  Festivals toEntity() => Festivals(major: major);
}
