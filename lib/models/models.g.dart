// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelToHiveAdapter extends TypeAdapter<UserModelToHive> {
  @override
  final int typeId = 0;

  @override
  UserModelToHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModelToHive(
      uid: fields[0] as String,
      unicNickName: fields[1] as String,
      name: fields[2] as String,
      surname: fields[3] as String,
      activity: fields[4] as bool,
      chat: (fields[5] as Map).cast<String, String>(),
      lastSeen: fields[6] as String,
      chatId: fields[7] as String,
      isRead: fields[8] as bool,
      lastMessage: fields[9] as String,
      timeStamp: fields[10] as String,
      aboutMe: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModelToHive obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.unicNickName)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.surname)
      ..writeByte(4)
      ..write(obj.activity)
      ..writeByte(5)
      ..write(obj.chat)
      ..writeByte(6)
      ..write(obj.lastSeen)
      ..writeByte(7)
      ..write(obj.chatId)
      ..writeByte(8)
      ..write(obj.isRead)
      ..writeByte(9)
      ..write(obj.lastMessage)
      ..writeByte(10)
      ..write(obj.timeStamp)
      ..writeByte(11)
      ..write(obj.aboutMe);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelToHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
