import 'package:chat_app/bloc/bloc/register_bloc.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    BlocProvider.of<RegisterBloc>(context).add(CheckAndAuthorUserEvent());

    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(listener: (context, state) {
        if (state is UserRegisterState) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
        } },
        child: RegisterScreen(),
      
    );
  }
}
