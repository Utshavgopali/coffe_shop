import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/chatbot_repository.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/chatbot_repository.dart';

final sendChatMessageUsecaseProvider = Provider<SendChatMessageUsecase>(
  (ref) => SendChatMessageUsecase(ref.read(chatbotRepositoryProvider)),
);

class SendChatMessageUsecase implements UsecaseWithParams<ChatMessageEntity, String> {
  final IChatbotRepository _repository;

  SendChatMessageUsecase(this._repository);

  @override
  Future<Either<Failure, ChatMessageEntity>> call(String message) => _repository.sendMessage(message);
}
