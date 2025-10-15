import 'package:boole_apps/features/translate/domain/repositories/translation_repository.dart';

class TranslateTextUsecase {
  final TranslationRepository repository;

  const TranslateTextUsecase(this.repository);

  Future<String> call(String text, String from, String to) async {
    return repository.translateText(text, from, to);
  }
}
