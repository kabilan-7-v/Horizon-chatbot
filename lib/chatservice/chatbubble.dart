import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {super.key, required this.isCurrentuser, required this.message});
  final String message;
  final bool isCurrentuser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
            isCurrentuser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isCurrentuser)
            const Spacer(), // Spacer for sent message alignment
          Container(
            constraints: BoxConstraints(maxWidth: 250.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(isCurrentuser ? 16.0 : 0.0),
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(isCurrentuser ? 0.0 : 16.0),
              ),
              color: isCurrentuser
                  ? Colors.amber[600]
                  : const Color.fromARGB(255, 19, 16, 16),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
          if (!isCurrentuser)
            const Spacer(), // Spacer for received message alignment
        ],
      ),
    );
  }
}
