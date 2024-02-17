import 'package:bloc/bloc.dart';
import 'package:chat_app/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<CheckAndAuthorUserEvent>((event, emit) async {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null)

    print("Чек блок");

      try {
        print("try");
        //Убрать ! что бы не было ошибки
        final docSnapshot = await FirebaseFirestore.instance.collection("users").doc(currentUser!.uid).get();
        if (docSnapshot.exists) {
          UserModel user = UserModel.fromMap(docSnapshot.data()!);
          emit(UserRegisterState(user: user));
        } else {
          emit(UserEmptyState());
        }



      } catch (e) {
         print("Юзер null");
        emit(UserEmptyState());
      }
    });
  }
}
