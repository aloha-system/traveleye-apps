import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boole_apps/features/translate/data/models/translation_model.dart';

class TranslationLocalDatasource {
  static const String _historyKey = 'translation_history';

  Future<List<TranslationModel>> getTranslationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_historyKey) ?? [];
    
    return historyJson
        .map((json) => TranslationModel.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveTranslation(TranslationModel translation) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getTranslationHistory();

    history.insert(0, translation);

    if (history.length > 50) {
      history.removeRange(50, history.length);
    }
    
    final historyJson = history
        .map((t) => jsonEncode(t.toJson()))
        .toList();
    
    await prefs.setStringList(_historyKey, historyJson);
  }
}
