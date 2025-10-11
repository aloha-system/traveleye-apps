import 'package:boole_apps/features/culture/data/models/culinary_customs_model.dart';
import 'package:boole_apps/features/culture/data/models/cultural_highlights_model.dart';
import 'package:boole_apps/features/culture/data/models/dress_code_model.dart';
import 'package:boole_apps/features/culture/data/models/festivals_model.dart';
import 'package:boole_apps/features/culture/data/models/greeting_phrases_model.dart';
import 'package:boole_apps/features/culture/data/models/religious_practices_model.dart';
import 'package:boole_apps/features/culture/data/models/social_etiquette_model.dart';
import 'package:boole_apps/features/culture/data/models/taboos_model.dart';
import 'package:boole_apps/features/culture/data/models/traditional_arts_model.dart';
import 'package:boole_apps/features/culture/domain/entities/culture_entity.dart';

class CultureModel extends Culture {
  CultureModel({
    required super.id,
    required super.province,
    required super.provinceCode,
    required super.region,
    required super.localLanguages,
    required super.primaryLanguage,
    required super.greetingPhrases,
    required super.dressCode,
    required super.socialEtiquette,
    required super.taboos,
    required super.religiousPractices,
    required super.culturalHighlights,
    required super.traditionalArts,
    required super.culinaryCustoms,
    required super.festivals,
    required super.description,
    required super.visitorTips,
    required super.createdAt,
  });

  /// Factory: buat model dari JSON
  factory CultureModel.fromJson(Map<String, dynamic> json) {
    return CultureModel(
      id: json["id"] ?? '',
      province: json["province"] ?? '',
      provinceCode: json["province_code"] ?? '',
      region: json["region"] ?? '',
      localLanguages: List<String>.from(json["local_languages"] ?? []),
      primaryLanguage: json["primary_language"] ?? '',
      greetingPhrases: GreetingPhrasesModel.fromJson(json["greeting_phrases"] ?? {}),
      dressCode: DressCodeModel.fromJson(json["dress_code"] ?? {}),
      socialEtiquette: SocialEtiquetteModel.fromJson(json["social_etiquette"] ?? {}),
      taboos: TaboosModel.fromJson(json["taboos"] ?? {}),
      religiousPractices: ReligiousPracticesModel.fromJson(json["religious_practices"] ?? {}),
      culturalHighlights: CulturalHighlightsModel.fromJson(json["cultural_highlights"] ?? {}),
      traditionalArts: TraditionalArtsModel.fromJson(json["traditional_arts"] ?? {}),
      culinaryCustoms: CulinaryCustomsModel.fromJson(json["culinary_customs"] ?? {}),
      festivals: FestivalsModel.fromJson(json["festivals"] ?? {}),
      description: json["description"] ?? '',
      visitorTips: List<String>.from(json["visitor_tips"] ?? []),
      createdAt: DateTime.tryParse(json["created_at"] ?? '') ?? DateTime.now(),
    );
  }

  /// Konversi model ke JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "province": province,
        "province_code": provinceCode,
        "region": region,
        "local_languages": localLanguages,
        "primary_language": primaryLanguage,
        "greeting_phrases": (greetingPhrases as GreetingPhrasesModel).toJson(),
        "dress_code": (dressCode as DressCodeModel).toJson(),
        "social_etiquette": (socialEtiquette as SocialEtiquetteModel).toJson(),
        "taboos": (taboos as TaboosModel).toJson(),
        "religious_practices": (religiousPractices as ReligiousPracticesModel).toJson(),
        "cultural_highlights": (culturalHighlights as CulturalHighlightsModel).toJson(),
        "traditional_arts": (traditionalArts as TraditionalArtsModel).toJson(),
        "culinary_customs": (culinaryCustoms as CulinaryCustomsModel).toJson(),
        "festivals": (festivals as FestivalsModel).toJson(),
        "description": description,
        "visitor_tips": visitorTips,
        "created_at": createdAt.toIso8601String(),
      };
}