import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  String? accessToken = '';

  TokenManager._internal();

  static final TokenManager _instance = TokenManager._internal();

  // Ham khoi tao duy nhat cua class
  factory TokenManager() {
    return _instance;
  }

//   save token
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken!);
  }

  load(SharedPreferences pref) async {
    accessToken = pref.getString('access_token') ?? '';
    debugPrint('accessToken $accessToken');
  }
}
