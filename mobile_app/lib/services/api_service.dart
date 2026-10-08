import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant.dart';
import '../models/community_pin.dart';
import '../utils/api_config.dart';

class ApiService {
  // الحصول على عنوان API الديناميكي
  static Future<String> get baseUrl async => await ApiConfig.getApiBaseUrl();

  // رؤوس HTTP المشتركة
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // رؤوس HTTP مع التوكن
  Map<String, String> _headersWithToken(String token) => {
    ..._headers,
    'Authorization': 'Bearer $token',
  };

  // معالجة الأخطاء
  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      final errorData = json.decode(response.body);
      throw Exception(errorData['error'] ?? 'حدث خطأ غير متوقع');
    }
  }

  // جلب جميع النباتات
  Future<List<Plant>> getPlants() async {
    return await _tryWithAutoRediscover(() async {
      final apiUrl = await baseUrl;
      final response = await http.get(
        Uri.parse('$apiUrl/plants'),
        headers: _headers,
      );

      _handleError(response);

      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Plant.fromJson(json)).toList();
    }, 'فشل في جلب النباتات');
  }

  // جلب نبتة واحدة
  Future<Plant> getPlantById(int id) async {
    try {
      final apiUrl = await baseUrl;
      final response = await http.get(
        Uri.parse('$apiUrl/plants/$id'),
        headers: _headers,
      );

      _handleError(response);

      final Map<String, dynamic> data = json.decode(response.body);
      return Plant.fromJson(data);
    } catch (e) {
      throw Exception('فشل في جلب النبتة: $e');
    }
  }

  // تسجيل مستخدم جديد
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    // محاولة مع إعادة اكتشاف تلقائي عند فشل الاتصال
    return await _tryWithAutoRediscover(() async {
      final apiUrl = await baseUrl;
      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        headers: _headers,
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      _handleError(response);

      return json.decode(response.body);
    }, 'فشل في التسجيل');
  }

  /// محاولة تنفيذ عملية مع إعادة اكتشاف تلقائي عند فشل الاتصال
  Future<T> _tryWithAutoRediscover<T>(
    Future<T> Function() operation,
    String errorMessage,
  ) async {
    try {
      return await operation();
    } catch (e) {
      // إذا كان الخطأ متعلق بالاتصال، حاول إعادة الاكتشاف
      if (e.toString().contains('timed out') || 
          e.toString().contains('Connection') ||
          e.toString().contains('Failed host lookup') ||
          e.toString().contains('SocketException')) {
        
        // إعادة اكتشاف IP
        await ApiConfig.rediscoverBaseUrl();
        
        // محاولة مرة أخرى
        try {
          return await operation();
        } catch (retryError) {
          throw Exception('$errorMessage: $retryError');
        }
      } else {
        throw Exception('$errorMessage: $e');
      }
    }
  }

  // تسجيل الدخول
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _tryWithAutoRediscover(() async {
      final apiUrl = await baseUrl;
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: _headers,
        body: json.encode({'email': email, 'password': password}),
      );

      _handleError(response);

      return json.decode(response.body);
    }, 'فشل في تسجيل الدخول');
  }

  // إضافة موقع مجتمعي مع التعرف بالذكاء الاصطناعي
  Future<Map<String, dynamic>> addCommunityPin({
    required String token,
    required double lat,
    required double lng,
    required String imagePath,
    String? plantName,
    String? comment,
  }) async {
    try {
      final apiUrl = await baseUrl;
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$apiUrl/community/add'),
      );

      request.headers.addAll(_headersWithToken(token));
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      request.fields['lat'] = lat.toString();
      request.fields['lng'] = lng.toString();
      if (plantName != null) {
        request.fields['plant_name'] = plantName;
      }
      if (comment != null && comment.isNotEmpty) {
        request.fields['comment'] = comment;
      }

      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);

      final responseData = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw Exception(responseData['error'] ?? 'فشل في إضافة الموقع');
      }

      return responseData;
    } catch (e) {
      throw Exception('فشل في إضافة الموقع: $e');
    }
  }

  // جلب جميع المواقع المجتمعية
  Future<List<CommunityPin>> getCommunityPins() async {
    try {
      final apiUrl = await baseUrl;
      final response = await http.get(
        Uri.parse('$apiUrl/community/pins'),
        headers: _headers,
      );

      _handleError(response);

      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CommunityPin.fromJson(json)).toList();
    } catch (e) {
      throw Exception('فشل في جلب المواقع المجتمعية: $e');
    }
  }

  // التعرف على النبات من الصورة (AI)
  Future<Map<String, dynamic>> recognizePlant(String imagePath) async {
    try {
      final apiUrl = await baseUrl;
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$apiUrl/plants/recognize'),
      );

      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);

      final responseData = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw Exception(responseData['error'] ?? responseData['message'] ?? 'لم يتم التعرف على النبات');
      }

      return responseData;
    } catch (e) {
      throw Exception('لم يتم التعرف على النبات: $e');
    }
  }
}
