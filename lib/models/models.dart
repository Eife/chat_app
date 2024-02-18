// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String unicNickName;
  String name;
  String surname;
  bool activity;
  List<dynamic> chat; 
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
      'lastSeen': lastSeen?.millisecondsSinceEpoch,
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
      chat: List<dynamic>.from(map['chat'] as List), 
      lastSeen: map['lastSeen'] as Timestamp,
      aboutMe: map['aboutMe'] as String?, 
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LastMessageInfo {
  final String chatId;
  final String lastMessage;
  final Timestamp timestamp;
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
      timestamp: map['timestamp'] as Timestamp,
      senderId: map['senderId'] as String,
      senderName: map['senderName'] as String,
      senderSurname: map['senderSurname'] as String,
      read: map['read'] as bool,
      
    );
  }

  String toJson() => json.encode(toMap());

  factory LastMessageInfo.fromJson(String source) => LastMessageInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Chat {
  final String chatId;
  final List<String> participants; // Список UID юзеров
  final List<Message> messages; //  

  Chat({
    required this.chatId,
    required this.participants,
    this.messages = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'participants': participants,
      'messages': messages.map((message) => message.toMap()).toList(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      chatId: map['chatId'],
      participants: List<String>.from(map['participants']),
      messages: List<Message>.from(map['messages']?.map((x) => Message.fromMap(x)) ?? []),
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
