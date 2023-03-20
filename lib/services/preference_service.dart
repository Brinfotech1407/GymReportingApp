import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static SharedPreferences? _preferences;

  static const String userEmail = 'USER_EMAIL';
  static const String userType = 'USER_TYPE';
  static const String userName = 'USER_NAME';
  static const String userLoggedIN = 'USER_LOGGED_IN';
  static const String ownerGymDetailsFiled = 'GYM_DETAILS_SUBMIT';
  static const String userID = 'USER_ID';

  PreferenceService() {
    init();
  }

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }


  Future<void> clearSharedPreference() async {
    await _preferences?.clear();
  }

  Future<bool>? setString(String key, String? value) {
    return _preferences?.setString(key, value ?? '');
  }

  String? getString(String key) {
    return _preferences?.getString(key);
  }

  Future<bool>? setInt(String key, int? value) {
    return _preferences?.setInt(key, value ?? 0);
  }

  int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  Future<bool>? setBool(String key, bool? value) {
    return _preferences?.setBool(key, value ?? false);
  }

  bool? getBool(String key) {
    return _preferences?.getBool(key);
  }
}
