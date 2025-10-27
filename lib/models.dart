class Message {
  final String id;
  final String role; // 'user' | 'assistant'
  String content;

  Message({required this.id, required this.role, required this.content});

  Map<String, String> toMap() => {'role': role, 'content': content};
}
