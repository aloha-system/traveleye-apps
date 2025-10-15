import 'package:boole_apps/features/translate/domain/entities/translation_entity.dart';

enum TranslationStatus { initial, loading, success, error }

class TranslationState {
  final TranslationStatus status;
  final String? message;
  final String originalText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  final bool isListening;
  final bool isSpeaking;
  final List<TranslationEntity> history;

  const TranslationState({
    this.status = TranslationStatus.initial,
    this.message,
    this.originalText = '',
    this.translatedText = '',
    this.sourceLanguage = 'en',
    this.targetLanguage = 'id',
    this.isListening = false,
    this.isSpeaking = false,
    this.history = const [],
  });

  bool get isLoading => status == TranslationStatus.loading;
  bool get isSuccess => status == TranslationStatus.success;
  bool get isError => status == TranslationStatus.error;

  TranslationState copyWith({
    TranslationStatus? status,
    String? message,
    String? originalText,
    String? translatedText,
    String? sourceLanguage,
    String? targetLanguage,
    bool? isListening,
    bool? isSpeaking,
    List<TranslationEntity>? history,
  }) {
    return TranslationState(
      status: status ?? this.status,
      message: message ?? this.message,
      originalText: originalText ?? this.originalText,
      translatedText: translatedText ?? this.translatedText,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      isListening: isListening ?? this.isListening,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      history: history ?? this.history,
    );
  }
}
