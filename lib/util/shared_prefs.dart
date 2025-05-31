import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> saveLogin(String nim) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', nim);
  }

  static Future<String?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}
