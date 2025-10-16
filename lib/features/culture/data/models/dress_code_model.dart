import 'package:boole_apps/features/culture/domain/entities/dress_code_entity.dart';

class DressCodeModel extends DressCode {
  DressCodeModel({required super.men, required super.women});

  factory DressCodeModel.fromJson(Map<String, dynamic> json) => DressCodeModel(
    men: json["men"]?.toString() ?? '',
    women: json["women"]?.toString() ?? '',
  );
  Map<String, dynamic> toJson() => {"men": men, "women": women};

  factory DressCodeModel.fromEntity(DressCode entity) =>
      DressCodeModel(men: entity.men, women: entity.women);

  DressCode toEntity() => DressCode(men: men, women: women);
}
