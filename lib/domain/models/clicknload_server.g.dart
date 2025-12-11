// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clicknload_server.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClickNLoadServerAdapter extends TypeAdapter<ClickNLoadServer> {
  @override
  final int typeId = 1;

  @override
  ClickNLoadServer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClickNLoadServer(
      ip: fields[0] as String,
      port: fields[1] as int,
      protocol: fields[2] as String,
      allowInsecureConnections: fields[3] as bool,
      serverIdentifier: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClickNLoadServer obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.ip)
      ..writeByte(1)
      ..write(obj.port)
      ..writeByte(2)
      ..write(obj.protocol)
      ..writeByte(3)
      ..write(obj.allowInsecureConnections)
      ..writeByte(4)
      ..write(obj.serverIdentifier);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClickNLoadServerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
