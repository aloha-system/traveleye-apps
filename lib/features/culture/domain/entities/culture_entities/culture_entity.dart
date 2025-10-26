import 'package:boole_apps/features/culture/domain/entities/culture_entities/culinary_customs_entity.dart';
import 'package:boole_apps/features/culture/domain/entities/culture_entities/cultural_highlights_entity.dart';
import 'package:boole_apps/features/culture/domain/entities/culture_entities/dress_code_entity.dart';
import 'package:boole_apps/features/culture/domain/entities/culture_entities/festivals_entity.dart';
import 'package:boole_apps/features/culture/domain/entities/culture_entities/greeting_phrases_entity.dart';
import 'package:boole_apps/features/culture/domain/entities/culture_entities/religious_practices_entity.dart';
import 'package:boole_apps/features/culture/domain/entities/culture_entities/social_etiquette_entity.dart';
import 'package:boole_apps/features/culture/domain/entities/culture_entities/taboos_entity.dart';
import 'package:boole_apps/features/culture/domain/entities/culture_entities/traditional_arts_entity.dart';

class Culture {
  String id;
  String province;
  String provinceCode;
  String region;
  List<String> localLanguages;
  String primaryLanguage;
  GreetingPhrases greetingPhrases;
  DressCode dressCode;
  SocialEtiquette socialEtiquette;
  Taboos taboos;
  ReligiousPractices religiousPractices;
  CulturalHighlights culturalHighlights;
  TraditionalArts traditionalArts;
  CulinaryCustoms culinaryCustoms;
  Festivals festivals;
  String description;
  List<String> visitorTips;
  DateTime createdAt;
  List<String> imageUrl;

  Culture({
    required this.id,
    required this.province,
    required this.provinceCode,
    required this.region,
    required this.localLanguages,
    required this.primaryLanguage,
    required this.greetingPhrases,
    required this.dressCode,
    required this.socialEtiquette,
    required this.taboos,
    required this.religiousPractices,
    required this.culturalHighlights,
    required this.traditionalArts,
    required this.culinaryCustoms,
    required this.festivals,
    required this.description,
    required this.visitorTips,
    required this.createdAt,
    required this.imageUrl,
  });
}
