class CommunityPin {
  final int id;
  final int? userId;
  final String plantName;
  final double lat;
  final double lng;
  final String? imagePath;
  final String? comment;
  final DateTime? createdAt;
  final String? username;

  CommunityPin({
    required this.id,
    this.userId,
    required this.plantName,
    required this.lat,
    required this.lng,
    this.imagePath,
    this.comment,
    this.createdAt,
    this.username,
  });

  factory CommunityPin.fromJson(Map<String, dynamic> json) {
    return CommunityPin(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      plantName: json['plant_name'] ?? '',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
      imagePath: json['image_path'],
      comment: json['comment'],
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plant_name': plantName,
      'lat': lat,
      'lng': lng,
      'image_path': imagePath,
      'comment': comment,
      'created_at': createdAt?.toIso8601String(),
      'username': username,
    };
  }

  @override
  String toString() {
    return 'CommunityPin(id: $id, plantName: $plantName, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CommunityPin && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
