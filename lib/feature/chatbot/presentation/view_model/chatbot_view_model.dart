import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/clear_chat_history_usecase.dart';
import '../../domain/usecases/get_chat_history_usecase.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';
import '../state/chatbot_state.dart';

final chatbotViewModelProvider = NotifierProvider<ChatbotViewModel, ChatbotState>(ChatbotViewModel.new);

class ChatbotViewModel extends Notifier<ChatbotState> {
  late GetChatHistoryUsecase _getChatHistoryUsecase;
  late SendChatMessageUsecase _sendChatMessageUsecase;
  late ClearChatHistoryUsecase _clearChatHistoryUsecase;

  @override
  ChatbotState build() {
    _getChatHistoryUsecase = ref.read(getChatHistoryUsecaseProvider);
    _sendChatMessageUsecase = ref.read(sendChatMessageUsecaseProvider);
    _clearChatHistoryUsecase = ref.read(clearChatHistoryUsecaseProvider);
    return const ChatbotState();
  }

  Future<void> loadHistory() async {
    state = state.copyWith(status: ChatbotStatus.loading, errorMessage: null);

    final result = await _getChatHistoryUsecase();

    result.fold(
      (failure) => state = state.copyWith(status: ChatbotStatus.error, errorMessage: failure.message),
      (messages) => state = state.copyWith(status: ChatbotStatus.loaded, messages: messages),
    );
  }

  // Optimistic: the user's own message shows immediately (with a temp id)
  // rather than waiting on a round trip, since the backend only returns the
  // assistant's reply — the sender already knows what they just typed.
  Future<void> sendMessage(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty || state.status == ChatbotStatus.sending) return;

    final optimisticMessage = ChatMessageEntity(
      id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
      role: ChatRole.user,
      content: trimmed,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      status: ChatbotStatus.sending,
      messages: [...state.messages, optimisticMessage],
      errorMessage: null,
    );

    final result = await _sendChatMessageUsecase(trimmed);

    result.fold(
      (failure) => state = state.copyWith(status: ChatbotStatus.error, errorMessage: failure.message),
      (reply) => state = state.copyWith(
        status: ChatbotStatus.loaded,
        messages: [...state.messages, reply],
      ),
    );
  }

  Future<void> clearChat() async {
    final result = await _clearChatHistoryUsecase();

    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (_) => state = state.copyWith(status: ChatbotStatus.loaded, messages: []),
    );
  }
}
