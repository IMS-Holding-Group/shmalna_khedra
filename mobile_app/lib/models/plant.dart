class Plant {
  final int id;
  final String name;
  final String scientificName;
  final String commonNames;
  final String family;
  final String classification;
  final String environmentalImportance;
  final String uses;
  final String location;
  final String? imageUrl;

  Plant({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.commonNames,
    required this.family,
    required this.classification,
    required this.environmentalImportance,
    required this.uses,
    required this.location,
    this.imageUrl,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      scientificName: json['scientific_name'] ?? '',
      commonNames: json['common_names'] ?? '',
      family: json['family'] ?? '',
      classification: json['classification'] ?? '',
      environmentalImportance: json['environmental_importance'] ?? '',
      uses: json['uses'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientific_name': scientificName,
      'common_names': commonNames,
      'family': family,
      'classification': classification,
      'environmental_importance': environmentalImportance,
      'uses': uses,
      'location': location,
    };
  }

  // الحصول على الأسماء الشائعة كقائمة
  List<String> get commonNamesList {
    if (commonNames.isEmpty) return [];
    return commonNames.split(',').map((name) => name.trim()).toList();
  }

  // الحصول على التصنيف كقائمة
  List<String> get classificationList {
    if (classification.isEmpty) return [];
    return classification.split('|').map((item) => item.trim()).toList();
  }

  @override
  String toString() {
    return 'Plant(id: $id, name: $name, scientificName: $scientificName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Plant && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
