import 'package:chat_app/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabaseLastMessage {
  var box = Hive.box<UserModelToHive>("lastMessages");
  
  Future<void> updateOrCreateUserLastMessage(String chatId, UserModel userModel, String newMessage) async {
    //Тут мы добавляем ласт месседж
    var box = Hive.box<UserModelToHive>("lastMessages");

    UserModelToHive? existingData = await box.get(chatId);
    

    if (existingData != null) {
      existingData.lastMessage = newMessage;
      existingData.timeStamp = Timestamp.now().toString();
      existingData.isRead = false; 
      await box.put(chatId, existingData);
      print("Путим с наличием чата");
    } else {
      print("Путим безналичие чата");
      await box.put(
        chatId,
        UserModelToHive(
          unicNickName: userModel.unicNickName,
          activity: false,
          chat: {},
          lastSeen: userModel.lastSeen.toString(),
          uid: userModel.uid,
          name: userModel.name,
          surname: userModel.surname,
          chatId: chatId,
          isRead: false,
          lastMessage: newMessage,
          timeStamp: Timestamp.now().toString(),
        ));
    }
  }



  Future<void> updateLastMessageInHive(
      String chatId, UserModelToHive data) async {
    await box.put(chatId, data);
  }

  Future<void> deleteAll() async {
    await box.deleteFromDisk();
  }
}
