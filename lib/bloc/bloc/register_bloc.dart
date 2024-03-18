import 'package:bloc/bloc.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/utils/firestore_base.dart';
import 'package:chat_app/utils/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:nb_utils/nb_utils.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  LocalStorageService _localStorageService = LocalStorageService();
  OptionsFirestoreBase _optionsFirestoreBase = OptionsFirestoreBase();
  RegisterBloc() : super(RegisterInitial()) {
    on<CheckAndAuthorUserEvent>((event, emit) async {
      print("CheckAndAutorUser");
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // await _localStorageService.saveUserUid(currentUser.uid);
        try {
          print(currentUser.uid);
          final userSnapshot = await FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser.uid)
              .get();

          if (userSnapshot.exists) {
            print("Попытка привязать модель к мапе");

            UserModel user = UserModel.fromMap(userSnapshot.data()!);
            emit(UserRegisterState(user: user));
          }
        } catch (e) {
          print("Ошибка {$e}");
          emit(UserEmptyState());
        }
      }
      ;

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
        // await FirebaseAuth.instance.signOut();
        //-Для удаление юзера(удалить. Если не выйти, то удаляя вручную юзера с бд зарегистрироваться с тем же)
        //uid не получится.
        emit(UserEmptyState());
      }
    });

    // on<CheckUnicalNickNameEvent>((event, emit) async {
    //   String checkNickname = event.nickNameToCheck;

    //   Future<bool> unicAccount = _optionsFirestoreBase.checkUnicAccount(checkNickname);

    //   if (unicAccount == true) {

    //   } else {

    //   }

    // });

    on<RegisterUserEvent>((event, emit) async {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      String uid = userCredential.user!.uid;
      await _localStorageService.saveUserUid(uid);
      await _localStorageService.saveUnicNickName(event.unicNickName);

      try {
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'uid': uid,
          'name': event.name,
          'surname': event.surname,
          'activity': true,
          'chat': {},
          'lastSeen': Timestamp.now(),
          'aboutMe': event.aboutMe,
          'unicNickName': event.unicNickName,
        });

        //Сохраняем в базу
        await _localStorageService.saveUserUid(uid);
        await _localStorageService.saveUserInfo(event.name, event.surname);

        emit(UserRegisterState(
            user: UserModel(
                uid: uid,
                unicNickName: event.unicNickName,
                name: event.name,
                surname: event.surname,
                activity: true,
                chat: {},
                lastSeen: Timestamp.now(),
                aboutMe: event.aboutMe)));
      } catch (e) {
        print("Ошибка ${e}");
        emit(UserEmptyState());
      }
    });
  }
}
