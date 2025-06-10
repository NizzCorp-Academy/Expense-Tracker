import 'package:expense_trackerl_ite/features/chat_support/presentation/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpenseWebSocketChatDialog extends StatefulWidget {
  const ExpenseWebSocketChatDialog({super.key});

  @override
  State<ExpenseWebSocketChatDialog> createState() =>
      _ExpenseWebSocketChatDialogState();
}

class _ExpenseWebSocketChatDialogState
    extends State<ExpenseWebSocketChatDialog> {
  final WebSocketService _webSocketService = WebSocketService();
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _webSocketService.setOnMessageHandler((msg) {
      setState(() {
        _messages.add('Rob: $msg');
      });
    });
    _webSocketService.connect();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      _webSocketService.send(text);
      setState(() {
        _messages.add('Me: $text');
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Text(
            'Customer Support',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final message = _messages[i];

                return Align(
                  alignment:
                      message.startsWith('Me:') ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: message.startsWith('Me:') ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message
                          .replaceFirst('Me:', '')
                          .replaceFirst('Rob:', '')
                          .trim(),
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Type your message...",
                    hintStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black26,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 10,
                    ),
                  ),
                ),
              ),
              IconButton(onPressed: _sendMessage, icon: const Icon(Icons.send)),
            ],
          ),
        ],
      ),
    );
  }
}
