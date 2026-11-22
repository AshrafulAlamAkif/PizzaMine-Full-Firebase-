
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceService {
  static const String _installationKey = 'installation_id';

  final SharedPreferencesAsync _preferences;
  final DeviceInfoPlugin _deviceInfo;

  DeviceService({
    SharedPreferencesAsync? preferences,
    DeviceInfoPlugin? deviceInfo,
  })  : _preferences = preferences ?? SharedPreferencesAsync(),
        _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  Future<String> getInstallationId() async {
    String? id = await _preferences.getString(_installationKey);

    if (id != null && id.isNotEmpty) {
      return id;
    }

    id = const Uuid().v4();

    await _preferences.setString(_installationKey, id);

    return id;
  }

  Future<String> getPlatform() async {
    if (Platform.isAndroid) {
      return 'android';
    }

    if (Platform.isIOS) {
      return 'ios';
    }

    return 'other';
  }

  Future<Map<String, dynamic>> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;

      return {
        'platform': 'android',
        'manufacturer': info.manufacturer,
        'model': info.model,
        'osVersion': info.version.release,
      };
    }

    if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;

      return {
        'platform': 'ios',
        'model': info.model,
        'osVersion': info.systemVersion,
      };
    }

    return {'platform': 'other'};
  }
}