import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AssociationInfoScreen extends StatefulWidget {
  const AssociationInfoScreen({super.key});

  @override
  State<AssociationInfoScreen> createState() => _AssociationInfoScreenState();
}

class _AssociationInfoScreenState extends State<AssociationInfoScreen> {
  String? _associationText;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssociationInfo();
  }

  Future<void> _loadAssociationInfo() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _associationText = _getDefaultText();
      _isLoading = false;
    });
  }

  String _getDefaultText() {
    return '''جمعية حُزُم الشمال البيئية

عرعر 22 ربيع الآخر 1447 هـ الموافق 14 أكتوبر 2025 م

دشَّن صاحب السمو الملكي الأمير فيصل بن خالد بن سلطان بن عبدالعزيز، أمير منطقة الحدود الشمالية، في مكتبه اليوم، أعمال ومبادرات جمعية "حُزُم الشمال" البيئية بمدينة عرعر، ضمن حزمةٍ من البرامج النوعية التي تُسهم في تعزيز الاستدامة البيئية، ورفع الوعي المجتمعي بالممارسات الصديقة للبيئة، بحضور مدير عام فرع وزارة البيئة والمياه والزراعة بالمنطقة المهندس بندر بن صالح الهدية، ورئيس مجلس إدارة الجمعية الدكتور مدالله بن الركوي العنزي، وعددٍ من أعضاء مجلس الإدارة.

واطَّلع على أبرز المبادرات التي تُنفّذها الجمعية في مجالات التشجير وتنمية الغطاء النباتي، وحماية الموارد الطبيعية، وما تتضمنه من برامج توعوية وتطوعية تهدف إلى ترسيخ السلوك البيئي الإيجابي في المجتمع.

وأشاد أمير منطقة الحدود الشمالية بأهمية الدور الذي تؤديه الجمعيات البيئية في دعم مستهدفات إستراتيجية البيئة ورؤية المملكة 2030، مؤكّدًا أن التنمية المستدامة وحماية الموارد الطبيعية تمثّلان ركيزةً أساسية في نهج القيادة الحكيمة الرامي إلى تحسين جودة الحياة وصون مقدّرات الوطن للأجيال القادمة.

الأهداف والبرامج:
• تعزيز الاستدامة البيئية
• رفع الوعي المجتمعي بالممارسات الصديقة للبيئة
• التشجير وتنمية الغطاء النباتي
• حماية الموارد الطبيعية
• البرامج التوعوية والتطوعية
• ترسيخ السلوك البيئي الإيجابي في المجتمع
• دعم مستهدفات إستراتيجية البيئة ورؤية المملكة 2030''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreen.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'معلومات الجمعية',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGreen,
                ),
              ),
            )
          : SingleChildScrollView(
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
                    // الشعاران جنباً إلى جنب
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // الشعار الأول (بالحجم الكامل)
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryGreen.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/Logo2.jpeg',
                                width: 110,
                                height: 110,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.lightGreen,
                                    child: const Icon(
                                      Icons.eco,
                                      size: 55,
                                      color: AppColors.primaryGreen,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // الشعار الثاني (الجمعية)
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryGreen.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/Logo.jpeg',
                                width: 110,
                                height: 110,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.lightGreen,
                                    child: const Icon(
                                      Icons.eco,
                                      size: 55,
                                      color: AppColors.primaryGreen,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // العنوان
                    Center(
                      child: Text(
                        'جمعية حُزُم الشمال البيئية',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IBMPlexSansArabic',
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // العنوان الفرعي
                    Center(
                      child: Text(
                        'تعزيز الاستدامة البيئية ورفع الوعي المجتمعي',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.mediumGreen,
                              fontFamily: 'IBMPlexSansArabic',
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),

                    // المحتوى
                    Text(
                      _associationText ?? _getDefaultText(),
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
              ),
            ),
    );
  }
}
