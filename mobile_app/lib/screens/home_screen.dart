import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/plant_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/plant_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/filter_chips.dart';
import 'plant_detail_screen.dart';
import 'association_info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _associationText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlantProvider>(context, listen: false).loadPlants();
      _loadAssociationInfo();
    });
  }

  Future<void> _loadAssociationInfo() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.spa.gov.sa/N2420595'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _associationText = _extractTextFromHtml(response.body);
        });
      }
    } catch (e) {
      debugPrint('خطأ في جلب معلومات الجمعية: $e');
      setState(() {
        _associationText =
            'جمعية شمالنا خضراء هي جمعية بيئية تعمل على الحفاظ على النباتات البرية في منطقة عرعر وتعزيز الوعي البيئي في المجتمع.';
      });
    }
  }

  String _extractTextFromHtml(String html) {
    // إزالة HTML tags بسيطة
    String text = html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    // جلب أول 500 حرف
    if (text.length > 500) {
      text = '${text.substring(0, 500)}...';
    }

    return text;
  }

  void _showAssociationInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AssociationInfoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.lightGradient),
        child: SafeArea(
          child: Column(
            children: [
              // شريط البحث مع أيقونة معلومات
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.info_outline,
                          color: AppColors.white,
                        ),
                        onPressed: _showAssociationInfo,
                        tooltip: 'معلومات الجمعية',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomSearchBar(
                        onSearchChanged: (query) {
                          Provider.of<PlantProvider>(
                            context,
                            listen: false,
                          ).updateSearchQuery(query);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // قسم "خلي بيئتنا خضراء"
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryGreen, AppColors.mediumGreen],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    // الشعاران جنباً إلى جنب
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        // الشعار الأول (بالحجم الكامل)
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/Logo2.jpeg',
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.lightGreen,
                                  child: const Icon(
                                    Icons.eco,
                                    size: 40,
                                    color: AppColors.primaryGreen,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // الشعار الثاني (الجمعية)
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/Logo.jpeg',
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.lightGreen,
                                  child: const Icon(
                                    Icons.eco,
                                    size: 40,
                                    color: AppColors.primaryGreen,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            'خلي بيئتنا خضراء',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'اكتشف النباتات البرية في عرعر وساهم في الحفاظ على البيئة',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.lightGreen),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // فلاتر النباتات
              Consumer<PlantProvider>(
                builder: (context, plantProvider, child) {
                  return FilterChips(
                    filters: plantProvider.availableFilters,
                    selectedFilter: plantProvider.selectedFilter,
                    onFilterChanged: (filter) {
                      plantProvider.updateSelectedFilter(filter);
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // قائمة النباتات
              Expanded(
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

                    if (plantProvider.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: AppColors.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              plantProvider.error!,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.error),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                plantProvider.loadPlants();
                              },
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      );
                    }

                    final plants = plantProvider.filteredPlants;

                    if (plants.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: AppColors.gray,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد نباتات تطابق البحث',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.gray),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: plants.length,
                      itemBuilder: (context, index) {
                        final plant = plants[index];
                        return PlantCard(
                          plant: plant,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlantDetailScreen(plant: plant),
                              ),
                            );
                          },
                        );
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
}
