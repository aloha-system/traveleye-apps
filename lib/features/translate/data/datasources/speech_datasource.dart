import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechDatasource {
  final FlutterTts _flutterTts;
  final SpeechToText _speechToText;

  const SpeechDatasource(this._flutterTts, this._speechToText);

  // Check and request microphone permission
  Future<bool> _checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied) {
      final result = await Permission.microphone.request();
      return result.isGranted;
    }
    
    if (status.isPermanentlyDenied) {
      return false;
    }
    
    return false;
  }

  Future<void> speakText(String text, String language) async {
    try {
      await _flutterTts.setLanguage(_getLanguageCode(language));
      await _flutterTts.speak(text);
    } catch (e) {
      throw Exception('Text-to-speech failed: $e');
    }
  }

  Future<String> speechToText(String language) async {
    try {
      // Check microphone permission first
      final hasPermission = await _checkMicrophonePermission();
      if (!hasPermission) {
        throw Exception('Microphone permission denied. Please enable microphone access in settings.');
      }

      // Initialize speech recognition
      bool available = await _speechToText.initialize();
      if (!available) {
        throw Exception('Speech recognition not available on this device');
      }

      // Check available locales and find best match
      final locales = await _speechToText.locales();
      final targetLocale = _getLanguageCode(language);
      
      if (locales.isEmpty) {
        throw Exception('No speech recognition locales available on this device');
      }
      
      // Find exact match first
      var selectedLocale = locales.where(
        (locale) => locale.localeId == targetLocale,
      ).firstOrNull;
      
      if (selectedLocale == null) {
        final languageCode = targetLocale.split('_')[0];
        selectedLocale = locales.where(
          (locale) => locale.localeId.startsWith(languageCode),
        ).firstOrNull;
      }
      
      selectedLocale ??= locales.first;

      String recognizedText = '';
      
      await _speechToText.listen(
        onResult: (result) {
          recognizedText = result.recognizedWords;
        },
        localeId: selectedLocale.localeId,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        onSoundLevelChange: (level) {
        },
      );

      // Wait for speech recognition to complete
      while (_speechToText.isListening) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Stop listening if still active
      if (_speechToText.isListening) {
        await _speechToText.stop();
      }

      if (recognizedText.isEmpty) {
        throw Exception('No speech detected. Please try speaking again.');
      }

      return recognizedText;
    } catch (e) {
      // Stop listening if there's an error
      if (_speechToText.isListening) {
        await _speechToText.stop();
      }
      throw Exception('Speech-to-text failed: $e');
    }
  }

  String _getLanguageCode(String language) {
    switch (language.toLowerCase()) {
      case 'indonesian':
      case 'id':
        return 'id_ID';
      case 'english':
      case 'en':
        return 'en_US';
      default:
        return 'en_US'; // Default to English
    }
  }

  // Get list of supported locales for debugging
  Future<List<String>> getSupportedLocales() async {
    try {
      bool available = await _speechToText.initialize();
      if (!available) {
        return [];
      }
      
      final locales = await _speechToText.locales();
      return locales.map((locale) => locale.localeId).toList();
    } catch (e) {
      return [];
    }
  }

  // Test speech recognition availability
  Future<bool> isSpeechRecognitionAvailable() async {
    try {
      return await _speechToText.initialize();
    } catch (e) {
      return false;
    }
  }
}
