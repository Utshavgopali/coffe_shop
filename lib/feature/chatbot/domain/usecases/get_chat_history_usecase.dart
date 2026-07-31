import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/chatbot_repository.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/chatbot_repository.dart';

final getChatHistoryUsecaseProvider = Provider<GetChatHistoryUsecase>(
  (ref) => GetChatHistoryUsecase(ref.read(chatbotRepositoryProvider)),
);

class GetChatHistoryUsecase implements UsecaseWithoutParams<List<ChatMessageEntity>> {
  final IChatbotRepository _repository;

  GetChatHistoryUsecase(this._repository);

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> call() => _repository.getHistory();
}
