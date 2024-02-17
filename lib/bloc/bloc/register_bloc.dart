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
      if (currentUser != null) print("Чек блок");

      try {
        print("try");
        //Убрать ! что бы не было ошибки(сделать явную проверку)
        final docSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser!.uid)
            .get();
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
    on<RegisterUserEvent>((event, emit) async {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      String uid = userCredential.user!.uid;
      print(uid);

      try {
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'uid': uid,
          'name': event.name,
          'surname': event.surname,
          'activity': true,
          'chat': [],
          'lastSeen': null,
          'aboutMe': event.aboutMe,
        });
        emit(UserRegisterState(
            user: UserModel(
                activity: true,
                uid: uid,
                name: event.name,
                surname: event.surname,
                chat: [],
                lastSeen: null,
                aboutMe: event.aboutMe)));
      } catch (e) {
        print("Ошибка ${e}");
        emit(UserEmptyState());
      }
    });
  }
}
