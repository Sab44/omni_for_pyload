import 'package:hive/hive.dart';

part 'clicknload_server.g.dart';

@HiveType(typeId: 1)
class ClickNLoadServer extends HiveObject {
  @HiveField(0)
  late String ip;

  @HiveField(1)
  late int port;

  @HiveField(2)
  late String protocol;

  @HiveField(3)
  late bool allowInsecureConnections;

  /// The server identifier (IP:port) that this ClickNLoadServer is associated with
  @HiveField(4)
  late String serverIdentifier;

  ClickNLoadServer({
    required this.ip,
    required this.port,
    required this.protocol,
    required this.allowInsecureConnections,
    required this.serverIdentifier,
  });

  /// Get the base URL for this ClickNLoadServer
  String get baseUrl {
    return '$protocol://$ip:$port';
  }

  /// Create a copy of this ClickNLoadServer with optional field overrides
  ClickNLoadServer copyWith({
    String? ip,
    int? port,
    String? protocol,
    bool? allowInsecureConnections,
    String? serverIdentifier,
  }) {
    return ClickNLoadServer(
      ip: ip ?? this.ip,
      port: port ?? this.port,
      protocol: protocol ?? this.protocol,
      allowInsecureConnections:
          allowInsecureConnections ?? this.allowInsecureConnections,
      serverIdentifier: serverIdentifier ?? this.serverIdentifier,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClickNLoadServer &&
          runtimeType == other.runtimeType &&
          ip == other.ip &&
          port == other.port &&
          protocol == other.protocol &&
          allowInsecureConnections == other.allowInsecureConnections &&
          serverIdentifier == other.serverIdentifier;

  @override
  int get hashCode =>
      ip.hashCode ^
      port.hashCode ^
      protocol.hashCode ^
      allowInsecureConnections.hashCode ^
      serverIdentifier.hashCode;
}
