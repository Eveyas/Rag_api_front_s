import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_controller.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/input_bar.dart';
import '../../widgets/typing_indicator.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Provider.of<ChatController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot RAG'),
        actions: [
          IconButton(
            icon: Icon(
              ctrl.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => ctrl.toggleTheme(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: ctrl.messages.length + (ctrl.loading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < ctrl.messages.length) {
                    final m = ctrl.messages[index];
                    return MessageBubble(
                      role: m.role,
                      content: m.content,
                    );
                  }
                  return const TypingIndicator();
                },
              ),
            ),
            if (ctrl.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(child: Text(ctrl.error!)),
                  ],
                ),
              ),
            InputBar(
              onSend: (text) => ctrl.send(text),
              disabled: ctrl.loading,
            ),
          ],
        ),
      ),
    );
  }
}