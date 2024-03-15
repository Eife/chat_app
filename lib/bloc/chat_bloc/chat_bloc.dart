import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/utils/firestore_base.dart';
import 'package:chat_app/utils/hive_database.dart';
import 'package:chat_app/utils/local_database.dart';
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
  final LocalStorageService _localStorageService = LocalStorageService();
  final OptionsFirestoreBase _firestorebase = OptionsFirestoreBase();
  final HiveDatabaseLastMessage _hiveDatabaseLastMessage =
      HiveDatabaseLastMessage();
  StreamSubscription<List<Message>>? _subscriptionDialog;
  StreamSubscription<List<Message>>? _subscriptionAllMessage;

  ChatBloc() : super(ChatInitial()) {
    on<StartDialogEvent>(((event, emit) {
      emit(StartDialogState());
    }));

    on<FindNewUserEvent>((event, emit) async {
      String symbolToFind = event.symbolToFind;

      try {
        List<UserModel> users = await _firestorebase.findNewUsers(symbolToFind);

        emit(ShowAllUsersToFindState(listUsers: users));
      } catch (error) {
        emit(ErrorFindUsersState());
      }
    });
    on<AddNewMessageEvent>((event, emit) async {
      //В регистре сохранили
      String uid = await _localStorageService.getUserUid();
      //Мы должны получить чат айди, для этого передаем uid собеседника
      String? chatId =
          await _localStorageService.getChatId(event.userModel.uid);
      List<String>? myName = await _localStorageService.getUserInfo();

      try {
        _hiveDatabaseLastMessage.updateOrCreateUserLastMessage(
            chatId!, event.userModel, event.newMessage);
      } catch (e) {
        print("Ошибка при добавлении в коробку: $e");
      }
      try {
        String newMessage = event.newMessage;
        String messageId = Uuid().v4();

        Message message = Message(
            messageId: messageId,
            senderId: uid,
            text: newMessage,
            timestamp: Timestamp.now());
        // Обновление lastMessageInfo в документе чата.
        final lastMessageInfo = LastMessageInfo(
          chatId: chatId!,
          lastMessage: newMessage,
          timestamp: Timestamp.now().toString(),
          senderId: uid,
          senderName:
              myName[0], // Используем имя отправителя из события.
          senderSurname: myName[1], // Используем фамилию отправителя из события.
          read: false,
        );

        //Тут поменять для правильного отображения имени диалога
        // Обновляем информацию о последнем сообщении в документе чата.
        await _firestorebase.updateLastMessageInfo(lastMessageInfo, chatId);

        // Добавляем сообщение в подколлекцию messages документа чата.
        await _firestorebase.addMessageToFirestore(
            chatId: chatId, message: message);
        // emit(ChatFoundState(chatId: chatId));
      } catch (e) {
        print("Ошибка в сохранении нового сообщения: $e");
      }
    });

    on<ShowAllMessageInDialogEvent>((event, emit) async {
      try {
        String uid = await _localStorageService.getUserUid();
        String? chatId =
            await _localStorageService.getChatId(event.userModel.uid);

        if (chatId == null) {
          emit(ChatIsNotFoundState());
          return;
        }

        // Получаем начальный список сообщений
        List<Message> allMessages =
            await _firestorebase.showLastMessageInDialog(chatId);

        //Отрабатывает все правильно.
        // Эмитируем состояние с начальным списком сообщений
        if (!emit.isDone) {
          emit(ShowAllMessageInDialogState(listMessage: allMessages));
        }

        Message lastMessage = allMessages.first;

        // Подписываемся на поток новых сообщений

        Timestamp lastMess = lastMessage.timestamp;
        List<Message> saveList = [];
        print("text");
        await for (final newMessages
            in _firestorebase.messagesStream(chatId, lastMess)) {
          if (newMessages.isNotEmpty) {
              saveList.clear();
            saveList = List<Message>.from(allMessages);

            saveList.insertAll(0, newMessages.reversed.toList());


            emit(ShowAllMessageInDialogState(listMessage: saveList));
          
          }
        }
      } catch (e) {
        print("Ошибка при получении сообщений: $e");
        // emit(ChatErrorState("Ошибка при получении сообщений: $e"));
      }
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
            //Записываем чат id в телефон
            _localStorageService.saveChatId(
                lastMessage.senderId, lastMessage.chatId);
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
      //Получаем uid сохраненный в базе.
      String uid = await _localStorageService.getUserUid();
      String? chatId = await _localStorageService.getChatId(event.companionUid);
      if (chatId != null) {
        print("Трай");
        //Проверка наличия чата
        //Возвращаем если чат есть
        // String chatId = await _firestorebase.findChat(event.companionUid, uid);
        _localStorageService.saveChatId(event.companionUid, chatId);
        emit(ChatFoundState(chatId: chatId));
      } else {
        String chatId = Uuid().v4();

        Chat newChat = Chat(
            chatId: chatId,
            participants: [event.companionUid, uid],
            lastMessageInfo: null);

        //создание коллециии чат
        await _firestorebase.saveToCollectionChat(chatId, newChat);

        //Обновление полей в Firebase(чаты)
        _firestorebase.updateTwoUsersChatsField(
            uid, event.companionUid, chatId);

        print("Чат добавлен.");

        await _localStorageService.saveChatId(event.companionUid, chatId);

        emit(ChatCreateState(chatId: chatId));
      }
    });

    on<UnsubscribeDialogEvent>((event, emit) {
      _subscriptionDialog?.cancel();
      _subscriptionDialog = null;
    });

    on<DeleteAccountAndChatsEvent>((event, emit) {
      _firestorebase.deleteAllDatabase(event.userId);
      
    });
  }
}
