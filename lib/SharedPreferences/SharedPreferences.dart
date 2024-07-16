import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<void> savePhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNumber', phoneNumber);
  }

  static Future<String?> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phoneNumber');
  }

  static Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('idUser', userId);
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('idUser');
  }

  static Future<void> saveBoDeId(String boDeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('boDeId', boDeId);
  }

  static Future<String?> getBoDeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('boDeId');
  }

  static Future<void> clearUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('phoneNumber');
    await prefs.remove('idUser');
    await prefs.remove('boDeId');
  }
}

