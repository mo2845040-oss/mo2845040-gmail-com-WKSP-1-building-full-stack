import 'package:flutter/material.dart';
import '../config/theme.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isUser,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatTime(timestamp),
              style: TextStyle(
                color: isUser ? Colors.white70 : Colors.grey[600],
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
