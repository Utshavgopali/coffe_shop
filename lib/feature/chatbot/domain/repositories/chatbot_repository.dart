import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/chat_message_entity.dart';

abstract interface class IChatbotRepository {
  Future<Either<Failure, List<ChatMessageEntity>>> getHistory();

  Future<Either<Failure, ChatMessageEntity>> sendMessage(String message);

  Future<Either<Failure, bool>> clearHistory();
}
