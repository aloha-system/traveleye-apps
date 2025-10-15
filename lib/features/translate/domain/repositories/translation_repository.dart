import 'package:boole_apps/features/translate/domain/entities/translation_entity.dart';

abstract class TranslationRepository {
  Future<String> translateText(String text, String from, String to);
  Future<void> speakText(String text, String language);
  Future<String> speechToText(String language);
  Future<List<TranslationEntity>> getTranslationHistory();
  Future<void> saveTranslation(TranslationEntity translation);
}