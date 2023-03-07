import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService{
 static SharedPreferences? _preferences;


  static const String _userEmail = 'USEREMAIL';


 Future<void> init() async {
   _preferences = await SharedPreferences.getInstance();
 }

  Future<void> setUserEmail(String userPhoneNo) async {
    await _preferences?.setString(_userEmail, userPhoneNo);

  }

  String? getUserEmail(String key) {
    return _preferences?.getString(key);
  }
}