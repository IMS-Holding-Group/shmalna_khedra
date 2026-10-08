import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/plant_provider.dart';
import '../providers/auth_provider.dart';
import '../models/community_pin.dart';
import '../utils/app_colors.dart';
import '../utils/api_config.dart';
import 'plant_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  final List<CircleMarker> _circles = [];
  final LatLng _center = const LatLng(30.9753, 41.0381); // عرعر
  String _baseUrl = 'http://10.0.2.2:3000'; // قيمة افتراضية

  @override
  void initState() {
    super.initState();
    _loadBaseUrl();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);
      plantProvider.loadCommunityPins();
      // إضافة listener لتحديث الخريطة تلقائياً عند تغيير البيانات
      plantProvider.addListener(_onPlantProviderChanged);
    });
  }

  Future<void> _loadBaseUrl() async {
    final baseUrl = await ApiConfig.getBaseUrl();
    if (mounted) {
      setState(() {
        _baseUrl = baseUrl;
      });
    }
  }

  @override
  void dispose() {
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    plantProvider.removeListener(_onPlantProviderChanged);
    super.dispose();
  }

  void _onPlantProviderChanged() {
    if (mounted) {
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);
      _updateMarkers(plantProvider.communityPins);
    }
  }

  void _updateMarkers(List<CommunityPin> pins) {
    if (!mounted) return;

    setState(() {
      _markers.clear();
      _circles.clear();

      for (CommunityPin pin in pins) {
        // إضافة دائرة خضراء أكبر حول الموقع
        _circles.add(
          CircleMarker(
            point: LatLng(pin.lat, pin.lng),
            radius: 100, // 100 متر
            color: AppColors.primaryGreen.withOpacity(0.15),
            borderColor: AppColors.primaryGreen.withOpacity(0.8),
            borderStrokeWidth: 3,
            useRadiusInMeter: true,
          ),
        );

        // إضافة علامة مع الصورة في الدائرة
        _markers.add(
          Marker(
            point: LatLng(pin.lat, pin.lng),
            width: 80,
            height: 80,
            child: GestureDetector(
              onTap: () => _showPinDetails(pin),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: pin.imagePath != null
                      ? Image.network(
                          '$_baseUrl/uploads/${pin.imagePath}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.primaryGreen,
                              child: const Icon(
                                Icons.eco,
                                color: Colors.white,
                                size: 30,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: AppColors.primaryGreen,
                          child: const Icon(
                            Icons.eco,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  void _showPinDetails(CommunityPin pin) {
    final BuildContext ctx = context;
    final PlantProvider plantProvider = Provider.of<PlantProvider>(
      ctx,
      listen: false,
    );

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.gray.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (pin.imagePath != null)
                        Container(
                          height: 200,
                          width: double.infinity,
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.lightGreen,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryGreen.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              '$_baseUrl/uploads/${pin.imagePath}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.lightGreen,
                                  child: const Center(
                                    child: Icon(
                                      Icons.eco,
                                      size: 80,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Text(
                                        pin.plantName,
                                        style: Theme.of(ctx).textTheme.titleLarge
                                            ?.copyWith(
                                              color: AppColors.primaryGreen,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        pin.username != null && pin.username!.isNotEmpty
                                            ? 'بواسطة: ${pin.username}'
                                            : 'بواسطة: مستخدم',
                                        style: Theme.of(ctx).textTheme.bodyMedium
                                            ?.copyWith(color: AppColors.gray),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.eco,
                                    color: AppColors.primaryGreen,
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                            if (pin.comment != null && pin.comment!.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGreen.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.primaryGreen.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        pin.comment!,
                                        style: Theme.of(ctx).textTheme.bodyMedium
                                            ?.copyWith(color: AppColors.darkGray),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.comment,
                                      color: AppColors.primaryGreen,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.lightGreen.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primaryGreen.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                ctx,
                                Icons.location_on,
                                'الإحداثيات',
                                '${pin.lat.toStringAsFixed(6)}, ${pin.lng.toStringAsFixed(6)}',
                              ),
                              if (pin.createdAt != null) ...[
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  ctx,
                                  Icons.calendar_today,
                                  'التاريخ',
                                  pin.createdAt!.toLocal().toString().substring(
                                    0,
                                    10,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              Navigator.of(ctx).pop();
                              if (plantProvider.plants.isEmpty) {
                                await plantProvider.loadPlants();
                              }
                              try {
                                final plant = plantProvider.plants.firstWhere(
                                  (p) => p.name == pin.plantName,
                                );
                                if (ctx.mounted) {
                                  Navigator.of(ctx).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PlantDetailScreen(plant: plant),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (ctx.mounted &&
                                    plantProvider.plants.isNotEmpty) {
                                  Navigator.of(ctx).push(
                                    MaterialPageRoute(
                                      builder: (context) => PlantDetailScreen(
                                        plant: plantProvider.plants.first,
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'عرض تفاصيل النبتة الكاملة',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.gray),
            textDirection: TextDirection.rtl,
          ),
        ),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.darkGray,
          ),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(width: 12),
        Icon(icon, size: 20, color: AppColors.primaryGreen),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer<PlantProvider>(
            builder: (context, plantProvider, child) {
              if (!plantProvider.isLoading) {
                final pins = plantProvider.communityPins;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    _updateMarkers(pins);
                  }
                });
              }
              return const SizedBox.shrink();
            },
          ),
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 13.0,
              minZoom: 11.0,
              maxZoom: 18.0,
              onTap: (tapPosition, point) {
                // يمكن إضافة تفاعل عند الضغط على الخريطة
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.shmalnakhedra.shmalna_khedra',
                maxZoom: 19,
              ),
              CircleLayer(circles: _circles),
              MarkerLayer(markers: _markers),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryGreen.withOpacity(0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'خريطة النباتات المجتمعية',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اكتشف مواقع النباتات التي اكتشفها المجتمع',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.lightGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: Consumer<PlantProvider>(
              builder: (context, plantProvider, child) {
                if (plantProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryGreen,
                      ),
                    ),
                  );
                }

                final pins = plantProvider.communityPins;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    _updateMarkers(pins);
                  }
                });

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem(
                            context,
                            'النباتات المكتشفة',
                            pins
                                .map((p) => p.plantName)
                                .toSet()
                                .length
                                .toString(),
                            Icons.eco,
                            AppColors.success,
                          ),
                          _buildStatItem(
                            context,
                            'إجمالي المواقع',
                            pins.length.toString(),
                            Icons.location_on,
                            AppColors.primaryGreen,
                          ),
                        ],
                      ),
                      if (pins.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _showLatestPinsDialog(context, pins),
                          icon: const Icon(Icons.history),
                          label: const Text('أحدث المواقع'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          // زر إضافة موقع جديد
          Positioned(
            bottom: 20,
            left: 16,
            child: FloatingActionButton.extended(
              onPressed: () => _addNewPin(context),
              backgroundColor: AppColors.primaryGreen,
              icon: const Icon(Icons.add_location, color: Colors.white),
              label: const Text(
                'إضافة موقع',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addNewPin(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (!authProvider.isAuthenticated) {
      _showLoginRequiredDialog(context);
      return;
    }
    
    Navigator.pushNamed(context, '/camera');
  }

  void _showLoginRequiredDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(Icons.login, color: AppColors.primaryGreen, size: 28),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'تسجيل الدخول مطلوب',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
        content: const Text(
          'يجب تسجيل الدخول أولاً لإضافة موقع جديد',
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pushNamed('/login');
            },
            icon: const Icon(Icons.login),
            label: const Text('تسجيل الدخول'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showLatestPinsDialog(BuildContext context, List<CommunityPin> pins) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.gray.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'أحدث المواقع',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: pins.length,
                  itemBuilder: (context, index) {
                    final pin = pins[index];
                    return ListTile(
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.lightGreen,
                        ),
                        child: pin.imagePath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  '$_baseUrl/uploads/${pin.imagePath}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.eco,
                                      color: AppColors.primaryGreen,
                                    );
                                  },
                                ),
                              )
                            : const Icon(
                                Icons.eco,
                                color: AppColors.primaryGreen,
                              ),
                      ),
                      title: Text(
                        pin.plantName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            pin.username != null && pin.username!.isNotEmpty
                                ? 'بواسطة: ${pin.username}'
                                : 'بواسطة: مستخدم',
                            textDirection: TextDirection.rtl,
                          ),
                          if (pin.createdAt != null)
                            Text(
                              '${pin.createdAt!.toLocal().toString().substring(0, 16)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pop(context);
                        _showPinDetails(pin);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.darkGray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

