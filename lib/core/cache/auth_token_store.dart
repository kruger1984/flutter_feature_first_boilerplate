import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the bearer token. Used by [DioFactory] and auth repository.
abstract class AuthTokenStore {
  Future<String?> readToken();

  Future<void> saveToken(String token);

  Future<void> clearToken();
}

/// Production store backed by [FlutterSecureStorage].
class SecureAuthTokenStore implements AuthTokenStore {
  SecureAuthTokenStore({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _key = 'auth_token';

  @override
  Future<void> clearToken() => _storage.delete(key: _key);

  @override
  Future<String?> readToken() => _storage.read(key: _key);

  @override
  Future<void> saveToken(String token) => _storage.write(key: _key, value: token);
}
