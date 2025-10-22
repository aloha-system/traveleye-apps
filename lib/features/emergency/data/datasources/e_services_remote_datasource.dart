import 'dart:convert';
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

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => EmergencyServiceModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load services: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
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

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => EmergencyServiceModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load services by category: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch services by category: $e');
    }
  }

  @override
  Future<List<EmergencyServiceModel>> searchServices(String query) async {
    try {
      // Using RPC function for search
      final response = await client.post(
        Uri.parse('$baseUrl/rpc/search_emergency_services'),
        headers: _headers,
        body: json.encode({'search_term': query}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => EmergencyServiceModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to search services: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search services: $e');
    }
  }

  @override
  Future<List<EmergencyServiceModel>> getPriorityServices() async {
    try {
      // Using RPC function
      final response = await client.post(
        Uri.parse('$baseUrl/rpc/get_priority_services'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => EmergencyServiceModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load priority services: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch priority services: $e');
    }
  }

  @override
  Future<EmergencyServiceModel?> getServiceById(String id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/v_emergency_services_full?id=eq.$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return EmergencyServiceModel.fromJson(data.first);
        }
        return null;
      } else {
        throw Exception('Failed to load service by id: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch service by id: $e');
    }
  }
}
