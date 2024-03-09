import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/utils/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<StartDialogEvent>(((event, emit) {
      emit(StartDialogState());
    }));

    // on<FindLastMessageUsersEvent>((event, emit) async {
    //   LastMessageInfo listLastMessageInfo;
    //   final directory = await getApplicationDocumentsDirectory();
    // });

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
      print(event.userModel);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String chatId = sharedPreferences.getString(event.userModel.uid)!;

      try {
        //Получаем чат айди

        var box = Hive.box<UserModelToHive>("lastMessages");

        // Проверка на наличие записи для данного chatId в Hive.
        UserModelToHive? existingData = await box.get(chatId);

        if (existingData != null) {
          // Если запись существует, обновляем данные последнего сообщения.
          existingData.lastMessage = event.newMessage;
          existingData.timeStamp = Timestamp.now().toString();
          existingData.isRead = false; // Помечаем сообщение как непрочитанное.
          box.put(chatId, existingData); // Обновляем запись в Hive.
          print("Путим с наличием чата");
        } else {
          // Если запись отсутствует, создаем новую.
          print("Путим безналичие чата");
          await box.put(
              chatId,
              UserModelToHive(
                unicNickName: event.userModel.unicNickName,
                activity: false,
                chat: {},
                lastSeen: event.userModel.lastSeen.toString(),
                uid: event.userModel.uid,
                name: event.userModel.name,
                surname: event.userModel.surname,
                chatId: chatId,
                isRead: false, // Помечаем сообщение как непрочитанное.
                lastMessage: event.newMessage,
                timeStamp: Timestamp.now().toString(),
              ));
        }
      } catch (e) {
        print("Ошибка при добавлении в коробку: $e");
      }

      // Добавление сообщения в Firebase и обновление lastMessageInfo.
      try {
        User? user = await FirebaseAuth.instance.currentUser;
        if (user == null) {
          print("Пользователь не найден");
          return;
        }

        String uid = user.uid;
        String newMessage = event.newMessage;
        String messageId = Uuid().v4();

        Map<String, dynamic> message = {
          "messageId": messageId,
          "senderId": uid,
          "text": newMessage,
          "timestamp": Timestamp.now(),
        };

        // Убедитесь, что chatId корректно определен для данного контекста.
        if (chatId.isEmpty) {
          print("Chat ID is not provided.");
          return;
        }

        // Обновление lastMessageInfo в документе чата.
        final lastMessageInfo = LastMessageInfo(
          chatId: chatId,
          lastMessage: newMessage,
          timestamp: Timestamp.now().toString(),
          senderId: uid,
          senderName:
              event.userModel.name, // Используем имя отправителя из события.
          senderSurname: event
              .userModel.surname, // Используем фамилию отправителя из события.
          read: false,
        );

        // Обновляем информацию о последнем сообщении в документе чата.
        await FirebaseFirestore.instance.collection("chat").doc(chatId).update({
          "lastMessageInfo": lastMessageInfo.toMap(),
        });

        // Добавляем сообщение в подколлекцию messages документа чата.
        await FirebaseFirestore.instance
            .collection("chat")
            .doc(chatId)
            .collection("messages")
            .add(message);
        print("Сообщение успешно добавлено.");
        emit(ChatFoundState(chatId: chatId));
      } catch (e) {
        print("Ошибка в сохранении нового сообщения: $e");
      }
    });

    on<ShowAllMessageInDialogEvent>((event, emit) async {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          print("Пользователь не авторизован");
          emit(ChatIsNotFoundState());
          return;
        }
        String uid = user.uid;

        // final querySnapshot =
        //     await FirebaseFirestore.instance.collection("users").doc(uid).get();
        // UserModel userModel = UserModel.fromMap(querySnapshot.data()!);

        // String? chatId = userModel.chat[event.userModel.uid];

        SharedPreferences chatIdS = await SharedPreferences.getInstance();
        String chatId = chatIdS.getString(event.userModel.uid)!;

        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("chat")
            .doc(chatId)
            .collection("messages")
            .orderBy("timestamp", descending: false)
            .limit(20)
            .get();
        for (var doc in querySnapshot.docs) {}
        final List<Message> showAllMessages = querySnapshot.docs
            .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
            .toList();


        // Подписка на поток сообщений
        var subscription = FirebaseFirestore.instance
            .collection("chat")
            .doc(chatId)
            .collection("messages")
            .orderBy("timestamp", descending: false)
            .limit(50)
            .snapshots();

        await for (var snapshot in subscription) {
          List<Message> messages = snapshot.docs
              .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          // Обновление Hive и состояния BLoC
          if (messages.isNotEmpty) {
            String lastMessageText = messages.last.text;
            Timestamp lastMessageTimestamp = messages.last.timestamp;

            var box = Hive.box<UserModelToHive>("lastMessages");
            var existingData = box.get(event.userModel.uid);

            if (existingData != null) {
              existingData.lastMessage = lastMessageText;
              existingData.timeStamp = lastMessageTimestamp.toString();
              box.put(event.userModel.uid, existingData);
            } else {
              box.put(
                  event.userModel.uid,
                  UserModelToHive(
                    unicNickName: event.userModel.unicNickName,
                    activity: false,
                    chat: {},
                    lastSeen: event.userModel.lastSeen.toString(),
                    uid: event.userModel.uid,
                    name: event.userModel.name,
                    surname: event.userModel.surname,
                    chatId: chatId!,
                    isRead: false,
                    lastMessage: lastMessageText,
                    timeStamp: lastMessageTimestamp.toString(),
                  ));
            }
          }

          if (!emit.isDone) {
            emit(ShowAllMessageInDialogState(listMessage: messages));
          }
        }
      } catch (e) {
        print("Ошибка при получении сообщений: $e");
        if (!emit.isDone) {
          emit(ChatIsNotFoundState());
        }
      }
    });

    //Подписка на обновления. Доделать.
// Вроде userInfo содержит UID текущего пользователя
    on<SubscribeToAllMessageEvent>((event, emit) async {
      User user =
          userInfo!; //Вроде всегда есть userInfo при каждом входе,но все же может проверку сделать
      String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

      FirebaseFirestore.instance
          .collection("chat")
          .where("participants", arrayContains: currentUserUid)
          .snapshots()
          .listen((snapshot) async {
        var box = Hive.box<UserModelToHive>("lastMessages");

        for (var doc in snapshot.docs) {
          var chatId = doc.id;
          var data = doc.data() as Map<String, dynamic>;
          var lastMessageInfo =
              data['lastMessageInfo'] as Map<String, dynamic>?;

          if (lastMessageInfo != null) {
            String lastMessageText = lastMessageInfo['text'];
            Timestamp lastMessageTimestamp = lastMessageInfo['timestamp'];
            UserModelToHive? existingData = box.get(chatId);

            if (existingData != null) {
              // Обновляем существующие данные
              existingData.lastMessage = lastMessageText;
              existingData.timeStamp = lastMessageTimestamp.toString();
              box.put(chatId, existingData);
            } else {
              // Создаем новую запись
              UserModelToHive newData = UserModelToHive(
                unicNickName: "un",
                activity: false,
                chat: {},
                lastSeen: "",
                uid: currentUserUid,
                name: "Имя",
                surname: "Фамилия",
                chatId: chatId,
                isRead:
                    false, // Предполагаем, что последнее сообщение не прочитано
                lastMessage: lastMessageText,
                timeStamp: lastMessageTimestamp.toString(),
              );
              box.put(chatId, newData);
            }
          }
        }
      });
    });

    on<SubcribeToAllChatEvent>((event, emit) async {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      FirebaseFirestore.instance
          .collection("chat")
          .where("participants", arrayContains: uid)
          .snapshots()
          .listen((snapshot) {
        var box = Hive.box<UserModelToHive>("lastMessages");

        for (var doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          // поле lastMessageInfo в документе чата
          var lastMessageInfo =
              data['lastMessageInfo'] as Map<String, dynamic>?;

          if (lastMessageInfo != null) {
            // Создание или обновление записи в Hive с использованием данных из LastMessageInfo
            var lastMessage = LastMessageInfo(
              chatId: lastMessageInfo['chatId'],
              lastMessage: lastMessageInfo['lastMessage'],
              timestamp: lastMessageInfo['timestamp'],
              senderId: lastMessageInfo['senderId'],
              senderName: lastMessageInfo['senderName'],
              senderSurname: lastMessageInfo['senderSurname'],
              read: false,
            );

            // Проверка существования записи в Hive для текущего чата
            UserModelToHive? existingData = box.get(doc.id);

            if (existingData != null) {
              // Обновление существующей записи
              existingData.lastMessage = lastMessage.lastMessage;
              existingData.timeStamp = lastMessage.timestamp;
              existingData.isRead = lastMessage.read;
              box.put(doc.id, existingData);
            } else {
              // Создание новой записи, если она отсутствует
              box.put(
                  doc.id,
                  UserModelToHive(
                    unicNickName: "",
                    activity: false,
                    chat: {},
                    lastSeen: "",
                    uid: lastMessage.senderId,
                    name: lastMessage.senderName,
                    surname: lastMessage.senderSurname,
                    chatId: lastMessage.chatId,
                    isRead: lastMessage.read,
                    lastMessage: lastMessage.lastMessage,
                    timeStamp: lastMessage.timestamp,
                  ));
            }
          }
        }
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
          event.userModel.uid,
          uid
        ]).get(); //Под вопросом, может не работать
        print("Скорее всего null этот снапшот :  $querySnapshot");
        if (querySnapshot.docs.isEmpty) {
          throw FormatException("Отсутствие базы");
        }
        String chatId = querySnapshot.docs.first.id;
        emit(ChatFoundState(chatId: chatId));
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
            //Убрать unknow и придумать как убирать ошибку при пустом чате.
            lastMessageInfo: null);

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
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString("${event.userModel.uid}", chatId);

        emit(ChatCreateState(chatId: chatId));
      }
    });
  }
}
