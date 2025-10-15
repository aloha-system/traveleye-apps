import 'package:boole_apps/features/culture/data/models/common_model.dart';
import 'package:boole_apps/features/culture/domain/entities/greeting_phrases_entity.dart';

class GreetingPhrasesModel extends GreetingPhrases {
  GreetingPhrasesModel({required super.common, required super.formal});

  factory GreetingPhrasesModel.fromJson(Map<String, dynamic> json) {
    return GreetingPhrasesModel(
      common: (json['common'] is List)
          ? (json['common'] as List)
                .map((e) => CommonModel.fromJson(e))
                .toList()
          : [],
      formal: (json['formal'] is List)
          ? (json['formal'] as List)
                .map((e) => CommonModel.fromJson(e))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'common': common.map((e) {
      if (e is CommonModel) return e.toJson();
      return CommonModel(phrase: e.phrase, translation: e.translation).toJson();
    }).toList(),
    'formal': formal.map((e) {
      if (e is CommonModel) return e.toJson();
      return CommonModel(phrase: e.phrase, translation: e.translation).toJson();
    }).toList(),
  };

  factory GreetingPhrasesModel.fromEntity(GreetingPhrases entity) =>
      GreetingPhrasesModel(common: entity.common, formal: entity.formal);

  GreetingPhrases toEntity() => GreetingPhrases(common: common, formal: formal);
}
