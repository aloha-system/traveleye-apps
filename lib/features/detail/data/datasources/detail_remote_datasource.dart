import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/destination_detail_model.dart';

/// Kontrak datasource (tetap seperti skeleton sebelumnya)
abstract class DetailRemoteDatasource {
  Future<DestinationDetailModel> getById(String id);
}

class DetailRemoteDatasourceImpl implements DetailRemoteDatasource {
  final String baseUrl;
  final String apiKey;
  final http.Client _client;

  DetailRemoteDatasourceImpl({
    required this.baseUrl,
    required this.apiKey,
    http.Client? client,
  }) : _client = client ?? http.Client();

  @override
  Future<DestinationDetailModel> getById(String id) async {
    if (baseUrl.isEmpty) {
      throw Exception('DetailRemoteDatasource: baseUrl kosong');
    }
    if (apiKey.isEmpty) {
      throw Exception('DetailRemoteDatasource: apiKey kosong');
    }
    if (id.isEmpty) {
      throw Exception('DetailRemoteDatasource: id kosong');
    }

    final uri = Uri.parse(baseUrl).replace(queryParameters: <String, String>{
      'id': 'eq.$id',
      'select': '*',
      'limit': '1',
    });

    final res = await _client
        .get(
          uri,
          headers: {
            'apikey': apiKey,
            'Authorization': 'Bearer $apiKey',
            'Accept': 'application/json',
            'Prefer': 'count=exact',
          },
        )
        .timeout(const Duration(seconds: 20));

    if (res.statusCode != 200) {
      throw Exception(
        'Supabase detail error ${res.statusCode}: ${res.body}',
      );
    }

    // Supabase PostgREST mengembalikan array
    final decoded = jsonDecode(res.body);
    if (decoded is! List || decoded.isEmpty) {
      throw DetailNotFoundException(id);
    }

    final Map<String, dynamic> json =
        (decoded.first as Map).cast<String, dynamic>();

    return DestinationDetailModel.fromJson(json);
  }
}


class DetailNotFoundException implements Exception {
  final String id;
  DetailNotFoundException(this.id);

  @override
  String toString() => 'Destination detail tidak ditemukan (id=$id)';
}
