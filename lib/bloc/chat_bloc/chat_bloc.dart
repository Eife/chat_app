import 'package:bloc/bloc.dart';
import 'package:chat_app/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<FindLastMessageUsersEvent>((event, emit) async {
      LastMessageInfo listLastMessageInfo;

      try {
        //Получаем LastMessageInfo
        final docSnapshot = await FirebaseFirestore.instance
            .collection("chat")
            .doc("XK0X3KOAKnZ1PnIztDxq")
            .get();
        if (docSnapshot.exists) {
          listLastMessageInfo = LastMessageInfo.fromMap(docSnapshot.data()!);
          emit(ChangeAllLastMessageInfoState(
              lastMessageInfo: listLastMessageInfo));
        }
      } catch (e) {
        emit(ZeroLastMessageInfoState());
        print("Ошибка {$e}");
      }
    });

    on<FindNewUserEvent>((event, emit) async {
      String symbolToFind = event.symbolToFind;

      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("unicNickName", isGreaterThanOrEqualTo: symbolToFind)
            .where('unicNickName', isLessThan: symbolToFind + "\uf8ff")
            .get();


        List<UserModel> users = querySnapshot.docs.map((e) {
          Map<String, dynamic> data = e.data() as Map<String, dynamic>;
          return UserModel.fromMap(data);
        }).toList();
        print("Find");
        print(users);

        emit(ShowAllUsersToFindState(listUsers: users));
      } catch (error) {
        emit(ErrorFindUsersState());
      }
    });
  }
}
