import '../models/bean_api_model.dart';

class BeanRemoteListResult {
  final List<BeanApiModel> beans;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const BeanRemoteListResult({
    required this.beans,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
}

abstract interface class IBeanRemoteDataSource {
  Future<BeanRemoteListResult> getBeans({
    required int page,
    required int limit,
    required String search,
    required String category,
    required List<String> roastLevel,
    required List<String> origin,
    double? minPrice,
    double? maxPrice,
    bool? featured,
    required String sort,
  });

  Future<BeanApiModel> getBeanById(String id);

  Future<Map<String, Map<String, int>>> getFacets({String? category});
}
