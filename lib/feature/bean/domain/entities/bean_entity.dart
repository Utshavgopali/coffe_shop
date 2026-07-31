import 'package:equatable/equatable.dart';

class BeanEntity extends Equatable {
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

  const BeanEntity({
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

  bool get inStock => stock > 0;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        origin,
        roastLevel,
        process,
        category,
        tastingNotes,
        weightGrams,
        price,
        stock,
        images,
        featured,
        createdAt,
      ];
}
