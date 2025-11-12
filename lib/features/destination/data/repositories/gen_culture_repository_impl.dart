import 'dart:convert';

import 'package:boole_apps/core/data/datasources/gemini_remote_datasource.dart';
import 'package:boole_apps/features/destination/domain/entities/cultural_insight.dart';
import 'package:boole_apps/features/destination/domain/repositories/gen_culture_repository.dart';

class GenCultureRepositoryImpl implements GenCultureRepository {
  final GeminiRemoteDataSource remote;
  GenCultureRepositoryImpl(this.remote);

  @override
  Future<CulturalInsight> generateCulturaInsight(String destinationCity) async {
    try {
      final prompt =
          '''
You are a travel indonesians culture assistant AI.
Generate a concise JSON object describing the local culture of the given destination.

Destination: {$destinationCity}

The JSON must strictly follow this structure:
{
  "destination": string,
  "overview": {
    "summary": string,
    "main_values": [string, string, string]
  },
  "cultural_highlights": [
    {"title": string, "description": string},
    {"title": string, "description": string}
  ],
  "visitor_guidelines": {
    "do": [string, string, string],
    "dont": [string, string, string]
  },
  "travel_tips": [string, string, string],
  "language_tips": [
    {"phrase": string, "meaning": string},
    {"phrase": string, "meaning": string},
    {"phrase": string, "meaning": string}
  ],
  "cultural_rating": {
    "tradition_depth": int (1–10),
    "tourist_friendliness": int (1–10),
    "spiritual_significance": int (1–10)
  }
}

Rules:
- Use clear and concise English (max 15–20 words per sentence).
- Each array must have **no more than the specified number of items**.
- Do not include markdown, comments, or explanations.
- Output only valid, minified JSON.
''';

      final response = await remote.generateCulture(prompt);

      final text = response.text?.trim();

      if (text == null || text.isEmpty) {
        throw Exception('Gemini response is empty');
      }

      final jsonStart = text.indexOf('{');
      final jsonEnd = text.lastIndexOf('}');
      if (jsonStart == -1 || jsonEnd == -1) {
        throw Exception('Gemini response does not contain valid JSON');
      }

      final jsonString = text.substring(jsonStart, jsonEnd + 1);
      final jsonData = jsonDecode(jsonString);

      final culturalInsightJson = jsonData['destination'];
      if (culturalInsightJson == null) {
        throw Exception('Insight data not found in Gemini response');
      }

      return CulturalInsight.fromJson(culturalInsightJson);
    } catch (e) {
      throw Exception('Failed to fetch insight from Gemini: $e');
    }
  }
}
