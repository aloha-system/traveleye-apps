import 'package:boole_apps/features/culture/domain/entities/traditional_arts_entity.dart';

class TraditionalArtsModel extends TraditionalArts {
  TraditionalArtsModel({required super.dance, required super.crafts});

  factory TraditionalArtsModel.fromJson(Map<String, dynamic> json) =>
      TraditionalArtsModel(
        dance: (json["dance"] is List)
            ? List<String>.from(json["dance"].map((x) => x.toString()))
            : [],
        crafts: (json["crafts"] is List)
            ? List<String>.from(json["crafts"].map((x) => x.toString()))
            : [],
      );

  Map<String, dynamic> toJson() => {
    "dance": List<dynamic>.from(dance.map((x) => x)),
    "crafts": List<dynamic>.from(crafts.map((x) => x)),
  };

  factory TraditionalArtsModel.fromEntity(TraditionalArts entity) =>
      TraditionalArtsModel(dance: entity.crafts, crafts: entity.crafts);

  TraditionalArts toEntity() => TraditionalArts(dance: dance, crafts: crafts);
}
