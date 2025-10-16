import 'package:boole_apps/features/culture/domain/entities/taboos_entity.dart';

class TaboosModel extends Taboos {
  TaboosModel({required super.food, required super.publicDisplay});

  factory TaboosModel.fromJson(Map<String, dynamic> json) => TaboosModel(
    food: json["food"]?.toString() ?? '',
    publicDisplay: json["public_display"]?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    "food": food,
    "public_display": publicDisplay,
  };

  factory TaboosModel.fromEntity(Taboos entity) =>
      TaboosModel(food: entity.food, publicDisplay: entity.publicDisplay);

  Taboos toEntity() => Taboos(food: food, publicDisplay: publicDisplay);
}
