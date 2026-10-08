import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/plant_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../models/plant.dart';
import '../utils/app_colors.dart';
import 'plant_detail_screen.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();
  bool _isFlashOn = false;
  bool _isScanning = false;
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  Future<void> _takePicture(BuildContext ctx) async {
    try {
      // التحقق من إذن الموقع أولاً
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        _showError(ctx, 'يرجى تفعيل خدمة الموقع');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError(ctx, 'تم رفض إذن الموقع');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openLocationSettings();
        _showError(ctx, 'يرجى السماح بالموقع من الإعدادات');
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        _startScanningAnimation();
        await _processImage(ctx, image);
      }
    } catch (e) {
      _showError(ctx, 'خطأ في التقاط الصورة: $e');
    }
  }

  Future<void> _pickFromGallery(BuildContext ctx) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        _startScanningAnimation();
        await _processImage(ctx, image);
      }
    } catch (e) {
      _showError(ctx, 'خطأ في اختيار الصورة: $e');
    }
  }

  void _startScanningAnimation() {
    setState(() {
      _isScanning = true;
    });
    _scanController.repeat();
  }

  void _stopScanningAnimation() {
    _scanController.stop();
    _scanController.reset();
    setState(() {
      _isScanning = false;
    });
  }

  Future<void> _processImage(BuildContext ctx, XFile image) async {
    try {
      // التعرف على النبات باستخدام AI
      final result = await _apiService.recognizePlant(image.path);

      _stopScanningAnimation();

      if (result['success'] == true && result['plant'] != null) {
        // تم التعرف بنجاح - عرض معلومات النبات
        final plant = Plant.fromJson(result['plant']);
        final recognitionInfo = result['recognition'];

        _showPlantRecognitionResult(
          ctx,
          image,
          plant,
          recognitionInfo: recognitionInfo,
        );
      } else {
        // لم يتم التعرف على النبات
        _showRecognitionError(ctx, result);
      }
    } catch (e) {
      _stopScanningAnimation();
      _showError(ctx, 'لم يتم التعرف على النبات: $e');
    }
  }

  void _showPlantRecognitionResult(
    BuildContext context,
    XFile image,
    Plant plant, {
    Map<String, dynamic>? recognitionInfo,
  }) {
    final BuildContext ctx = context;
    final confidence = recognitionInfo?['confidence_percent'] ?? 0.0;

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 28),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'تم التعرف على النبات',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصورة
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(File(image.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // اسم النبات
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Icon(Icons.eco, color: AppColors.primaryGreen, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      plant.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // الاسم العلمي
              Text(
                plant.scientificName,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 12),

              // مستوى الثقة
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(
                      Icons.analytics,
                      color: AppColors.primaryGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'مستوى الثقة: ${confidence.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(ctx).pop();
              // عرض خيارات: نشر للمجتمع أو عرض التفاصيل
              await _showPublishOptions(ctx, image, plant);
            },
            icon: const Icon(Icons.share),
            label: const Text('نشر للمجتمع'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (context) => PlantDetailScreen(plant: plant),
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
            label: const Text('عرض التفاصيل'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen.withOpacity(0.7),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPublishOptions(
    BuildContext context,
    XFile image,
    Plant plant,
  ) async {
    final TextEditingController commentController = TextEditingController();
    final BuildContext ctx = context;
    final AuthProvider authProvider = Provider.of<AuthProvider>(ctx, listen: false);

    if (!authProvider.isAuthenticated) {
      _showLoginRequiredDialog(ctx);
      return;
    }

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(Icons.share, color: AppColors.primaryGreen, size: 28),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'نشر للمجتمع',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(File(image.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'النبات: ${plant.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                maxLines: 3,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: 'تعليق (اختياري)',
                  hintText: 'اكتب تعليقاً عن هذا النبات...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryGreen,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _publishToCommunity(ctx, image, plant, commentController.text);
            },
            icon: const Icon(Icons.upload),
            label: const Text('نشر'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _publishToCommunity(
    BuildContext context,
    XFile image,
    Plant plant,
    String comment,
  ) async {
    final BuildContext ctx = context;
    final AuthProvider authProvider = Provider.of<AuthProvider>(ctx, listen: false);
    final PlantProvider plantProvider = Provider.of<PlantProvider>(ctx, listen: false);

    try {
      // الحصول على الموقع الحالي
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError(ctx, 'يرجى تفعيل خدمة الموقع');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError(ctx, 'تم رفض إذن الموقع');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError(ctx, 'يرجى السماح بالموقع من الإعدادات');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // إظهار مؤشر التحميل
      showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
          ),
        ),
      );

      // نشر للمجتمع
      final result = await _apiService.addCommunityPin(
        token: authProvider.token!,
        lat: position.latitude,
        lng: position.longitude,
        imagePath: image.path,
        plantName: plant.name,
        comment: comment.isNotEmpty ? comment : null,
      );

      Navigator.of(ctx).pop(); // إغلاق مؤشر التحميل

      if (ctx.mounted) {
        // تحديث قائمة المواقع مباشرة - هذا سيحدث الخريطة تلقائياً
        await plantProvider.loadCommunityPins();

        // إظهار رسالة نجاح
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('تم نشر الصورة بنجاح! 🎉 سيتم عرضها على الخريطة مباشرة'),
            backgroundColor: AppColors.primaryGreen,
            duration: Duration(seconds: 3),
          ),
        );

        // إغلاق شاشة الكاميرا - الخريطة ستحدث تلقائياً بسبب listener
        Navigator.of(ctx).pop();
      }
    } catch (e) {
      if (ctx.mounted) {
        Navigator.of(ctx).pop(); // إغلاق مؤشر التحميل
        _showError(ctx, 'فشل في النشر: $e');
      }
    }
  }

  void _showRecognitionError(
    BuildContext context,
    Map<String, dynamic> result,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(Icons.error_outline, color: Colors.orange, size: 28),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'لم يتم التعرف على النبات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result['message'] ??
                  result['error'] ??
                  'لم يتم التعرف على النبات في الصورة. تأكد من أن الصورة واضحة وتحتوي على نبات من النباتات المدربة.',
              style: const TextStyle(fontSize: 16),
            ),
            if (result['recognized_name'] != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تم التعرف على:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result['recognized_name'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (result['confidence'] != null)
                      Text(
                        'مستوى الثقة: ${result['confidence']}%',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'قد يكون النبات غير موجود في قاعدة بياناتنا حالياً.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showError(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
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
          'يجب تسجيل الدخول أولاً لنشر النباتات للمجتمع',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // خلفية الكاميرا
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, AppColors.primaryGreen.withOpacity(0.3)],
              ),
            ),
            child: const Center(
              child: Icon(Icons.camera_alt, size: 200, color: Colors.white24),
            ),
          ),

          // أنيميشن المسح
          if (_isScanning)
            AnimatedBuilder(
              animation: _scanAnimation,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: CustomPaint(
                    painter: ScannerPainter(_scanAnimation.value),
                  ),
                );
              },
            ),

          // شريط التحكم العلوي
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFlashOn = !_isFlashOn;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // شريط التحكم السفلي
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // زر الاستوديو
                  GestureDetector(
                    onTap: () => _pickFromGallery(context),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),

                  // زر التقاط
                  GestureDetector(
                    onTap: () => _takePicture(context),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),

                  // زر الإعدادات
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerPainter extends CustomPainter {
  final double progress;

  ScannerPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGreen.withOpacity(0.8)
      ..strokeWidth = 3;

    final path = Path();
    final y = size.height * progress;

    path.moveTo(0, y);
    path.lineTo(size.width, y);

    canvas.drawPath(path, paint);

    // رسم خطوط المسح
    for (int i = 0; i < 10; i++) {
      final lineY = y + (i * 20);
      if (lineY < size.height) {
        canvas.drawLine(
          Offset(0, lineY),
          Offset(size.width, lineY),
          paint..color = AppColors.primaryGreen.withOpacity(0.3),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
