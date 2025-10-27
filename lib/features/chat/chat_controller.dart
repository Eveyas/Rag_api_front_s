import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models.dart';
import 'chat_repository.dart';

class ChatController extends ChangeNotifier {
  final ChatRepository repository;
  ThemeMode themeMode = ThemeMode.system;

  ChatController({required apiClient})
    : repository = ChatRepository(apiClient: apiClient) {
    themeMode = ThemeMode.system;
  }

  final List<Message> _messages = [];
  List<Message> get messages => List.unmodifiable(_messages);

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

final _uuid = Uuid();

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  Future<void> send(String text) async {
    if (text.trim().isEmpty || _loading) return;
    final userMsg = Message(id: _uuid.v4(), role: 'user', content: text.trim());
    _messages.add(userMsg);
    _loading = true;
    _error = null;
    notifyListeners();

    final history = _messages.map((m) => m.toMap()).toList();

    try {
      final assistantMsg = Message(
        id: _uuid.v4(),
        role: 'assistant',
        content: '',
      );
      _messages.add(assistantMsg);
      notifyListeners();

      final stream = repository.askStream(text.trim(), history);
      final buffer = StringBuffer();

      final completer = Completer<void>();
      final sub = stream.listen(
        (chunk) {
          buffer.write(chunk);
          assistantMsg.content = buffer.toString();
          notifyListeners();
        },
        onDone: () {
          completer.complete();
        },
        onError: (e) {
          completer.completeError(e);
        },
      );

      await completer.future.timeout(
        const Duration(seconds: 25),
        onTimeout: () async {
          await sub.cancel();
          final fallback = await repository.ask(text.trim(), history);
          assistantMsg.content = fallback;
          notifyListeners();
        },
      );

      await sub.cancel();
    } catch (e) {
      _error = 'Error al conectar: ${e.toString()}';
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}