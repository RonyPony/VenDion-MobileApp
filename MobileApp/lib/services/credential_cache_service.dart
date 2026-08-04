import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vendion/models/client_user.dart';

class CredentialCacheService {
  CredentialCacheService({
    FlutterSecureStorage? storage,
    Duration? ttl,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _ttl = ttl ?? const Duration(days: 3);

  static const _cacheKey = 'cached_login_credentials';

  final FlutterSecureStorage _storage;
  final Duration _ttl;

  Future<void> save(ClientUser user) async {
    final email = user.email;
    final password = user.password;

    if (email == null ||
        email.trim().isEmpty ||
        password == null ||
        password.isEmpty) {
      return;
    }

    final payload = {
      'email': email,
      'password': password,
      'savedAt': DateTime.now().toUtc().toIso8601String(),
    };

    await _storage.write(key: _cacheKey, value: jsonEncode(payload));
  }

  Future<ClientUser?> readValid() async {
    try {
      final raw = await _storage.read(key: _cacheKey);
      if (raw == null || raw.isEmpty) {
        return null;
      }

      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final savedAt = DateTime.tryParse(decoded['savedAt']?.toString() ?? '');

      if (savedAt == null ||
          DateTime.now().toUtc().difference(savedAt) >= _ttl) {
        await clear();
        return null;
      }

      final email = decoded['email']?.toString();
      final password = decoded['password']?.toString();
      if (email == null || password == null) {
        await clear();
        return null;
      }

      return ClientUser(email: email, password: password);
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> clear() => _storage.delete(key: _cacheKey);
}
