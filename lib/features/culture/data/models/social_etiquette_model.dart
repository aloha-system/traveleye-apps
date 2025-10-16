import 'package:boole_apps/features/culture/domain/entities/social_etiquette_entity.dart';

class SocialEtiquetteModel extends SocialEtiquette {
  SocialEtiquetteModel({required super.family, required super.greetings});

  factory SocialEtiquetteModel.fromJson(Map<String, dynamic> json) =>
      SocialEtiquetteModel(
        family: json["family"]?.toString() ?? '',
        greetings: json["greetings"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {"family": family, "greetings": greetings};

  factory SocialEtiquetteModel.fromEntity(SocialEtiquette entity) =>
      SocialEtiquetteModel(family: entity.family, greetings: entity.greetings);

  SocialEtiquette toEntity() =>
      SocialEtiquette(family: family, greetings: greetings);
}
