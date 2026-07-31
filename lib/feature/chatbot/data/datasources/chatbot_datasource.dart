import '../models/chat_message_api_model.dart';

abstract interface class IChatbotRemoteDataSource {
  Future<List<ChatMessageApiModel>> getHistory();

  Future<ChatMessageApiModel> sendMessage(String message);

  Future<void> clearHistory();
}
