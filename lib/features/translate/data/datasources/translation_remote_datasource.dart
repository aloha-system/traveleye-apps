import 'package:google_translate/google_translate.dart';

class TranslationRemoteDatasource {
  final GoogleTranslate _googleTranslate;

  const TranslationRemoteDatasource(this._googleTranslate);

  Future<String> translateText(String text, String from, String to) async {
    try {
      final result = await _googleTranslate.translate(text, sourceLanguage: from, targetLanguage: to);
      return result;
    } catch (e) {
      throw Exception('Translation failed: $e');
    }
  }
}
