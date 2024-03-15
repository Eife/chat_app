import 'package:chat_app/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OptionsFirestoreBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addMessageToFirestore(
      {required String chatId, required Message message}) async {
    try {
      await FirebaseFirestore.instance
          .collection("chat")
          .doc(chatId)
          .collection("messages")
          .add(message.toMap());
      print("Сообщение успешно добавлено.");
    } catch (e) {
      print("Ошибка при добавлении сообщения: $e");
    }
  }

  Future<List<UserModel>> findNewUsers(String symbolToFind) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("unicNickName", isGreaterThanOrEqualTo: symbolToFind)
        .where('unicNickName', isLessThan: symbolToFind + "\uf8ff")
        .get();

    List<UserModel> users = querySnapshot.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return UserModel.fromMap(data);
    }).toList();
    return users;
  }

  Future<void> updateLastMessageInfo(
      LastMessageInfo lastMessageInfo, String chatId) async {
    await FirebaseFirestore.instance.collection("chat").doc(chatId).update({
      "lastMessageInfo": lastMessageInfo.toMap(),
    });
  }

  Future<String> findChat(String you, String companion) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("chat")
        .where("participants",
            whereIn: [you, companion]).get(); //Под вопросом, может не работать
    if (querySnapshot.docs.isEmpty) {
      throw FormatException("Отсутствие базы");
    }
    String chatId = querySnapshot.docs.first.id;

    return chatId;
  }

  Future<void> saveToCollectionChat(String chatId, Chat newChat) async {
    await FirebaseFirestore.instance
        .collection("chat")
        .doc(chatId)
        .set(newChat.toMap());
  }

  Future<void> updateTwoUsersChatsField(
      String uid, String companion, String chatId) async {
    // Обновляем документ текущего пользователя, UID собеседника
    FirebaseFirestore.instance.collection("users").doc(uid).set({
      'chat': {
        companion: chatId,
      }
    }, SetOptions(merge: true));

    // Наоборот
    FirebaseFirestore.instance.collection("users").doc(companion).set({
      'chat': {
        uid: chatId,
      }
    }, SetOptions(merge: true));
  }

  Future<List<Message>> showLastMessageInDialog(String chatId) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("chat")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(20)
        .get();
    for (var doc in querySnapshot.docs) {}
    final List<Message> showAllMessages = querySnapshot.docs
        .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    return showAllMessages;
  }

  Future<void> deleteAllDatabase(String userUid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("users").doc(userUid).get();
    Map<String, dynamic>? snap = snapshot.data();

    if (snap != null && snap.containsKey("chat")) {
      Map<String, dynamic> chatMap = snap["chat"];
      List<String> chatIds = chatMap.values.cast<String>().toList();

      if (chatIds.isNotEmpty) {
        for (var chatId in chatIds) {
          await FirebaseFirestore.instance
              .collection("chats")
              .doc(chatId)
              .delete();
        }
      }
    } else {
      print("No chat data available");
    }
    await FirebaseAuth.instance.currentUser!.delete();

    await FirebaseAuth.instance.signOut();

    await FirebaseFirestore.instance.collection("users").doc(userUid).delete();
  }

  Stream<List<Message>> messagesStream(
      String chatId, Timestamp lastFetchedMessageTimestamp) {
    print(lastFetchedMessageTimestamp);
    return _firestore
        .collection("chat")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .startAfter([lastFetchedMessageTimestamp])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
