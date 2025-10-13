import 'package:boole_apps/features/translate/domain/repositories/translation_repository.dart';

class SpeechToTextUsecase {
  final TranslationRepository repository;

  const SpeechToTextUsecase(this.repository);

  Future<String> call(String language) async {
    return repository.speechToText(language);
  }
}
