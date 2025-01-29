import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HmacUtils {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _secretKeyStorageKey = "plextonwins";

  /// Save the secret key securely (should be fetched from the server)
  static Future<void> saveSecretKey(String secretKey) async {
    await _storage.write(key: _secretKeyStorageKey, value: secretKey);
  }

  /// Retrieve the secret key
  static Future<String?> getSecretKey() async {
    return await _storage.read(key: _secretKeyStorageKey);
  }

  /// Generate HMAC signature
  static Future<String> generateHmac(String clientId, String timestamp) async {
    // String? secretKey = await getSecretKey();
    String? secretKey = "plextonwins";
    // if (secretKey == null) {
    //   throw Exception("Secret key not found! Fetch from server.");
    // }

    var key = utf8.encode(secretKey);
    var message = utf8.encode('$clientId:$timestamp');

    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(message);

    return digest.toString();
  }
}
