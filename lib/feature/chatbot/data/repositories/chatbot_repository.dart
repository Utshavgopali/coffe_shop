import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivitly/network_info.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../datasources/chatbot_datasource.dart';
import '../datasources/remote/chatbot_remote_datasource.dart';

final chatbotRepositoryProvider = Provider<IChatbotRepository>(
  (ref) => ChatbotRepository(
    remoteDatasource: ref.read(chatbotRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  ),
);

class ChatbotRepository implements IChatbotRepository {
  final IChatbotRemoteDataSource _remoteDatasource;
  final NetworkInfo _networkInfo;

  ChatbotRepository({
    required IChatbotRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getHistory() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection. Connect to load your chat.'));
    }
    try {
      final result = await _remoteDatasource.getHistory();
      return Right(result.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to load chat history',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage(String message) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection. Connect to chat with the assistant.'));
    }
    try {
      final result = await _remoteDatasource.sendMessage(message);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'The assistant could not respond right now',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> clearHistory() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }
    try {
      await _remoteDatasource.clearHistory();
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data?['message'] ?? 'Failed to clear chat history',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
