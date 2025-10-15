import 'package:boole_apps/features/translate/domain/entities/translation_entity.dart';

class TranslationModel extends TranslationEntity {
  const TranslationModel({
    required super.originalText,
    required super.translatedText,
    required super.sourceLanguage,
    required super.targetLanguage,
    required super.timestamp,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      originalText: json['originalText'] ?? '',
      translatedText: json['translatedText'] ?? '',
      sourceLanguage: json['sourceLanguage'] ?? '',
      targetLanguage: json['targetLanguage'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalText': originalText,
      'translatedText': translatedText,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
