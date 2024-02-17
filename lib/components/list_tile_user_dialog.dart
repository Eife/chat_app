import 'package:chat_app/models/models.dart';
import 'package:flutter/material.dart';

class ListTileUserDialog extends StatefulWidget {
  LastMessageInfo lastMessageInfo;

  ListTileUserDialog({super.key, required this.lastMessageInfo});

  @override
  State<ListTileUserDialog> createState() => _ListTileUserDialogState();
}

class _ListTileUserDialogState extends State<ListTileUserDialog> {
  @override
  Widget build(BuildContext context) {
    String name = widget.lastMessageInfo.senderName;
    String surname = widget.lastMessageInfo.senderSurname;

    return Container(
      height: 80,
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(180),
                color: Colors.yellow.shade300),
            child: Center(
              child: Text(
                "${name.substring(0, 1)}${surname.substring(0, 1)}",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          ListTile(
            title: Text(name),
            subtitle: Text(surname),
            
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text(widget.lastMessageInfo.timestamp.toString()),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: widget.lastMessageInfo.read ? SizedBox() : Text("Не прочитанно"),
          ),
          Divider(),
        ],
      ),
    );
  }
}
