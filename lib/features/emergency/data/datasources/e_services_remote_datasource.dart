import 'dart:convert';
import 'dart:io';
import 'package:boole_apps/features/emergency/data/models/emergency_service_model.dart';
import 'package:http/http.dart' as http;

abstract class EmergencyRemoteDatasource {
  Future<List<EmergencyServiceModel>> getAllServices();
  Future<List<EmergencyServiceModel>> getServicesByCategory(String category);
  Future<List<EmergencyServiceModel>> searchServices(String query);
  Future<List<EmergencyServiceModel>> getPriorityServices();
  Future<EmergencyServiceModel?> getServiceById(String id);
}

class EmergencyRemoteDatasourceImpl implements EmergencyRemoteDatasource {
  final String baseUrl;
  final String apiKey;
  final http.Client client;

  EmergencyRemoteDatasourceImpl({
    required this.baseUrl,
    required this.apiKey,
    http.Client? client,
  }) : client = client ?? http.Client();

  Map<String, String> get _headers => {
    'apikey': apiKey,
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  @override
  Future<List<EmergencyServiceModel>> getAllServices() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/v_emergency_services_full?order=priority'),
        headers: _headers,
      );

      switch (response.statusCode) {
        // ok
        case 200:
          final List<dynamic> data = json.decode(response.body);
          return data
              .map((json) => EmergencyServiceModel.fromJson(json))
              .toList();

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
          throw HttpException(
            'Failed to load Services: Unexpected status code: ${response.statusCode}',
          );
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

  @override
  Future<List<EmergencyServiceModel>> getServicesByCategory(
    String category,
  ) async {
    try {
      final response = await client.get(
        Uri.parse(
          '$baseUrl/v_emergency_services_full?category=eq.$category&order=priority',
        ),
        headers: _headers,
      );

      switch (response.statusCode) {
        // ok
        case 200:
          final List<dynamic> data = json.decode(response.body);
          return data
              .map((json) => EmergencyServiceModel.fromJson(json))
              .toList();
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
          throw HttpException(
            'Failed to load Service by Category: Unexpected status code: ${response.statusCode}',
          );
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

  @override
  Future<List<EmergencyServiceModel>> searchServices(String query) async {
    try {
      final encodedQuery = Uri.encodeQueryComponent('%$query%');

      final url = Uri.parse(
        '$baseUrl/emergency_services?name=ilike.$encodedQuery',
      );

      final response = await client.get(url, headers: _headers);

      switch (response.statusCode) {
        // ok
        case 200:
          final List<dynamic> data = json.decode(response.body);
          return data
              .map((json) => EmergencyServiceModel.fromJson(json))
              .toList();

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
          throw HttpException(
            'Failed to load Search Service: Unexpected status code ${response.statusCode}',
          );
      }
    } on SocketException {
      throw Exception('No Internet connection.');
    } on FormatException {
      throw Exception('Invalid response format (not a valid JSON).');
    } on HttpException catch (e) {
      throw Exception('HTTP error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<EmergencyServiceModel>> getPriorityServices() async {
    try {
      // Using RPC function
      final response = await client.get(
        Uri.parse('$baseUrl/emergency_services?priority=lt.5'),
        headers: _headers,
      );

      switch (response.statusCode) {
        // ok
        case 200:
          final List<dynamic> data = json.decode(response.body);
          return data
              .map((json) => EmergencyServiceModel.fromJson(json))
              .toList();

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
          throw HttpException(
            'Failed to load Priority Services: Unexpected status code ${response.statusCode}',
          );
      }
    } on SocketException {
      throw Exception('No Internet connection.');
    } on FormatException {
      throw Exception('Invalid response format (not a valid JSON).');
    } on HttpException catch (e) {
      throw Exception('HTTP error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<EmergencyServiceModel?> getServiceById(String id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/v_emergency_services_full?id=eq.$id'),
        headers: _headers,
      );

      switch (response.statusCode) {
        // ok
        case 200:
          final List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            return EmergencyServiceModel.fromJson(data.first);
          }
          return null;

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
          throw HttpException(
            'Failed to load Service By ID: Unexpected status code: ${response.statusCode}',
          );
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
