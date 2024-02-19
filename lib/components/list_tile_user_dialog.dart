// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/models/models.dart';

class ListTileUserDialog extends StatefulWidget {
  String name;
  String surname;
  bool isRead;
  String lastMessage;
  String timestamp;

  ListTileUserDialog({
    Key? key,
    required this.name,
    required this.surname,
    required this.isRead,
    required this.lastMessage,
    required this.timestamp,
  }) : super(key: key);

  @override
  State<ListTileUserDialog> createState() => _ListTileUserDialogState();
}

class _ListTileUserDialogState extends State<ListTileUserDialog> {
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
      title: Text("${widget.name} ${widget.surname}"),
      subtitle: Text(widget.lastMessage),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
      
        ],
      ),
    );
  }
}
