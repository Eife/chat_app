// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'models.g.dart';

class UserModel {
  String uid;
  String unicNickName;
  String name;
  String surname;
  bool activity;
  Map<String, String> chat;
  Timestamp lastSeen;
  String? aboutMe;

  UserModel({
    required this.uid,
    required this.unicNickName,
    required this.name,
    required this.surname,
    required this.activity,
    this.aboutMe,
    required this.chat,
    required this.lastSeen,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'unicNickName': unicNickName,
      'name': name,
      'surname': surname,
      'activity': activity,
      'chat': chat,
      'lastSeen': lastSeen.millisecondsSinceEpoch,
      'aboutMe': aboutMe,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      unicNickName: map['unicNickName'] as String,
      name: map['name'] as String,
      surname: map['surname'] as String,
      activity: map['activity'] as bool,
      chat: Map<String, String>.from(map['chat'] ?? {}),
      lastSeen: map['lastSeen'] as Timestamp,
      aboutMe: map['aboutMe'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LastMessageInfo {
  final String chatId;
  final String lastMessage;
  final String timestamp;
  final String senderId;
  final String senderName;
  final String senderSurname;
  final bool read;
  LastMessageInfo({
    required this.chatId,
    required this.lastMessage,
    required this.timestamp,
    required this.senderId,
    required this.senderName,
    required this.senderSurname,
    required this.read,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatId': chatId,
      'lastMessage': lastMessage,
      'timestamp': timestamp,
      'senderId': senderId,
      'senderName': senderName,
      'senderSurname': senderSurname,
    };
  }

  factory LastMessageInfo.fromMap(Map<String, dynamic> map) {
    return LastMessageInfo(
      chatId: map['chatId'] as String,
      lastMessage: map['lastMessage'] as String,
      timestamp: map['timestamp'] as String,
      senderId: map['senderId'] as String,
      senderName: map['senderName'] as String,
      senderSurname: map['senderSurname'] as String,
      read: map['read'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory LastMessageInfo.fromJson(String source) =>
      LastMessageInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Chat {
  final String chatId;
  final List<String> participants; // Список UID юзеров
  final LastMessageInfo? lastMessageInfo;

  Chat({
    required this.chatId,
    required this.participants,
    this.lastMessageInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'participants': participants,
      'lastMessageInfo': lastMessageInfo?.toMap(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      chatId: map['chatId'],
      participants: List<String>.from(map['participants']),
      lastMessageInfo: map['lastMessageInfo'] != null
          ? LastMessageInfo.fromMap(map["lastMessageInfo"])
          : null,
    );
  }
}

class Message {
  final String messageId;
  final String senderId;
  final String text;
  final Timestamp timestamp;

  Message({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'],
      senderId: map['senderId'],
      text: map['text'],
      timestamp: map['timestamp'],
    );
  }
}

@HiveType(typeId: 0)
class UserModelToHive extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String unicNickName;

  @HiveField(2)
  String name;

  @HiveField(3)
  String surname;

  @HiveField(4)
  bool activity;

  @HiveField(5)
  final Map<String, String> chat;

  @HiveField(6)
  String lastSeen; // Timestamp преобразован в String

  @HiveField(7)
  final String chatId;

  @HiveField(8)
  bool isRead;

  @HiveField(9)
  String lastMessage;

  @HiveField(10)
  String timeStamp;

  @HiveField(11)
  String? aboutMe;

  UserModelToHive({
    required this.uid,
    required this.unicNickName,
    required this.name,
    required this.surname,
    required this.activity,
    required this.chat,
    required this.lastSeen,
    required this.chatId,
    required this.isRead,
    required this.lastMessage,
    required this.timeStamp,
    this.aboutMe,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'unicNickName': unicNickName,
      'name': name,
      'surname': surname,
      'activity': activity,
      'chat': chat,
      'lastSeen': lastSeen,
      'chatId': chatId,
      'isRead': isRead,
      'lastMessage': lastMessage,
      'timeStamp': timeStamp,
      'aboutMe': aboutMe,
    };
  }

  factory UserModelToHive.fromJson(Map<String, dynamic> map) {
    var chatData = map['chat'];
    Map<String, String> chatMap;

    if (chatData is String) {
      // Если chatData - строка, предполагаем, что это JSON
      chatMap = Map<String, String>.from(json.decode(chatData));
    } else {
      // Если chatData уже Map, используем его напрямую
      chatMap = Map<String, String>.from(chatData);
    }

    return UserModelToHive(
      uid: map['uid'],
      unicNickName: map['unicNickName'],
      name: map['name'],
      surname: map['surname'],
      activity: map['activity'],
      chat: Map<String, String>.from(map['chat']),
      lastSeen: map['lastSeen'],
      chatId: map['chatId'],
      isRead: map['isRead'],
      lastMessage: map['lastMessage'],
      timeStamp: map['timeStamp'],
      aboutMe: map['aboutMe'],
    );
  }
}


