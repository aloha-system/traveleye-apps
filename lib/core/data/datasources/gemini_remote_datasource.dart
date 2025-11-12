import 'package:google_generative_ai/google_generative_ai.dart';

abstract class GeminiRemoteDataSource {
  // adjust and add property based on feature requirement

  Future<GenerateContentResponse> generateCulture(String prompt);
}

class GeminiRemoteDataSourceImpl implements GeminiRemoteDataSource {
  final GenerativeModel _model;

  GeminiRemoteDataSourceImpl(this._model);

  @override
  Future<GenerateContentResponse> generateCulture(String prompt) async {
    final response = await _model.generateContent([
      Content.text(prompt),
    ]);
    return response;
  }
}
