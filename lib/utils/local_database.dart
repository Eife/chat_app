import 'package:chat_app/models/models.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> saveChatId(String userId, String chatId) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(userId, chatId);
  }

  Future<String?> getChatId(String userId) async {
    final SharedPreferences prefs = await _prefs;
    print(prefs.getString(userId));
    return prefs.getString(userId);
  }

  Future<void> saveUserUid(String uid) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString("userUid", uid);
  }

  Future<void> saveUnicNickName(String nickName) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString("nickName", nickName);
  }
  Future<String> getUnicNickName() async {
    final SharedPreferences prefs = await _prefs;
     String nickName = await prefs.getString("nickName")!;
     return nickName;
  }

  Future<String> getUserUid() async {
    final SharedPreferences prefs = await _prefs;
    String uid = await prefs.getString("userUid")!;
    return uid;
  }

  Future<void> saveUserInfo(String name, String surname) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString("name", name);
    await prefs.setString("surname", surname);
  }
  Future<List<String>> getUserInfo() async {
    final SharedPreferences prefs = await _prefs;
    String? name = await prefs.getString("name");
    String? surname = await prefs.getString("surname");
    if (name == null || surname == null) {
      return ["Trabble", "Trabble"];
    } else return [name, surname];
  }

  Future<void> clearAll() async {
    SharedPreferences prefs = await _prefs;
    await prefs.clear();
  }

  // Future<void> saveUser(UserModel user) async {
  //   final SharedPreferences prefs = await _prefs;
  //   String userJson = user.toJson();
  //   await prefs.setString("user", userJson);
  // }
  // Future<UserModel> getUser() async {
  //   final SharedPreferences prefs = await _prefs;
  //   String? user = prefs.getString("user");
  //   UserModel us = UserModel.fromJson(user!);
  //   return us;
  // }
}
