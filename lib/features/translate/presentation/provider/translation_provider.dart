import 'package:boole_apps/features/translate/domain/usecases/translate_text_usecase.dart';
import 'package:boole_apps/features/translate/domain/usecases/speech_to_text_usecase.dart';
import 'package:boole_apps/features/translate/domain/usecases/text_to_speech_usecase.dart';
import 'package:boole_apps/features/translate/presentation/provider/translation_state.dart';
import 'package:flutter/material.dart';

class TranslationProvider extends ChangeNotifier {
  final TranslateTextUsecase translateTextUsecase;
  final SpeechToTextUsecase speechToTextUsecase;
  final TextToSpeechUsecase textToSpeechUsecase;

  TranslationProvider({
    required this.translateTextUsecase,
    required this.speechToTextUsecase,
    required this.textToSpeechUsecase,
  });

  TranslationState _state = TranslationState();
  TranslationState get state => _state;

  // Translate text
  Future<void> translateText(String text) async {
    if (text.isEmpty) return;

    _state = _state.copyWith(
      status: TranslationStatus.loading,
      originalText: text,
    );
    notifyListeners();

    try {
      final translatedText = await translateTextUsecase.call(
        text,
        _state.sourceLanguage,
        _state.targetLanguage,
      );

      _state = _state.copyWith(
        status: TranslationStatus.success,
        translatedText: translatedText,
        message: null,
      );
    } catch (e) {
      _state = _state.copyWith(
        status: TranslationStatus.error,
        message: e.toString(),
      );
    } finally {
      notifyListeners();
    }
  }

  // Speech to text
  Future<void> startListening() async {
    _state = _state.copyWith(
      status: TranslationStatus.loading,
      isListening: true,
    );
    notifyListeners();

    try {
      final recognizedText = await speechToTextUsecase.call(_state.sourceLanguage);
      
      if (recognizedText.isNotEmpty) {
        _state = _state.copyWith(
          originalText: recognizedText,
          status: TranslationStatus.success,
        );
        // Auto-translate after speech recognition
        await translateText(recognizedText);
      }
    } catch (e) {
      _state = _state.copyWith(
        status: TranslationStatus.error,
        message: e.toString(),
      );
    } finally {
      _state = _state.copyWith(isListening: false);
      notifyListeners();
    }
  }

  // Text to speech
  Future<void> speakText(String text, String language) async {
    _state = _state.copyWith(isSpeaking: true);
    notifyListeners();

    try {
      await textToSpeechUsecase.call(text, language);
    } catch (e) {
      _state = _state.copyWith(
        status: TranslationStatus.error,
        message: e.toString(),
      );
    } finally {
      _state = _state.copyWith(isSpeaking: false);
      notifyListeners();
    }
  }

  // Swap languages
  void swapLanguages() {
    final newSourceLanguage = _state.targetLanguage;
    final newTargetLanguage = _state.sourceLanguage;
    
    _state = _state.copyWith(
      sourceLanguage: newSourceLanguage,
      targetLanguage: newTargetLanguage,
      originalText: _state.translatedText,
      translatedText: _state.originalText,
    );
    notifyListeners();
  }

  // Set source language
  void setSourceLanguage(String language) {
    _state = _state.copyWith(sourceLanguage: language);
    notifyListeners();
  }

  // Set target language
  void setTargetLanguage(String language) {
    _state = _state.copyWith(targetLanguage: language);
    notifyListeners();
  }

  // Update original text without triggering translation
  void updateOriginalText(String text) {
    _state = _state.copyWith(originalText: text);
    notifyListeners();
  }

  // Get current original text (for controller sync)
  String get originalText => _state.originalText;

  // Clear translated text only
  void clearTranslatedText() {
    _state = _state.copyWith(
      translatedText: '',
      status: TranslationStatus.initial,
      message: null,
    );
    notifyListeners();
  }

  // Clear text
  void clearText() {
    _state = _state.copyWith(
      originalText: '',
      translatedText: '',
      status: TranslationStatus.initial,
      message: null,
    );
    notifyListeners();
  }
}
