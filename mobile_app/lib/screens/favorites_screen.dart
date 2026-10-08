import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.lightGradient),
        child: SafeArea(
          child: Column(
            children: [
              // العنوان
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'النباتات المفضلة',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // المحتوى
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          size: 60,
                          color: AppColors.primaryGreen,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'لا توجد نباتات مفضلة بعد',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primaryGreen,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'أضف النباتات التي تعجبك إلى المفضلة',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.mediumGreen,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: () {
                          // التنقل للشاشة الرئيسية
                        },
                        child: const Text('استكشف النباتات'),
                      ),
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
}
