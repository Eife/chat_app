import 'package:chat_app/components/find_message.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(title: Text("Чаты", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)).paddingAll(8),),
      body: SafeArea(
        child: Column(
          children: [
            FindMessage(),


            


          ],
        ),
      ),
    );
  }
}