import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechDatasource {
  final FlutterTts _flutterTts;
  final SpeechToText _speechToText;

  const SpeechDatasource(this._flutterTts, this._speechToText);

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
      bool available = await _speechToText.initialize();
      if (!available) {
        throw Exception('Speech recognition not available');
      }

      String recognizedText = '';
      
      await _speechToText.listen(
        onResult: (result) {
          recognizedText = result.recognizedWords;
        },
        localeId: _getLanguageCode(language),
      );

      while (_speechToText.isListening) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      return recognizedText;
    } catch (e) {
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
        return 'en_US';
    }
  }
}
