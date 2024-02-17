import 'dart:convert';

class UserModel {
  String uid;
  String name;
  String surname;
  bool activity;
  List<dynamic> chat; 
  DateTime? lastSeen;
  String? aboutMe;

  UserModel({
    required this.uid,
    required this.name,
    required this.surname,
    required this.activity,
    this.aboutMe, 
    required this.chat,
    this.lastSeen, 
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
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
      name: map['name'] as String,
      surname: map['surname'] as String,
      activity: map['activity'] as bool,
      chat: List<dynamic>.from(map['chat'] as List), 
      lastSeen: map['lastSeen'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastSeen'] as int) : null,
      aboutMe: map['aboutMe'] as String?, 
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
