// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerAdapter extends TypeAdapter<Server> {
  @override
  final int typeId = 0;

  @override
  Server read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Server(
      ip: fields[0] as String,
      port: fields[1] as int,
      username: fields[2] as String,
      password: fields[3] as String,
      protocol: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Server obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.ip)
      ..writeByte(1)
      ..write(obj.port)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.protocol);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
