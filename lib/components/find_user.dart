import 'dart:async';

import 'package:chat_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class FindUser extends StatefulWidget {
  final TextEditingController controller;
  // final Function(String) onSearchCanged;
  // final String hintText;

  //, required this.controller, required this.onSearchCanged, required this.hintText
  const FindUser({super.key, required this.controller});

  @override
  State<FindUser> createState() => _FindChatState();
}

class _FindChatState extends State<FindUser> {
  Timer? _timer;


  @override
  void initState() {
    
    super.initState();
    widget.controller.addListener(_onSearchChanged);
    print("Инит стейт");
  }

  void _onSearchChanged() {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1500), () {
      print("Попытка вызвать onSearch");
      //Mounted что бы не критило при резком закрытии окна, если блок не выполнен
      if (mounted) {BlocProvider.of<ChatBloc>(context).add(FindNewUserEvent(symbolToFind: widget.controller.text));
     }}
    );
  }




  @override
  Widget build(BuildContext context) {
    return Container(

      height: 60,
      child: Center(
        child: TextField(
          onEditingComplete: () {
            
          },

          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 1),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              filled: true,
              fillColor: Color.fromARGB(255, 216, 220, 232),
              hintText: "Поиск",
              
              prefixIcon: Icon(Icons.search, size: 24,)),
        ).paddingOnly(left: 16, right: 16, bottom: 8),
      ),
    );
  }
}
