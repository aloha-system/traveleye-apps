import 'package:translator/translator.dart';

class TranslationRemoteDatasource {
  final GoogleTranslator _googleTranslator;

  const TranslationRemoteDatasource(this._googleTranslator);

  Future<String> translateText(String text, String from, String to) async {
    try {
      final result = await _googleTranslator.translate(
        text,
        from: from,
        to: to,
      );
      return result.text;
    } catch (e) {
      throw Exception('Translation failed: $e');
    }
  }
}
