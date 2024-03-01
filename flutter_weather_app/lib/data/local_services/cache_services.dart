import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/app_data.dart';
import '../exceptions/exception.dart';

class CacheService {
  static SharedPreferences? _instance;
  static String token = "dbToken";

  static Future<SharedPreferences> getInstance() async {
    return _instance ??= await SharedPreferences.getInstance();
  }

  static Future<bool> setAccessToken(String accessToken) async {
    try {
      bool saved = await _instance!.setString(token, accessToken);
      return saved;
    } catch (e) {
      throw CacheException("SetAccessToken Error : $e");
    }
  }

  static Future<String> getAccessToken() async {
    if (_instance!.containsKey(token)) {
      String? accessToken = _instance!.getString(token);
      return accessToken ?? "";
    }
    return "";
  }

  static Future<void> removeAppUser() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final data = await pref.remove(token);
      print(data);
      AppData.accessToken = "";

      FirebaseAuth.instance.signOut();
    } catch (e) {}
  }

  static Future<void> close() async {
    if (_instance != null) {
      await _instance!.clear();
      _instance = null;
    }
  }

  static Future socialMediaLoggedOut() async {
    FirebaseAuth.instance.signOut();
  }
}
