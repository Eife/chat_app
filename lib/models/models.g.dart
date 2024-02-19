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
      name: fields[1] as String,
      surname: fields[2] as String,
      chatId: fields[3] as String,
      isRead: fields[4] as bool,
      lastMessage: fields[5] as String,
      timeStamp: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModelToHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.surname)
      ..writeByte(3)
      ..write(obj.chatId)
      ..writeByte(4)
      ..write(obj.isRead)
      ..writeByte(5)
      ..write(obj.lastMessage)
      ..writeByte(6)
      ..write(obj.timeStamp);
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
