import 'package:boole_apps/features/translate/data/datasources/translation_remote_datasource.dart';
import 'package:boole_apps/features/translate/data/datasources/translation_local_datasource.dart';
import 'package:boole_apps/features/translate/data/datasources/speech_datasource.dart';
import 'package:boole_apps/features/translate/data/models/translation_model.dart';
import 'package:boole_apps/features/translate/domain/entities/translation_entity.dart';
import 'package:boole_apps/features/translate/domain/repositories/translation_repository.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  final TranslationRemoteDatasource remoteDatasource;
  final TranslationLocalDatasource localDatasource;
  final SpeechDatasource speechDatasource;

  const TranslationRepositoryImpl(
    this.remoteDatasource,
    this.localDatasource,
    this.speechDatasource,
  );

  @override
  Future<String> translateText(String text, String from, String to) async {
    final translatedText = await remoteDatasource.translateText(text, from, to);
    
    // Save to history
    final translation = TranslationModel(
      originalText: text,
      translatedText: translatedText,
      sourceLanguage: from,
      targetLanguage: to,
      timestamp: DateTime.now(),
    );
    await localDatasource.saveTranslation(translation);
    
    return translatedText;
  }

  @override
  Future<void> speakText(String text, String language) async {
    return speechDatasource.speakText(text, language);
  }

  @override
  Future<String> speechToText(String language) async {
    return speechDatasource.speechToText(language);
  }

  @override
  Future<List<TranslationEntity>> getTranslationHistory() async {
    return localDatasource.getTranslationHistory();
  }

  @override
  Future<void> saveTranslation(TranslationEntity translation) async {
    final model = TranslationModel(
      originalText: translation.originalText,
      translatedText: translation.translatedText,
      sourceLanguage: translation.sourceLanguage,
      targetLanguage: translation.targetLanguage,
      timestamp: translation.timestamp,
    );
    return localDatasource.saveTranslation(model);
  }
}
