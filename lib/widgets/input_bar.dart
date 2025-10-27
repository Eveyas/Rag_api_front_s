import 'package:flutter/material.dart';

class InputBar extends StatefulWidget {
  final Function(String) onSend;
  final bool disabled;
  const InputBar({super.key, required this.onSend, this.disabled = false});

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final TextEditingController _ctrl = TextEditingController();

  void _send() {
    final t = _ctrl.text.trim();
    if (t.isEmpty || widget.disabled) return;
    widget.onSend(t);
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _ctrl,
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Escribe tu pregunta...',
              ),
              onSubmitted: (_) => _send(),
              enabled: !widget.disabled,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: widget.disabled ? null : _send,
          ),
        ],
      ),
    );
  }
}
