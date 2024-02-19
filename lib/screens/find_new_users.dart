import 'dart:async';

import 'package:chat_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/components/find_user.dart';
import 'package:chat_app/components/show_users_to_add.dart';
import 'package:chat_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FindNewUsers extends StatefulWidget {
  const FindNewUsers({super.key});

  @override
  State<FindNewUsers> createState() => _FindNewUsersState();
}

class _FindNewUsersState extends State<FindNewUsers> {
  TextEditingController controller = TextEditingController();
  Timer? _timer;
  
  @override
  void initState() {
    
    super.initState();
    controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (controller.text.isEmpty) return;

    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () {
      print("Search text ${controller.text}");
      BlocProvider.of<ChatBloc>(context).add(FindNewUserEvent(symbolToFind: controller.text));
     });
  }

    @override
  void dispose() {
    _timer?.cancel();
    controller.dispose();
    super.dispose();
  }





  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Введите никнейм пользователя", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        child: Column(children: [
          FindUser(controller: controller,),
          BlocConsumer<ChatBloc, ChatState>(
            listener: (context, state) {
              
            },
            builder: (context, state)  {
              if (state is ShowAllUsersToFindState) {
              List<UserModel> listUsers = state.listUsers;
              int count = listUsers.length;
              return Expanded(
                child: ListView.builder(
                  itemCount: count,
                  itemBuilder: (BuildContext context, index) {
                    return ShowUsersToAdd(user: listUsers[index]);
                  }),
              );} else { return Text("data");}
            },
          )

        ]),
      ),
    );
  }
}
