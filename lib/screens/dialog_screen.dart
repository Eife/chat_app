import 'package:chat_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DialogScreen extends StatefulWidget {
  Chat? chat;
  List<Message>? messages;
  LastMessageInfo? lastMessageInfo;
  DialogScreen({super.key, this.chat, this.messages});

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: showUser("", ""),),  // Поставить сюда
      bottomNavigationBar: Container(
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.attachment,), hoverColor: Color.fromARGB(255, 218, 217, 217),),
            TextField(decoration: InputDecoration(hintText: "Сообщение", filled: true, fillColor: const Color.fromARGB(255, 218, 217, 217)), ),
            IconButton(onPressed: () {}, icon: Icon(Icons.keyboard_voice), hoverColor: Color.fromARGB(255, 218, 217, 217),)
          ],
        ),

      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return Container(

          );
        },
      ),
    );
  }
}