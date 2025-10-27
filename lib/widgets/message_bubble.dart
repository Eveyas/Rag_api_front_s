import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String role; // 'user' | 'assistant'
  final String content;
  const MessageBubble({super.key, required this.role, required this.content});

  @override
  Widget build(BuildContext context) {
    final isUser = role == 'user';
    final color = isUser
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).cardColor;
    final textColor = isUser ? Colors.white : null;

    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
              ],
            ),
            child: Text(content.isEmpty ? '...' : content,
                style: TextStyle(color: textColor)),
          ),
        ),
      ],
    );
  }
}
