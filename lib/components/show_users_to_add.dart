import 'package:chat_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/screens/dialog_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

//** ДОБАВИТЬ РЕГИСТР К ПОИСКУ! */

class ShowUsersToAdd extends StatefulWidget {
  UserModel user;

  ShowUsersToAdd({super.key, required this.user});

  @override
  State<ShowUsersToAdd> createState() => _ShowUsersToAddState();
}

class _ShowUsersToAddState extends State<ShowUsersToAdd> {
  @override
  Widget build(BuildContext context) {
    String name = widget.user.name;
    String surname = widget.user.surname;
    String unicNickname = widget.user.unicNickName;

    return Container(
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 2,
            child: Divider(
              height: 2,
              thickness: 2,
            ),
          ),
          SizedBox(
            height: 60,
            child: ListTile(
              trailing: IconButton(
                icon: Icon(Icons.person_add),
                onPressed: () {
                  // BlocProvider.of<ChatBloc>(context)
                  //     .add(AddOrReturnChatEvent(userModel: widget.user));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DialogScreen(
                              companionUid: widget.user.uid,
                              companionName: widget.user.name,
                              companionSurname: widget.user.surname,
                              unicNickName: widget.user.unicNickName,
                              activity: true,
                              chat: {},
                              lastSeen: Timestamp.now())));
                },
              ),
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    color: const Color.fromARGB(255, 132, 126, 73)),
                child: Center(
                  child: Text(
                    "${name.substring(0, 1)}${surname.substring(0, 1)}",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
              title: Text("${name} ${surname}", style: TextStyle(fontSize: 20),),
              subtitle: Text("@${unicNickname}", style: TextStyle(fontSize: 18),),
            ),
          ),
        ],
      ),
    );
  }
}
