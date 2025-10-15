import 'package:boole_apps/features/culture/domain/entities/culinary_customs_entity.dart';

class CulinaryCustomsModel extends CulinaryCustoms {
  CulinaryCustomsModel({required super.dishes, required super.flavors});

  factory CulinaryCustomsModel.fromJson(Map<String, dynamic> json) =>
      CulinaryCustomsModel(
        dishes: (json["dishes"] is List)
            ? List<String>.from(json["dishes"].map((x) => x.toString()))
            : [],
        flavors: json["flavors"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
    "dishes": List<dynamic>.from(dishes.map((x) => x)),
    "flavors": flavors,
  };

  factory CulinaryCustomsModel.fromEntity(CulinaryCustoms entity) =>
      CulinaryCustomsModel(dishes: entity.dishes, flavors: entity.flavors);

  CulinaryCustoms toEntity() =>
      CulinaryCustoms(dishes: dishes, flavors: flavors);
}
