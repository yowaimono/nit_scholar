import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> saveUserCredentials(
      String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  static Future<bool> getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');

    if (username != null && password != null) {
      return true;
    }
    return false;
  }
}
