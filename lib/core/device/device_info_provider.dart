import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../storage/key_value_store.dart';

class DeviceInfoSnapshot {
  const DeviceInfoSnapshot({
    required this.deviceId,
    required this.platform,
    required this.osVersion,
    required this.appVersion,
  });

  final String deviceId;
  final String platform;
  final String osVersion;
  final String appVersion;

  Map<String, dynamic> toJson() => {
        'device_id': deviceId,
        'platform': platform,
        'os_version': osVersion,
        'app_version': appVersion,
      };
}

class DeviceInfoProvider {
  DeviceInfoProvider({
    required KeyValueStore storage,
    DeviceInfoPlugin? plugin,
    this.appVersion = '1.0.0',
  })  : _storage = storage,
        _plugin = plugin ?? DeviceInfoPlugin();

  static const _deviceIdKey = 'device_id';

  final KeyValueStore _storage;
  final DeviceInfoPlugin _plugin;
  final String appVersion;

  Future<DeviceInfoSnapshot> getDeviceInfo() async {
    final deviceId = await _resolveDeviceId();
    if (kIsWeb) {
      return DeviceInfoSnapshot(
        deviceId: deviceId,
        platform: 'Web',
        osVersion: 'unknown',
        appVersion: appVersion,
      );
    }

    if (Platform.isIOS) {
      final info = await _plugin.iosInfo;
      return DeviceInfoSnapshot(
        deviceId: deviceId,
        platform: 'iOS',
        osVersion: info.systemVersion,
        appVersion: appVersion,
      );
    }

    if (Platform.isAndroid) {
      final info = await _plugin.androidInfo;
      return DeviceInfoSnapshot(
        deviceId: deviceId,
        platform: 'Android',
        osVersion: info.version.release,
        appVersion: appVersion,
      );
    }

    return DeviceInfoSnapshot(
      deviceId: deviceId,
      platform: Platform.operatingSystem,
      osVersion: Platform.operatingSystemVersion,
      appVersion: appVersion,
    );
  }

  Future<String> _resolveDeviceId() async {
    final existing = await _storage.read(key: _deviceIdKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final created = const Uuid().v4();
    await _storage.write(key: _deviceIdKey, value: created);
    return created;
  }
}
