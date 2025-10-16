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
    required super.imageUrl,
  });

  /// Factory: buat model dari JSON
  factory CultureModel.fromJson(Map<String, dynamic> json) {
    return CultureModel(
      id: json["id"]?.toString() ?? '', // pastikan dikonversi ke string
      province: json["province"]?.toString() ?? '',
      provinceCode: json["province_code"]?.toString() ?? '',
      region: json["region"]?.toString() ?? '',
      localLanguages: (json["local_languages"] is List)
          ? List<String>.from(json["local_languages"])
          : <String>[],
      primaryLanguage: json["primary_language"]?.toString() ?? '',

      greetingPhrases: GreetingPhrasesModel.fromJson(
        (json["greeting_phrases"] is Map)
            ? json["greeting_phrases"]
            : <String, dynamic>{},
      ),
      dressCode: DressCodeModel.fromJson(
        (json["dress_code"] is Map) ? json["dress_code"] : <String, dynamic>{},
      ),
      socialEtiquette: SocialEtiquetteModel.fromJson(
        (json["social_etiquette"] is Map)
            ? json["social_etiquette"]
            : <String, dynamic>{},
      ),
      taboos: TaboosModel.fromJson(
        (json["taboos"] is Map) ? json["taboos"] : <String, dynamic>{},
      ),
      religiousPractices: ReligiousPracticesModel.fromJson(
        (json["religious_practices"] is Map)
            ? json["religious_practices"]
            : <String, dynamic>{},
      ),
      culturalHighlights: CulturalHighlightsModel.fromJson(
        (json["cultural_highlights"] is Map)
            ? json["cultural_highlights"]
            : <String, dynamic>{},
      ),
      traditionalArts: TraditionalArtsModel.fromJson(
        (json["traditional_arts"] is Map)
            ? json["traditional_arts"]
            : <String, dynamic>{},
      ),
      culinaryCustoms: CulinaryCustomsModel.fromJson(
        (json["culinary_customs"] is Map)
            ? json["culinary_customs"]
            : <String, dynamic>{},
      ),
      festivals: FestivalsModel.fromJson(
        (json["festivals"] is Map) ? json["festivals"] : <String, dynamic>{},
      ),

      description: json["description"]?.toString() ?? '',
      visitorTips: (json["visitor_tips"] is List)
          ? List<String>.from(json["visitor_tips"])
          : <String>[],
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"].toString()) ?? DateTime.now()
          : DateTime.now(),
      imageUrl: (json["image_urls"] is List)
          ? List<String>.from(json['image_urls'])
          : <String>[],
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
    "religious_practices": (religiousPractices as ReligiousPracticesModel)
        .toJson(),
    "cultural_highlights": (culturalHighlights as CulturalHighlightsModel)
        .toJson(),
    "traditional_arts": (traditionalArts as TraditionalArtsModel).toJson(),
    "culinary_customs": (culinaryCustoms as CulinaryCustomsModel).toJson(),
    "festivals": (festivals as FestivalsModel).toJson(),
    "description": description,
    "visitor_tips": visitorTips,
    "created_at": createdAt.toIso8601String(),
    "image_urls": imageUrl,
  };

  Culture toEntity() {
    return Culture(
      id: id,
      province: province,
      provinceCode: provinceCode,
      region: region,
      localLanguages: localLanguages,
      primaryLanguage: primaryLanguage,
      greetingPhrases: greetingPhrases,
      dressCode: dressCode,
      socialEtiquette: socialEtiquette,
      taboos: taboos,
      religiousPractices: religiousPractices,
      culturalHighlights: culturalHighlights,
      traditionalArts: traditionalArts,
      culinaryCustoms: culinaryCustoms,
      festivals: festivals,
      description: description,
      visitorTips: visitorTips,
      createdAt: createdAt,
      imageUrl: imageUrl,
    );
  }
}
