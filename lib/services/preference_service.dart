import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static SharedPreferences? _preferences;

  static const String _userEmail = 'USEREMAIL';
  static const String _userType = 'USERTYPE';

  PreferenceService() {
    init();
  }

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> setUserEmail(String userPhoneNo) async {
    await _preferences?.setString(_userEmail, userPhoneNo);
  }

  String? getUserEmail(String key) {
    return _preferences?.getString(key);
  }

  Future<void> setUserType(bool userType) async {
    await _preferences?.setBool(_userType, userType);
  }

  bool getUserType()  {
    return _preferences?.getBool(_userType) ?? false;
  }
}
