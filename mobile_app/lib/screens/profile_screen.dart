import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../screens/auth/login_screen.dart';
import 'settings_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import 'association_info_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                  'الملف الشخصي',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // معلومات المستخدم
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.user == null) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 100,
                              color: AppColors.primaryGreen.withOpacity(0.5),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'لم يتم تسجيل الدخول',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'سجل دخولك للاستفادة من جميع المميزات',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.gray,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/login');
                              },
                              icon: const Icon(Icons.login),
                              label: const Text('تسجيل الدخول'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/register');
                              },
                              child: const Text('إنشاء حساب جديد'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          // صورة المستخدم
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryGreen.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: AppColors.white,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // اسم المستخدم
                          Text(
                            authProvider.user!.username,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),

                          const SizedBox(height: 8),

                          // البريد الإلكتروني
                          Text(
                            authProvider.user!.email,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.mediumGreen),
                          ),

                          const SizedBox(height: 32),

                          // الإحصائيات
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  'المواقع المضافة',
                                  '0',
                                  Icons.location_on,
                                  AppColors.info,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  'النباتات المكتشفة',
                                  '0',
                                  Icons.eco,
                                  AppColors.success,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // قائمة الخيارات
                          _buildMenuSection(context),

                          const SizedBox(height: 32),

                          // زر تسجيل الخروج
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _showLogoutDialog(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: AppColors.white,
                              ),
                              child: const Text('تسجيل الخروج'),
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
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
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final menuItems = [
      {
        'title': 'الإعدادات',
        'icon': Icons.settings,
        'color': AppColors.primaryGreen,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        },
      },
      {
        'title': 'المساعدة والدعم',
        'icon': Icons.help_outline,
        'color': AppColors.info,
        'onTap': () {
          _showHelpDialog(context);
        },
      },
      {
        'title': 'حول التطبيق',
        'icon': Icons.info_outline,
        'color': AppColors.warning,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AssociationInfoScreen(),
            ),
          );
        },
      },
      {
        'title': 'سياسة الخصوصية',
        'icon': Icons.privacy_tip_outlined,
        'color': AppColors.mediumGreen,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PrivacyPolicyScreen(),
            ),
          );
        },
      },
      {
        'title': 'شروط الاستخدام',
        'icon': Icons.description_outlined,
        'color': AppColors.darkGreen,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TermsConditionsScreen(),
            ),
          );
        },
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: menuItems.map((item) {
          final isLast = item == menuItems.last;
          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (item['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: item['color'] as Color,
                size: 24,
              ),
            ),
            title: Text(
              item['title'] as String,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.darkGreen),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.gray,
              size: 16,
            ),
            onTap: item['onTap'] as VoidCallback,
            shape: isLast
                ? null
                : const Border(
                    bottom: BorderSide(color: AppColors.lightGray, width: 1),
                  ),
          );
        }).toList(),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('المساعدة والدعم'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpSection(
                'البريد الإلكتروني',
                'support@shmalnakhedra.org',
              ),
              const SizedBox(height: 8),
              _buildHelpSection('الهاتف', '+966XXXXXXXXX'),
              const SizedBox(height: 8),
              _buildHelpSection(
                'ساعات العمل',
                'الأحد - الخميس: 9 صباحاً - 5 مساءً',
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'الأسئلة الشائعة:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('• كيف أضيف موقع نبات؟'),
              const Text(
                'اذهب إلى تبويب الكاميرا والتقط صورة للنبات',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              const Text('• كيف أرى المواقع على الخريطة؟'),
              const Text(
                'اذهب إلى تبويب الخريطة لعرض جميع المواقع',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, String value) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Text(value, textDirection: TextDirection.rtl),
        Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold), textDirection: TextDirection.rtl),
        const SizedBox(width: 8),
        Icon(Icons.info_outline, size: 16, color: AppColors.primaryGreen),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}
