import 'package:boole_apps/features/culture/domain/entities/common_entity.dart';

class CommonModel extends Common {
  CommonModel({required super.phrase, required super.translation});

  factory CommonModel.fromJson(Map<String, dynamic> json) => CommonModel(
    phrase: json["phrase"]?.toString() ?? '',
    translation: json["translation"]?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    "phrase": phrase,
    "translation": translation,
  };

  factory CommonModel.fromEntity(Common entity) =>
      CommonModel(phrase: entity.phrase, translation: entity.translation);

  Common toEntity() => Common(phrase: phrase, translation: translation);
}
