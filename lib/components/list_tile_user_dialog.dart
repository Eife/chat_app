// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/screens/dialog_screen.dart';
import 'package:chat_app/utils/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/models/models.dart';

class ListTileUserDialog extends StatefulWidget {
  String name;
  String surname;
  bool isRead;
  String lastMessage;
  String timestamp;
  String uid;
  String unicNickName;

  ListTileUserDialog({
    Key? key,
    required this.name,
    required this.surname,
    required this.isRead,
    required this.lastMessage,
    required this.timestamp,
    required this.uid,
    required this.unicNickName,
  }) : super(key: key);

  @override
  State<ListTileUserDialog> createState() => _ListTileUserDialogState();
}

class _ListTileUserDialogState extends State<ListTileUserDialog> {
  LocalStorageService _localStorageService = LocalStorageService();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.yellow.shade300,
        child: Text(
          "${widget.name.substring(0, 1)}${widget.surname.substring(0, 1)}",
          style: TextStyle(fontSize: 20),
        ),
      ),
      title: Text("${widget.name} ${widget.surname}", style: TextStyle(fontSize: 20),),
      subtitle: Text(widget.lastMessage, style: TextStyle(fontSize: 16),),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () async{
                String? chatId = await _localStorageService.getChatId(widget.uid);
                UserModel userModel = UserModel(
                    uid: widget.uid,
                    unicNickName: widget.unicNickName,
                    name: widget.name,
                    surname: widget.surname,
                    activity: widget.isRead,
                    chat: {},
                    lastSeen: Timestamp.now());
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DialogScreen(
                        companionUid: widget.uid,
                        companionName: widget.name,
                        companionSurname: widget.surname,
                        unicNickName: widget.unicNickName,
                        activity: true,
                        chat: {},
                        lastSeen: Timestamp.now())));
              },
              icon: Icon(Icons.keyboard_arrow_right)),
        ],
      ),
    );
  }
}
