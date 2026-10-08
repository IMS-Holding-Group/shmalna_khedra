import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import 'association_info_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'title': 'بيانات المستخدم',
        'icon': Icons.person_outline,
        'color': AppColors.primaryGreen,
        'onTap': () {
          _showUserDataDialog(context);
        },
      },
      {
        'title': 'الإشعارات',
        'icon': Icons.notifications_outlined,
        'color': AppColors.info,
        'onTap': () {
          _showNotificationsSettings(context);
        },
      },
      {
        'title': 'الموقع الجغرافي',
        'icon': Icons.location_on_outlined,
        'color': AppColors.success,
        'onTap': () {
          _showLocationSettings(context);
        },
      },
      {
        'title': 'اللغة',
        'icon': Icons.language_outlined,
        'color': AppColors.warning,
        'onTap': () {
          _showLanguageDialog(context);
        },
      },
      {
        'title': 'حجم البيانات',
        'icon': Icons.storage_outlined,
        'color': AppColors.mediumGreen,
        'onTap': () {
          _showDataSettings(context);
        },
      },
      {
        'title': 'حول التطبيق',
        'icon': Icons.info_outline,
        'color': AppColors.primaryGreen,
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
        'color': AppColors.info,
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
        'color': AppColors.warning,
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

    return Scaffold(
      backgroundColor: AppColors.lightGreen.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'الإعدادات',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          final isLast = index == menuItems.length - 1;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: item['color'] as Color,
                  size: 24,
                ),
              ),
              title: Text(
                item['title'] as String,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'IBMPlexSansArabic',
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.gray,
              ),
              onTap: item['onTap'] as VoidCallback,
              shape: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(
                        color: AppColors.lightGray,
                        width: 0.5,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  void _showUserDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'بيانات المستخدم',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        content: const Text(
          'مرحباً بك في تطبيق شمالنا خضراء. البيانات التي نستخدمها محدودة وتشمل اسم المستخدم والبريد الإلكتروني للمصادقة فقط. نحن لا نشارك بياناتك مع أطراف ثالثة.',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('فهمت'),
          ),
        ],
      ),
    );
  }

  void _showNotificationsSettings(BuildContext context) {
    bool notifsEnabled = true;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'إعدادات الإشعارات',
            style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text(
                  'تفعيل الإشعارات',
                  style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
                ),
                value: notifsEnabled,
                onChanged: (value) {
                  setState(() {
                    notifsEnabled = value;
                  });
                },
              ),
              const Text(
                'سيتم إشعارك عند إضافة مواقع جديدة وتحديثات التطبيق.',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.gray,
                  fontFamily: 'IBMPlexSansArabic',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حفظ الإعدادات'),
                    backgroundColor: AppColors.success,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'إعدادات الموقع',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        content: const Text(
          'يتطلب التطبيق الوصول إلى موقعك لإضافة مواقع النباتات على الخريطة. الموقع يظهر فقط على الخريطة العامة ولا يكشف عن عنوان سكنك الدقيق.',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('فهمت'),
          ),
          ElevatedButton(
            onPressed: () {
              // إعدادات الموقع من النظام
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('يرجى تعديل إعدادات الموقع من إعدادات الجهاز'),
                  backgroundColor: AppColors.info,
                ),
              );
              Navigator.of(context).pop();
            },
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'اللغة',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        content: const Text(
          'التطبيق متوفر حالياً باللغة العربية فقط. نعمل على إضافة لغات أخرى قريباً.',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
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

  void _showDataSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'حجم البيانات',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataItem('صور التطبيق', '15 MB'),
            _buildDataItem('الخرائط', '10 MB'),
            _buildDataItem('قاعدة البيانات المحلية', '5 MB'),
            const Divider(),
            _buildDataItem('المجموع', '30 MB'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('جاري حذف البيانات المخزنة محلياً...'),
                  backgroundColor: AppColors.info,
                ),
              );
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('مسح البيانات'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String label, String size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'IBMPlexSansArabic')),
          Text(
            size,
            style: const TextStyle(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
