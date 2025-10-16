import 'dart:convert';
import 'dart:io';
import 'package:boole_apps/features/culture/data/models/culture_model.dart';
import 'package:http/http.dart' as http;

class CultureRemoteDatasource {
  final String baseUrl;
  final String apiKey;

  CultureRemoteDatasource({required this.baseUrl, required this.apiKey});

  Future<List<CultureModel>> fetchCultures() async {
    try {
      final uri = Uri.parse(baseUrl);

      final response = await http.get(
        uri,
        headers: {
          'apikey': apiKey,
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      switch (response.statusCode) {
        // ok
        case 200:
          final List<dynamic> jsonList = jsonDecode(response.body);

          final List<CultureModel> cultures = jsonList
              .map((json) => CultureModel.fromJson(json))
              .toList();
          return cultures;

        // bad request
        case 400:
          throw HttpException(
            'Bad Request (400): Invalid request sent to server.',
          );

        // unauthorized
        case 401:
          throw HttpException('Unauthorized (401): Invalid API key or token.');

        // not found
        case 404:
          throw HttpException('Not Found (404): Resource not found.');

        // server error
        case 500:
          throw HttpException('Server Error (500): Internal server error.');

        // default
        default:
          throw HttpException('Unexpected status code: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet connection.');
    } on FormatException {
      throw Exception('Invalid response format (not a valid JSON).');
    } on HttpException catch (e) {
      throw Exception('HTTP error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e.');
    }
  }
}
