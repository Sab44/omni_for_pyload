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
      allowInsecure: fields[6] as bool,
      name: fields[5] as String,
      clickNLoadIp: fields[7] as String?,
      clickNLoadPort: fields[8] as int?,
      clickNLoadProtocol: fields[9] as String?,
      clickNLoadAllowInsecure: fields[10] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Server obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.ip)
      ..writeByte(1)
      ..write(obj.port)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.protocol)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.allowInsecure)
      ..writeByte(7)
      ..write(obj.clickNLoadIp)
      ..writeByte(8)
      ..write(obj.clickNLoadPort)
      ..writeByte(9)
      ..write(obj.clickNLoadProtocol)
      ..writeByte(10)
      ..write(obj.clickNLoadAllowInsecure);
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
