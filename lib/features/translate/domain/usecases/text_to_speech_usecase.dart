import 'package:boole_apps/features/translate/domain/repositories/translation_repository.dart';

class TextToSpeechUsecase {
  final TranslationRepository repository;

  const TextToSpeechUsecase(this.repository);

  Future<void> call(String text, String language) async {
    return repository.speakText(text, language);
  }
}
