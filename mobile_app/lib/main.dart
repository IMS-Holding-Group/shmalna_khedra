import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_navigation.dart';
import 'screens/plant_detail_screen.dart';
import 'screens/camera_screen.dart';
import 'models/plant.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'providers/plant_provider.dart';
import 'providers/auth_provider.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تفعيل RTL لكامل التطبيق
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // تهيئة SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(prefs: prefs)),
        ChangeNotifierProvider(create: (context) => PlantProvider()),
        Provider(create: (context) => ApiService()),
        Provider(create: (context) => AuthService()),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          title: 'شمالنا خضراء',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const MainNavigation(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/main': (context) => const MainNavigation(),
            '/camera': (context) => const CameraScreen(),
            '/plant-details': (context) {
              final plant = ModalRoute.of(context)!.settings.arguments as Plant;
              return PlantDetailScreen(plant: plant);
            },
          },
        ),
      ),
    );
  }
}
