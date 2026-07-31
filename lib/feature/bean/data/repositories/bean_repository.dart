import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivitly/network_info.dart';
import '../../domain/entities/bean_entity.dart';
import '../../domain/entities/bean_facets_entity.dart';
import '../../domain/repositories/bean_repository.dart';
import '../datasources/bean_datasource.dart';
import '../datasources/remote/bean_remote_datasource.dart';

final beanRepositoryProvider = Provider<IBeanRepository>(
  (ref) => BeanRepository(
    remoteDataSource: ref.read(beanRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  ),
);

class BeanRepository implements IBeanRepository {
  final IBeanRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BeanRepository({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, BeanListResult>> getBeans({
    int page = 1,
    int limit = 12,
    String search = '',
    String category = '',
    List<String> roastLevel = const [],
    List<String> origin = const [],
    double? minPrice,
    double? maxPrice,
    bool? featured,
    String sort = '',
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to browse beans.'),
      );
    }

    try {
      final result = await remoteDataSource.getBeans(
        page: page,
        limit: limit,
        search: search,
        category: category,
        roastLevel: roastLevel,
        origin: origin,
        minPrice: minPrice,
        maxPrice: maxPrice,
        featured: featured,
        sort: sort,
      );

      return Right(
        BeanListResult(
          beans: result.beans.map((m) => m.toEntity()).toList(),
          page: result.page,
          limit: result.limit,
          total: result.total,
          totalPages: result.totalPages,
        ),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to fetch beans',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BeanEntity>> getBeanById(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection. Connect to view this bean.'),
      );
    }

    try {
      final result = await remoteDataSource.getBeanById(id);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Bean not found',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BeanFacetsEntity>> getFacets({String? category}) async {
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection.'),
      );
    }

    try {
      final result = await remoteDataSource.getFacets(category: category);
      return Right(
        BeanFacetsEntity(
          roastLevel: result['roastLevel'] ?? const {},
          origin: result['origin'] ?? const {},
          weightGrams: result['weightGrams'] ?? const {},
        ),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to fetch filters',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
