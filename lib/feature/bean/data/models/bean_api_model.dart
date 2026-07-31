import '../../domain/entities/bean_entity.dart';

class BeanApiModel {
  final String id;
  final String name;
  final String description;
  final String origin;
  final String roastLevel;
  final String process;
  final String category;
  final List<String> tastingNotes;
  final int weightGrams;
  final double price;
  final int stock;
  final List<String> images;
  final bool featured;
  final DateTime? createdAt;

  const BeanApiModel({
    required this.id,
    required this.name,
    required this.description,
    required this.origin,
    required this.roastLevel,
    required this.process,
    required this.category,
    required this.tastingNotes,
    required this.weightGrams,
    required this.price,
    required this.stock,
    required this.images,
    required this.featured,
    this.createdAt,
  });

  factory BeanApiModel.fromJson(Map<String, dynamic> json) {
    return BeanApiModel(
      id: (json['id'] ?? json['_id']) as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      roastLevel: json['roastLevel'] as String? ?? 'medium',
      process: json['process'] as String? ?? 'washed',
      category: json['category'] as String? ?? 'single-origin',
      tastingNotes: json['tastingNotes'] != null
          ? List<String>.from(json['tastingNotes'] as List)
          : <String>[],
      weightGrams: (json['weightGrams'] as num?)?.toInt() ?? 250,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : <String>[],
      featured: json['featured'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  BeanEntity toEntity() {
    return BeanEntity(
      id: id,
      name: name,
      description: description,
      origin: origin,
      roastLevel: roastLevel,
      process: process,
      category: category,
      tastingNotes: tastingNotes,
      weightGrams: weightGrams,
      price: price,
      stock: stock,
      images: images,
      featured: featured,
      createdAt: createdAt,
    );
  }
}
