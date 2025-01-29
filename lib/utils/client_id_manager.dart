import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class ClientIdManager {
  static const String _clientIdKey = "client_id";
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static final Uuid _uuid = Uuid();

  /// Get the stored clientId or generate a new one if not exists
  static Future<String> getClientId() async {
    String? clientId = await _storage.read(key: _clientIdKey);
    
    if (clientId == null) {
      clientId = _uuid.v4(); // Generate a new UUID
      await _storage.write(key: _clientIdKey, value: clientId);
    }

    return clientId;
  }
}
