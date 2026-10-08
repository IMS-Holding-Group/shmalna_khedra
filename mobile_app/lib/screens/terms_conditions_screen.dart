import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreen.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'شروط الاستخدام',
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
                'شروط وأحكام الاستخدام - جمعية شمالنا خضراء',
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
                '1. قبول الشروط',
                'باستخدامك تطبيق شمالنا خضراء، فإنك توافق على الالتزام بهذه الشروط والأحكام. إذا لم توافق على هذه الشروط، يرجى عدم استخدام التطبيق.',
              ),
              _buildSection(
                '2. تعريف الخدمة',
                '''تطبيق شمالنا خضراء هو منصة مجتمعية تتيح للمستخدمين:
• التعرف على النباتات البرية في منطقة عرعر
• إضافة وتوثيق مواقع النباتات على الخريطة
• مشاركة الصور والمعلومات مع المجتمع
• الاستفادة من قاعدة بيانات شاملة عن النباتات المحلية''',
              ),
              _buildSection('3. سن المستخدمين', '''يجب أن تكون:
• تجاوزت 13 عاماً على الأقل
• أو لديك موافقة والديك إذا كنت تحت سن 18 عاماً
• مخولاً قانونياً للدخول في اتفاقية ملزمة'''),
              _buildSection('4. إنشاء الحساب', '''عند إنشاء حساب، تقر بأنك:
• تقدم معلومات دقيقة وصحيحة
• تحافظ على تحديث معلوماتك
• تحافظ على سرية كلمة المرور
• تتحمل المسؤولية عن جميع الأنشطة في حسابك
• تخطرنا فوراً بأي استخدام غير مصرح به'''),
              _buildSection('5. قواعد السلوك', '''يجب عليك:
• استخدام التطبيق لغايات قانونية ومشروعة فقط
• احترام جميع المستخدمين الآخرين
• عدم نشر محتوى مسيء أو غير قانوني
• عدم الانتحال أو انتهاك حقوق الملكية الفكرية
• عدم محاولة الوصول غير المصرح به للنظام
• عدم إعاقة أو تعطيل عمل التطبيق'''),
              _buildSection(
                '6. المحتوى المستخدم',
                '''• أنت تحتفظ بحقوق الملكية الفكرية للمحتوى الذي تضيفه
• باضافة محتوى، تمنحنا ترخيصاً لاستخدامه وعرضه على التطبيق
• نتأكد من دقة المعلومات المضافة قدر الإمكان
• نحتفظ بالحق في حذف أي محتوى يخالف القواعد''',
              ),
              _buildSection('7. الموقع والصورة', '''عند إضافة موقع نبات:
• يجب أن يكون الموقع دقيقاً وواقعياً
• الصور يجب أن تكون للنبات الفعلي في ذلك الموقع
• نحن لسنا مسؤولين عن أي أضرار قد تنتج من زيارة المواقع
• يتحمل المستخدم المسؤولية عن سلامة رحلاته للمواقع'''),
              _buildSection(
                '8. البيانات المحلية',
                '''• نحن نستخدم موقعك الجغرافي لتوثيق مواقع النباتات
• الموقع يظهر فقط على الخريطة العامة ولا يكشف عن مكان سكنك الدقيق
• يمكنك إيقاف مشاركة الموقع من إعدادات جهازك''',
              ),
              _buildSection(
                '9. الملكية الفكرية',
                '''جميع حقوق الملكية في التطبيق وبياناته محفوظة لجمعية شمالنا خضراء. لا يجوز:
• نسخ أو توزيع أو نقل التطبيق أو أجزائه
• عكس هندسة أو تحليل التطبيق
• استخدام المحتوى لأغراض تجارية بدون ترخيص''',
              ),
              _buildSection(
                '10. إيقاف الحساب',
                '''يمكننا إيقاف أو تعليق حسابك فوراً إذا:
• انتهكت هذه الشروط
• استخدمت التطبيق بطريقة غير قانونية
• أضرت بالآخرين أو بالخدمة
• انخرطت في سلوك ضار أو مسيء

يمكنك إلغاء حسابك في أي وقت من إعدادات الملف الشخصي.''',
              ),
              _buildSection(
                '11. المسؤولية',
                '''نحن نقدم التطبيق "كما هو". نحن غير مسؤولين عن:
• أخطاء في بيانات أو مواقع النباتات
• أي أضرار تنتج من استخدام التطبيق
• أي معلومات غير دقيقة أو مضللة
• فقدان أو تلف البيانات
• أذى قد يصيب المستخدم عند زيارة المواقع

استخدام التطبيق على مسؤوليتك الخاصة.''',
              ),
              _buildSection('12. التعديلات على الخدمة', '''نحتفظ بالحق في:
• تعديل أو إيقاف التطبيق في أي وقت
• إضافة أو حذف الميزات
• تعديل الشروط والأحكام

سيتم إشعارك بالتغييرات الجوهرية.'''),
              _buildSection(
                '13. قانون المنطقة',
                'هذه الشروط تحكمها قوانين المملكة العربية السعودية. أي نزاع يعرض على محاكم المملكة.',
              ),
              _buildSection(
                '14. التنازل عن الشروط',
                'إذا لم نتمسك بحق معين من هذه الشروط في حال معينة، هذا لا يعني أننا نتخلى عن هذا الحق.',
              ),
              _buildSection('15. الاتصال', '''للاستفسارات أو المشاكل، اتصل بنا:
البريد الإلكتروني: support@shmalnakhedra.org
الهاتف: +966XXXXXXXXX'''),
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
