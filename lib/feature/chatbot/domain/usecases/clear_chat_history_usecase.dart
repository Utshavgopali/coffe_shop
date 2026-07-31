import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../../data/repositories/chatbot_repository.dart';
import '../repositories/chatbot_repository.dart';

final clearChatHistoryUsecaseProvider = Provider<ClearChatHistoryUsecase>(
  (ref) => ClearChatHistoryUsecase(ref.read(chatbotRepositoryProvider)),
);

class ClearChatHistoryUsecase implements UsecaseWithoutParams<bool> {
  final IChatbotRepository _repository;

  ClearChatHistoryUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call() => _repository.clearHistory();
}
