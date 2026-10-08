import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../utils/app_colors.dart';
import '../utils/api_config.dart';

class PlantDetailScreen extends StatefulWidget {
  final Plant plant;

  const PlantDetailScreen({super.key, required this.plant});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  String _baseUrl = 'http://10.0.2.2:3000'; // قيمة افتراضية

  @override
  void initState() {
    super.initState();
    _loadBaseUrl();
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
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // شريط التطبيق مع الصورة
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: AppColors.primaryGreen,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // صورة النبات
                    widget.plant.imageUrl != null
                        ? Image.network(
                            '$_baseUrl${widget.plant.imageUrl}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.primaryGreen,
                                      AppColors.mediumGreen,
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.eco,
                                    size: 120,
                                    color: AppColors.white.withOpacity(0.3),
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.primaryGreen,
                                  AppColors.mediumGreen,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.eco,
                                size: 120,
                                color: AppColors.white.withOpacity(0.3),
                              ),
                            ),
                          ),
                    // تدرج لوني من الأسفل لتحسين قراءة النص
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.primaryGreen.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // محتوى الشاشة
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم النبتة والاسم العلمي
                      Text(
                        widget.plant.name,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        widget.plant.scientificName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.mediumGreen,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // الأسماء الشائعة
                      if (widget.plant.commonNames.isNotEmpty) ...[
                        _buildInfoSection(
                          context,
                          'الأسماء الشائعة',
                          widget.plant.commonNames,
                          Icons.label_outline,
                        ),
                        const SizedBox(height: 16),
                      ],

                      // الفصيلة
                      _buildInfoSection(
                        context,
                        'الفصيلة',
                        widget.plant.family,
                        Icons.category_outlined,
                      ),

                      const SizedBox(height: 16),

                      // التصنيف
                      _buildInfoSection(
                        context,
                        'التصنيف',
                        widget.plant.classification,
                        Icons.account_tree_outlined,
                      ),

                      const SizedBox(height: 24),

                      // الأهمية البيئية
                      _buildDetailSection(
                        context,
                        'الأهمية البيئية',
                        widget.plant.environmentalImportance,
                        Icons.eco,
                        AppColors.success,
                      ),

                      const SizedBox(height: 24),

                      // الاستخدامات
                      _buildDetailSection(
                        context,
                        'الاستخدامات',
                        widget.plant.uses,
                        Icons.medical_services_outlined,
                        AppColors.info,
                      ),

                      const SizedBox(height: 24),

                      // أماكن التواجد
                      _buildDetailSection(
                        context,
                        'أماكن التواجد',
                        widget.plant.location,
                        Icons.location_on_outlined,
                        AppColors.warning,
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
  ) {
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.darkGray),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Icon(icon, color: AppColors.primaryGreen, size: 20),
      ],
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color iconColor,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.darkGray,
              height: 1.6,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
