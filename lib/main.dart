import 'package:chat_app/bloc/bloc/register_bloc.dart';
import 'package:chat_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelToHiveAdapter());
  await Hive.openBox<UserModelToHive>("lastMessages");


  runApp(MultiBlocProvider(
    
    providers: [
      BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(),
      ),
      BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(),
      ),
    ],
    child: MainApp(),
  ));
 
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: StartScreen(),
      ),
    );
  }
}
