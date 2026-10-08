import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreen.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'سياسة الخصوصية',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'سياسة الخصوصية - جمعية شمالنا خضراء',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                  fontFamily: 'IBMPlexSansArabic',
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'آخر تحديث: ديسمبر 2024',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.gray,
                  fontFamily: 'IBMPlexSansArabic',
                ),
              ),
              const SizedBox(height: 32),
              _buildSection(
                '1. مقدمة',
                'نحن في جمعية شمالنا خضراء نلتزم بحماية خصوصيتك وأمان بياناتك. هذه السياسة توضح كيف نقوم بجمع واستخدام وحماية معلوماتك الشخصية عند استخدامك لتطبيقنا.',
              ),
              _buildSection(
                '2. المعلومات التي نجمعها',
                '''• معلومات الهوية: اسم المستخدم، البريد الإلكتروني، كلمة المرور (مشفرة)
• معلومات الموقع: الإحداثيات الجغرافية للنباتات التي تضيفها
• الصور: صور النباتات التي ترفعها وتشاركها مع المجتمع
• معلومات الاستخدام: بيانات تفاعلك مع التطبيق والميزات المستخدمة
• معلومات الجهاز: نوع الجهاز، نظام التشغيل، معرف الجهاز''',
              ),
              _buildSection(
                '3. كيف نستخدم معلوماتك',
                '''• تقديم وتحسين خدمات التطبيق
• السماح لك بمشاركة المواقع النباتات مع المجتمع
• التواصل معك بشأن التحديثات والتحسينات
• تحليل استخدام التطبيق لتطويره
• حماية أمن البيانات ومنع الاحتيال
• الامتثال للمتطلبات القانونية''',
              ),
              _buildSection(
                '4. مشاركة المعلومات',
                '''نشارك معلوماتك فقط في الحالات التالية:
• مع المجتمع: المواقع النباتات التي تضيفها تظهر للجميع بشكل مجهول
• مع أطراف ثالثة: نستخدم خدمات خارجية موثوقة (مثل استضافة الخادم) مع ضمان حماية البيانات
• عندما يتطلب القانون ذلك

نحن لا نبيع بياناتك الشخصية لأي طرف ثالث.''',
              ),
              _buildSection(
                '5. أمان البيانات',
                '''نتخذ إجراءات أمنية متقدمة لحماية معلوماتك:
• تشفير كلمات المرور باستخدام تقنيات آمنة
• تشفير البيانات الحساسة
• الوصول المحدود للبيانات فقط للموظفين المعتمدين
• مراقبة مستمرة للأمان''',
              ),
              _buildSection('6. حقوقك', '''لديك الحق في:
• الوصول إلى بياناتك الشخصية
• تصحيح أو تحديث بياناتك
• حذف حسابك وبياناتك
• الاعتراض على معالجة بياناتك
• نقل بياناتك

للقيام بأي من هذه الإجراءات، اتصل بنا عبر البريد الإلكتروني.'''),
              _buildSection(
                '7. ملفات تعريف الارتباط (Cookies)',
                '''قد نستخدم تقنيات مشابهة لملفات تعريف الارتباط لتحسين تجربة استخدامك، لكن هذه البيانات مجهولة ولا يمكن التعرف عليك من خلالها.''',
              ),
              _buildSection(
                '8. التغييرات على السياسة',
                '''نحتفظ بالحق في تحديث هذه السياسة. سيتم إشعارك بأي تغييرات جوهرية عبر التطبيق أو البريد الإلكتروني. ننصحك بمراجعة هذه الصفحة بانتظام.''',
              ),
              _buildSection(
                '9. سن الحساب',
                'خدماتنا متاحة للمستخدمين الذين تجاوزوا سن 13 عاماً. إذا كان عمرك أقل من 13 عاماً، يجب الحصول على موافقة والديك.'
                    '',
              ),
              _buildSection(
                '10. الاتصال بنا',
                '''إذا كان لديك أي أسئلة أو استفسارات حول سياسة الخصوصية، يرجى التواصل معنا:
البريد الإلكتروني: info@shmalnakhedra.org
الهاتف: +966XXXXXXXXX
الموقع الإلكتروني: www.shmalnakhedra.org''',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
              fontFamily: 'IBMPlexSansArabic',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.8,
              fontFamily: 'IBMPlexSansArabic',
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
