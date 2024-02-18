import 'package:chat_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/components/find_user.dart';
import 'package:chat_app/screens/find_new_users.dart';
import 'package:chat_app/components/list_tile_user_dialog.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => FindNewUsers()));
      }, child: Icon(Icons.person_add, size: 25,),),
      appBar: AppBar(
        title: Text("Чаты",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
            .paddingAll(8),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // FindUser(),        //Нет поисковой строки, исправить
            BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is ZeroLastMessageInfoState) {
                  return Container();
                } else if (state is ChangeAllLastMessageInfoState) {
                return ListView.builder(
                  itemCount: 1,                //Удалить 
                  itemBuilder: (buiid, context) {
                    return ListTileUserDialog(lastMessageInfo: state.lastMessageInfo);
                  } );
                
                
                
                } else {
                  return Text("Полное отсутствие здравого смысла");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
