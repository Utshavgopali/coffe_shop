import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../models/chat_message_api_model.dart';
import '../chatbot_datasource.dart';

final chatbotRemoteDatasourceProvider = Provider<IChatbotRemoteDataSource>(
  (ref) => ChatbotRemoteDatasource(apiClient: ref.read(apiClientProvider)),
);

class ChatbotRemoteDatasource implements IChatbotRemoteDataSource {
  final ApiClient apiClient;

  ChatbotRemoteDatasource({required this.apiClient});

  @override
  Future<List<ChatMessageApiModel>> getHistory() async {
    final response = await apiClient.get(ApiEndpoints.chatbot);
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((json) => ChatMessageApiModel.fromJson(json)).toList();
  }

  @override
  Future<ChatMessageApiModel> sendMessage(String message) async {
    final response = await apiClient.post(ApiEndpoints.chatbot, data: {'message': message});
    return ChatMessageApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> clearHistory() async {
    await apiClient.delete(ApiEndpoints.chatbot);
  }
}
