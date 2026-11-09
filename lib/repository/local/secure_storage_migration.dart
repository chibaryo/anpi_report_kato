import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _migrationFlagKey = 'secure_storage_password_stripped_v1';

class SecureStorageMigration {
  SecureStorageMigration({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// One-time migration: remove plaintext passwords from Secure Storage history.
  Future<void> stripPasswordsIfNeeded() async {
    final done = await _storage.read(key: _migrationFlagKey);
    if (done == '1') {
      return;
    }

    final raw = await _storage.read(key: 'userHistory');
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        final cleaned = decoded.whereType<Map>().map((item) {
          final map = Map<String, dynamic>.from(item);
          map.remove('password');
          return map;
        }).toList();
        await _storage.write(key: 'userHistory', value: jsonEncode(cleaned));
      }
    }

    await _storage.write(key: _migrationFlagKey, value: '1');
  }
}
