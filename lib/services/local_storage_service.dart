import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static const _storage = FlutterSecureStorage();
  static setValue(String key, String? value) {
    _storage.write(key: key, value: value);
  }
  static setimage(String key, String? value) {
    _storage.write(key: key, value: value);
  }

  static Future<String?> getValue(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> removeValue(String key) async {
    await _storage.delete(key: key);
  }
}
