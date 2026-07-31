import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/bean_entity.dart';
import '../entities/bean_facets_entity.dart';

class BeanListResult {
  final List<BeanEntity> beans;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const BeanListResult({
    required this.beans,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
}

abstract interface class IBeanRepository {
  Future<Either<Failure, BeanListResult>> getBeans({
    int page,
    int limit,
    String search,
    String category,
    List<String> roastLevel,
    List<String> origin,
    double? minPrice,
    double? maxPrice,
    bool? featured,
    String sort,
  });

  Future<Either<Failure, BeanEntity>> getBeanById(String id);

  Future<Either<Failure, BeanFacetsEntity>> getFacets({String? category});
}
