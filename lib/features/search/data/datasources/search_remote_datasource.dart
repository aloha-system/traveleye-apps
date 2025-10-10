import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchRemoteDatasource {
  final String baseUrl;
  final String apiKey;

  SearchRemoteDatasource({
    required this.baseUrl,
    required this.apiKey,
  });

  Future<List<Map<String, dynamic>>> searchRaw({
    required String keyword,
    required bool popularOnly,
    required bool nearbyOnly,
    required int? maxBudget,
  }) async {
    final uri = Uri.parse(baseUrl);

    // Build query params
    final queryParams = <String, String>{};

    if (keyword.trim().isNotEmpty) {
      // ilike di supabase (case insensitive LIKE)
      queryParams['name'] = 'ilike.%$keyword%';
    }
    if (popularOnly) {
      queryParams['rating'] = 'gte.4.7';
    }
    if (maxBudget != null) {
      queryParams['min_price'] = 'lte.$maxBudget';
    }

    final url = uri.replace(queryParameters: queryParams);

    final res = await http.get(
      url,
      headers: {
        'apikey': apiKey,
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Supabase error: ${res.statusCode} ${res.body}');
    }

    final List data = jsonDecode(res.body) as List;
    return data.cast<Map<String, dynamic>>();
  }
}
