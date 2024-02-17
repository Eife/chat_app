import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FindMessage extends StatefulWidget {
  const FindMessage({super.key});

  @override
  State<FindMessage> createState() => _FindChatState();
}

class _FindChatState extends State<FindMessage> {
  TextEditingController controller = TextEditingController(text: "@");
  
  @override
  Widget build(BuildContext context) {
    return Container(

      height: 60,
      child: Center(
        child: TextField(
          onEditingComplete: () {
            
          },

          controller: controller,
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
