import 'package:bloc/bloc.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/utils/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<StartDialogEvent>(((event, emit) {
      emit(StartDialogState());
    }));

    on<FindLastMessageUsersEvent>((event, emit) async {
      LastMessageInfo listLastMessageInfo;

      try {
        //Получаем LastMessageInfo
        final docSnapshot = await FirebaseFirestore.instance
            .collection("chat")
            .doc("")
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

    on<AddNewMessageEvent>((event, emit) async {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          print("Пользователь не найден");
          return;
        }
        String uid = user.uid;
        String uidCompanion = event.userModel.uid;
        String newMessage = event.newMessage;
        String messageId = Uuid().v4();

        Map<String, dynamic> message = {
          "messageId": messageId,
          "senderId":
              uid, 
          "text": newMessage,
          "timestamp": Timestamp.now(),
        };

        final querySnapshot =
            await FirebaseFirestore.instance.collection("users").doc(uid).get();
        UserModel userModel = UserModel.fromMap(querySnapshot.data()!);


        String? chatId = userModel
            .chat[event.userModel.uid];

        if (chatId == null) {
          print("Чат с пользователем ${event.userModel.uid} не найден.");
          return;
        }


        await FirebaseFirestore.instance
            .collection("chat")
            .doc(chatId)
            .collection("messages")
            .add(message);

        print("Сообщение успешно добавлено.");
        // emit(StartShowMessageState());
      } catch (e) {
        print("Ошибка в сохранении нового сообщения: $e");
      }
    });

    on<ShowAllMessageInDialogEvent>((event, emit) async {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          print("Пользователь не авторизован");
          emit(
              ChatIsNotFoundState());
          return;
        }
        String uid = user.uid;

        final querySnapshot =
            await FirebaseFirestore.instance.collection("users").doc(uid).get();
        UserModel userModel = UserModel.fromMap(querySnapshot.data()!);


        String? chatId = userModel
            .chat[event.userModel.uid]; 

        if (chatId == null) {
          print("Чат с пользователем ${event.userModel.uid} не найден");
          emit(ChatIsNotFoundState());
          return;
        }

        QuerySnapshot messageSnapshot = await FirebaseFirestore.instance
            .collection("chat")
            .doc(chatId)
            .collection("messages")
            .orderBy("timestamp", descending: false)
            .limit(50)
            .get();

        List<Message> messages = messageSnapshot.docs.map((doc) {
          return Message.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();

        emit(ShowAllMessageInDialogState(listMessage: messages));
      } catch (e) {
        print("Ошибка при получении сообщений: $e");
        emit(
            ChatIsNotFoundState()); // Эмитим это состояние, если произошла ошибка
      }
    });

    //Подписка на обновления. Доделать.
    on<SubscribeToAllMessageEvent>((event, emit) {
      FirebaseFirestore.instance
          .collection("chat")
          .where("participants", arrayContains: userInfo!)
          .snapshots()
          .listen((snapshot) {
        final dialogs = snapshot.docs.map((doc) {
          Chat.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    });

    //Добавляем и возвращаем чат
    on<AddOrReturnChatEvent>((event, emit) async {
      print("Попытка добавить новый чат");
      //event - для собеседника
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;
      userInfo = user;
      try {
        print("Трай");
        //Проверка наличия чата
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("chat")
            .where("participants", whereIn: [
          "${event.userModel.uid}",
          uid
        ]).get(); //Под вопросом, может не работать
        print("Скорее всего null этот снапшот :  $querySnapshot");
        if (querySnapshot.docs.isEmpty) {
          throw FormatException("Отсутствие базы");
        }
      } catch (e) {
        print("Попытка ..... 1");
        // UID пользователь
        String uid = FirebaseAuth.instance.currentUser!.uid;

        // UID собеседник
        String otherUserId = event.userModel.uid;

        // Генерация id
        String chatId = Uuid().v4();

        // Объект чата
        Chat newChat = Chat(
          chatId: chatId,
          participants: [otherUserId, uid],
          messages: [],
        );

        // Создание нового чата в коллекции 'chat'
        FirebaseFirestore.instance
            .collection("chat")
            .doc(chatId)
            .set(newChat.toMap());

        // Обновляем документ текущего пользователя, UID собеседника
        FirebaseFirestore.instance.collection("users").doc(uid).set({
          'chat': {
            otherUserId: chatId,
          }
        }, SetOptions(merge: true));

        // Наоборот
        FirebaseFirestore.instance.collection("users").doc(otherUserId).set({
          'chat': {
            uid: chatId,
          }
        }, SetOptions(merge: true));

        print("Чат добавлен.");

        emit(ChatIsNotFoundState());
      }
    });
  }
}
