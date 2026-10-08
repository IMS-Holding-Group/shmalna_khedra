import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiConfig {
  static const int port = 3000;
  static const String? manualIp = null; // ضع IP جهازك هنا إذا أردت (مثال: '192.168.1.100')
  static const String _cachedIpKey = 'api_cached_ip';
  static const String _cachedBaseUrlKey = 'api_cached_base_url';
  
  static List<String> get _possibleHosts {
    if (kIsWeb) {
      return ['localhost'];
    } else if (Platform.isAndroid) {
      return [
        '10.0.2.2',
        'localhost',
        ..._generatePossibleIps(),
      ];
    } else if (Platform.isIOS) {
      return [
        'localhost',
        '127.0.0.1',
        ..._generatePossibleIps(),
      ];
    } else {
      return ['localhost', '127.0.0.1'];
    }
  }

  static List<String> _generatePossibleIps() {
    final ips = <String>[];
    
    ips.addAll([
      '192.168.43.1',
      '172.20.10.1',
      '192.168.137.1',
      '192.168.1.1',
      '192.168.0.1',
      '192.168.2.1',
      '10.0.0.1',
    ]);
    
    for (int i = 1; i <= 100; i++) {
      ips.add('192.168.1.$i');
      ips.add('192.168.0.$i');
      ips.add('192.168.2.$i');
      if (i <= 50) {
        ips.add('10.0.0.$i');
      }
    }
    
    return ips;
  }

  static Future<String> getBaseUrl() async {
    if (manualIp != null && manualIp!.isNotEmpty) {
      return 'http://$manualIp:$port';
    }
    
    final prefs = await SharedPreferences.getInstance();
    final cachedBaseUrl = prefs.getString(_cachedBaseUrlKey);
    
    if (cachedBaseUrl != null && cachedBaseUrl.isNotEmpty) {
      if (await _testConnection(cachedBaseUrl)) {
        return cachedBaseUrl;
      } else {
        await prefs.remove(_cachedBaseUrlKey);
        await prefs.remove(_cachedIpKey);
      }
    }

    final workingUrl = await _discoverWorkingUrl();
    
    if (workingUrl != null) {
      await prefs.setString(_cachedBaseUrlKey, workingUrl);
      final ip = workingUrl.replaceAll('http://', '').replaceAll(':$port', '');
      await prefs.setString(_cachedIpKey, ip);
      return workingUrl;
    }

    return _getDefaultUrl();
  }

  static Future<String?> _discoverWorkingUrl() async {
    final hosts = _possibleHosts;
    final emulatorHosts = ['10.0.2.2', 'localhost', '127.0.0.1'];
    
    for (var host in emulatorHosts) {
      if (hosts.contains(host)) {
        final result = await _tryHostQuick(host);
        if (result != null) {
          return result;
        }
      }
    }
    
    final realDeviceHosts = hosts.where((h) => !emulatorHosts.contains(h)).toList();
    
    final batchSize = 30;
    for (int i = 0; i < realDeviceHosts.length; i += batchSize) {
      final batch = realDeviceHosts.skip(i).take(batchSize).toList();
      final futures = batch.map((host) => _tryHost(host));
      final results = await Future.wait(futures, eagerError: false);
      
      for (var result in results) {
        if (result != null) {
          return result;
        }
      }
    }
    
    return null;
  }

  static Future<String?> _tryHostQuick(String host) async {
    try {
      final url = 'http://$host:$port';
      if (await _testConnectionQuick(url)) {
        return url;
      }
    } catch (e) {
      // ignore
    }
    return null;
  }

  static Future<bool> _testConnectionQuick(String baseUrl) async {
    try {
      final url = Uri.parse('$baseUrl/api/plants');
      final response = await http.get(url).timeout(const Duration(milliseconds: 500));
      return response.statusCode >= 200 && response.statusCode < 500;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> _tryHost(String host) async {
    try {
      final url = 'http://$host:$port';
      if (await _testConnection(url)) {
        return url;
      }
    } catch (e) {
      // ignore
    }
    return null;
  }

  static Future<bool> _testConnection(String baseUrl) async {
    try {
      final url = Uri.parse('$baseUrl/api/plants');
      final response = await http.get(url).timeout(const Duration(seconds: 1));
      return response.statusCode >= 200 && response.statusCode < 500;
    } catch (e) {
      return false;
    }
  }

  static String _getDefaultUrl() {
    if (kIsWeb) {
      return 'http://localhost:$port';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:$port';
    } else if (Platform.isIOS) {
      return 'http://localhost:$port';
    } else {
      return 'http://localhost:$port';
    }
  }

  static Future<String> getApiBaseUrl() async {
    final baseUrl = await getBaseUrl();
    return '$baseUrl/api';
  }

  static Future<String?> getDiscoveredIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cachedIpKey);
  }

  static Future<String> rediscoverBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachedBaseUrlKey);
    await prefs.remove(_cachedIpKey);
    return await getBaseUrl();
  }

  static Future<void> setCustomIp(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    final baseUrl = 'http://$ip:$port';
    await prefs.setString(_cachedBaseUrlKey, baseUrl);
    await prefs.setString(_cachedIpKey, ip);
  }

  static Future<void> clearCachedIp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachedBaseUrlKey);
    await prefs.remove(_cachedIpKey);
  }
}

Future<String> getImageUrl(String imagePath) async {
  final baseUrl = await ApiConfig.getBaseUrl();
  final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
  return '$baseUrl/$cleanPath';
}
