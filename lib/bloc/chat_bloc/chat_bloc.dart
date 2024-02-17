import 'package:bloc/bloc.dart';
import 'package:chat_app/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  
  ChatBloc() : super(ChatInitial()) {
    on<FindUsersEvent>((event, emit) async {
      LastMessageInfo listLastMessageInfo;
      try {
        
        //Получаем LastMessageInfo
        final docSnapshot = await FirebaseFirestore.instance.collection("chat").doc("XK0X3KOAKnZ1PnIztDxq").get(); 
        if (docSnapshot.exists){
          listLastMessageInfo = LastMessageInfo.fromMap(docSnapshot.data()!);
          emit(ChangeAllLastMessageInfoState(lastMessageInfo: listLastMessageInfo));
        }


      } catch (e) {
        emit(ZeroLastMessageInfoState());
        print("Ошибка {$e}");
      }


    });
  }
}
