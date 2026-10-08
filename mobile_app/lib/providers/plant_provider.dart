import 'package:flutter/foundation.dart';
import '../models/plant.dart';
import '../models/community_pin.dart';
import '../services/api_service.dart';

class PlantProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Plant> _plants = [];
  List<CommunityPin> _communityPins = [];
  Plant? _selectedPlant;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedFilter = 'الكل';

  // Getters
  List<Plant> get plants => _plants;
  List<CommunityPin> get communityPins => _communityPins;
  Plant? get selectedPlant => _selectedPlant;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;

  // النباتات المفلترة
  List<Plant> get filteredPlants {
    List<Plant> filtered = _plants;

    // فلترة حسب البحث
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((plant) {
        return plant.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               plant.scientificName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               plant.commonNames.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // فلترة حسب الفئة
    if (_selectedFilter != 'الكل') {
      filtered = filtered.where((plant) {
        return plant.name == _selectedFilter ||
               plant.commonNames.contains(_selectedFilter);
      }).toList();
    }

    return filtered;
  }

  // قائمة الفلاتر المتاحة
  List<String> get availableFilters {
    List<String> filters = ['الكل'];
    for (Plant plant in _plants) {
      if (!filters.contains(plant.name)) {
        filters.add(plant.name);
      }
    }
    return filters;
  }

  // جلب جميع النباتات
  Future<void> loadPlants() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _plants = await _apiService.getPlants();
      _error = null;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      debugPrint('خطأ في جلب النباتات: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // جلب نبتة واحدة
  Future<void> loadPlantById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedPlant = await _apiService.getPlantById(id);
      _error = null;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      debugPrint('خطأ في جلب النبتة: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // جلب المواقع المجتمعية
  Future<void> loadCommunityPins() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _communityPins = await _apiService.getCommunityPins();
      _error = null;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      debugPrint('خطأ في جلب المواقع المجتمعية: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // إضافة موقع مجتمعي
  Future<bool> addCommunityPin({
    required String token,
    required double lat,
    required double lng,
    required String imagePath,
    String? plantName,
    String? comment,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.addCommunityPin(
        token: token,
        lat: lat,
        lng: lng,
        imagePath: imagePath,
        plantName: plantName,
        comment: comment,
      );
      
      // إعادة تحميل المواقع المجتمعية
      await loadCommunityPins();
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      debugPrint('خطأ في إضافة الموقع المجتمعي: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // تحديث استعلام البحث
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // تحديث الفلتر المحدد
  void updateSelectedFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // تحديد نبتة
  void selectPlant(Plant plant) {
    _selectedPlant = plant;
    notifyListeners();
  }

  // مسح النبتة المحددة
  void clearSelectedPlant() {
    _selectedPlant = null;
    notifyListeners();
  }

  // مسح الخطأ
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // البحث عن نبتة بالاسم
  Plant? findPlantByName(String name) {
    try {
      return _plants.firstWhere((plant) => 
        plant.name.toLowerCase() == name.toLowerCase() ||
        plant.scientificName.toLowerCase() == name.toLowerCase()
      );
    } catch (e) {
      return null;
    }
  }

  // الحصول على نباتات عشوائية
  List<Plant> getRandomPlants(int count) {
    if (_plants.isEmpty) return [];
    
    List<Plant> shuffled = List.from(_plants);
    shuffled.shuffle();
    
    return shuffled.take(count).toList();
  }
}
