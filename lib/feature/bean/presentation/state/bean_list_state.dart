import 'package:equatable/equatable.dart';

import '../../domain/entities/bean_entity.dart';
import '../../domain/entities/bean_facets_entity.dart';

enum BeanListStatus { initial, loading, loaded, error }

class BeanListState extends Equatable {
  final BeanListStatus status;
  final List<BeanEntity> beans;
  final BeanFacetsEntity facets;
  final String selectedCategory; // '' means "All"
  final String selectedRoastLevel; // '' means "All"
  final String searchQuery;
  final int page;
  final int totalPages;
  final String? errorMessage;

  const BeanListState({
    this.status = BeanListStatus.initial,
    this.beans = const [],
    this.facets = const BeanFacetsEntity(),
    this.selectedCategory = '',
    this.selectedRoastLevel = '',
    this.searchQuery = '',
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  BeanListState copyWith({
    BeanListStatus? status,
    List<BeanEntity>? beans,
    BeanFacetsEntity? facets,
    String? selectedCategory,
    String? selectedRoastLevel,
    String? searchQuery,
    int? page,
    int? totalPages,
    String? errorMessage,
  }) {
    return BeanListState(
      status: status ?? this.status,
      beans: beans ?? this.beans,
      facets: facets ?? this.facets,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedRoastLevel: selectedRoastLevel ?? this.selectedRoastLevel,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        beans,
        facets,
        selectedCategory,
        selectedRoastLevel,
        searchQuery,
        page,
        totalPages,
        errorMessage,
      ];
}
