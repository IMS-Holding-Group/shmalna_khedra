import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  final ApiService _apiService = ApiService();

  // حفظ التوكن
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // حفظ بيانات المستخدم
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(userData);
    await prefs.setString(_userKey, userJson);
  }

  // جلب التوكن المحفوظ
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // جلب بيانات المستخدم المحفوظة
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        return jsonDecode(userJson) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // تسجيل الدخول
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );

      // حفظ التوكن وبيانات المستخدم
      if (response['token'] != null) {
        await _saveToken(response['token']);
        if (response['user'] != null) {
          await _saveUserData(response['user']);
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // التسجيل
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.register(
        username: username,
        email: email,
        password: password,
      );

      // حفظ التوكن وبيانات المستخدم
      if (response['token'] != null) {
        await _saveToken(response['token']);
        if (response['user'] != null) {
          await _saveUserData(response['user']);
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // التحقق من حالة تسجيل الدخول
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // جلب التوكن الحالي
  Future<String?> getCurrentToken() async {
    return await getToken();
  }
}
