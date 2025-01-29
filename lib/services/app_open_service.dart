import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:todo/services/api_service.dart";

class AppOpenService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Get stored clientId or generate a new one
  static Future<String> getClientId() async {
    String? clientId = await _storage.read(key: "client_id");

    if (clientId == null) {
      clientId = DateTime.now().millisecondsSinceEpoch.toString(); // Temporary method
      await _storage.write(key: "client_id", value: clientId);
    }

    return clientId;
  }

  /// Get device type (Android/iOS)
  static Future<String> getDeviceType() async {
    if (Platform.isAndroid) {
      return "Android";
    } else if (Platform.isIOS) {
      return "iOS";
    } else {
      return "Unknown";
    }
  }

  /// Get User-Agent (Device Info)
  static Future<String> getUserAgent() async {
    final deviceInfo = DeviceInfoPlugin();
    String userAgent = "Unknown";

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      userAgent = "Android ${androidInfo.version.release} - ${androidInfo.model}";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      userAgent = "iOS ${iosInfo.systemVersion} - ${iosInfo.utsname.machine}";
    }

    return userAgent;
  }

  /// Log app open event
  static Future<void> logAppOpen() async {
    String clientId = await getClientId();
    String deviceType = await getDeviceType();
    String userAgent = await getUserAgent();

    final response = await http.post(
      Uri.parse("$baseUrl/log/app-open"),
      headers: {
        'Content-Type': 'application/json',
        'x-client-id': clientId,
        'x-device-type': deviceType,
        'x-user-agent': userAgent,
      },
    );

    if (response.statusCode == 200) {
      print("✅ App open logged successfully");
    } else {
      print("❌ Failed to log app open: ${response.body}");
    }
  }
}
