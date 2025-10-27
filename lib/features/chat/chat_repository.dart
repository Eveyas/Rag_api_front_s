import '../../core/api_client.dart';

class ChatRepository {
  final ApiClient apiClient;
  ChatRepository({required this.apiClient});

  Future<String> ask(String message, List<Map<String, String>> history) =>
      apiClient.ask(message, history);
  Stream<String> askStream(String message, List<Map<String, String>> history) =>
      apiClient.askStream(message, history);
  Future<bool> health() => apiClient.health();
}
