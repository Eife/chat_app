 import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBar({
    Key? key,
    required this.controller,
    required this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Row(
        children: [
          IconButton(
            onPressed: () {}, // Здесь может быть логика для добавления вложений
            icon: Icon(Icons.attachment),
            hoverColor: Color.fromARGB(255, 218, 217, 217),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Сообщение",
                filled: true,
                fillColor: Color.fromARGB(255, 218, 217, 217),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          IconButton(
            onPressed: onSend,
            icon: Icon(Icons.send),
            hoverColor: Color.fromARGB(255, 218, 217, 217),
          )
        ],
      ).paddingBottom(8),
    );
  }
}