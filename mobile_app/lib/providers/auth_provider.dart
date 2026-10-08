import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final SharedPreferences prefs;
  final AuthService _authService = AuthService();

  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  AuthProvider({required this.prefs}) {
    _initializeAuth();
  }

  // Getters
  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null && _token != null;

  // تهيئة حالة المصادقة
  Future<void> _initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _authService.getToken();
      final userData = await _authService.getUserData();

      debugPrint('تم استرجاع التوكن: ${token != null ? "موجود" : "غير موجود"}');
      debugPrint('بيانات المستخدم: $userData');

      if (token != null && userData != null) {
        _token = token;
        // تحويل بيانات المستخدم إلى كائن User
        _user = User(
          id: userData['id'] ?? 0,
          username: userData['username'] ?? '',
          email: userData['email'] ?? '',
        );
        debugPrint('تم تهيئة المصادقة للمستخدم: ${_user?.username}');
      } else {
        debugPrint('لا توجد بيانات مصادقة محفوظة');
      }
    } catch (e) {
      _error = 'خطأ في تحميل بيانات المستخدم: $e';
      debugPrint('خطأ في تهيئة المصادقة: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // تسجيل الدخول
  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response['token'] != null && response['user'] != null) {
        _token = response['token'];
        _user = User.fromJson(response['user']);
        _error = null;
        return true;
      } else {
        _error = 'فشل في تسجيل الدخول';
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // التسجيل
  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(
        username: username,
        email: email,
        password: password,
      );

      if (response['token'] != null && response['user'] != null) {
        _token = response['token'];
        _user = User.fromJson(response['user']);
        _error = null;
        return true;
      } else {
        _error = 'فشل في التسجيل';
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _user = null;
      _token = null;
      _error = null;
    } catch (e) {
      _error = 'خطأ في تسجيل الخروج';
      debugPrint('خطأ في تسجيل الخروج: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // مسح الخطأ
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // تحديث بيانات المستخدم
  void updateUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}
