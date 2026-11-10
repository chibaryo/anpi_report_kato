import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AppApiClient {
  AppApiClient({
    http.Client? httpClient,
    this.bearerToken,
  }) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  String? bearerToken;

  Uri _uri(String path, [Map<String, String>? query]) {
    final base = dotenv.get('APISRV_BASEURL');
    return Uri.parse(base).replace(path: path, queryParameters: query);
  }

  Map<String, String> _headers({bool auth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (auth && bearerToken != null && bearerToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $bearerToken';
    }
    return headers;
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? query,
    bool auth = true,
  }) async {
    final response = await _httpClient.get(
      _uri(path, query),
      headers: _headers(auth: auth),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final response = await _httpClient.post(
      _uri(path),
      headers: _headers(auth: auth),
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> patchJson(
    String path,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final response = await _httpClient.patch(
      _uri(path),
      headers: _headers(auth: auth),
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> deleteJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await _httpClient.delete(
      _uri(path),
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Map<String, dynamic> _decode(http.Response response) {
    // Dart http defaults to latin1 when charset is missing, which garbles Japanese UTF-8.
    final bodyText =
        response.bodyBytes.isEmpty ? '' : utf8.decode(response.bodyBytes);
    final decoded =
        bodyText.isEmpty ? <String, dynamic>{} : jsonDecode(bodyText);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map && decoded['error'] != null
          ? decoded['error'].toString()
          : 'API error ${response.statusCode}';
      throw Exception(message);
    }
    if (decoded is Map) {
      return _repairJsonMap(decoded);
    }
    return {'data': _repairMojibake(decoded)};
  }

  static Map<String, dynamic> _repairJsonMap(Map<dynamic, dynamic> value) {
    return <String, dynamic>{
      for (final entry in value.entries)
        entry.key.toString(): _repairMojibake(entry.value),
    };
  }

  /// Dart http may latin1-decode UTF-8. Repair those strings after JSON parse.
  static dynamic _repairMojibake(dynamic value) {
    if (value is String) {
      if (value.isEmpty ||
          value.codeUnits.any((code) => code > 0xFF) ||
          !value.codeUnits.any((code) => code >= 0x80)) {
        return value;
      }
      try {
        return utf8.decode(latin1.encode(value));
      } catch (_) {
        return value;
      }
    }
    if (value is List) {
      return value.map(_repairMojibake).toList();
    }
    if (value is Map) {
      return _repairJsonMap(value);
    }
    return value;
  }
}
