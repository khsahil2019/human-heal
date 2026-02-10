import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static Future<void> saveUserDetails(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_id', userData['user_id'].toString());
    await prefs.setString('name', userData['name'] ?? '');
    await prefs.setString('email', userData['email'] ?? '');
    await prefs.setString('mobile', userData['mobile'] ?? '');
    await prefs.setBool('is_verified', userData['is_verified'] == "1");
  }

  static Future<Map<String, dynamic>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'user_id': prefs.getString('user_id') ?? '',
      'name': prefs.getString('name') ?? '',
      'email': prefs.getString('email') ?? '',
      'mobile': prefs.getString('mobile') ?? '',
      'is_verified': prefs.getBool('is_verified') ?? false,
    };
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
