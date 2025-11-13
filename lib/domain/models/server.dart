import 'package:hive/hive.dart';

part 'server.g.dart';

@HiveType(typeId: 0)
class Server extends HiveObject {
  @HiveField(0)
  late String ip;

  @HiveField(1)
  late int port;

  @HiveField(2)
  late String username;

  @HiveField(3)
  late String password;

  @HiveField(4)
  late String protocol;

  Server({
    required this.ip,
    required this.port,
    required this.username,
    required this.password,
    required this.protocol,
  });

  /// Get the base URL for this server
  String get baseUrl {
    return '$protocol://$ip:$port';
  }

  /// Create a copy of this server with optional field overrides
  Server copyWith({
    String? ip,
    int? port,
    String? username,
    String? password,
    String? protocol,
  }) {
    return Server(
      ip: ip ?? this.ip,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      protocol: protocol ?? this.protocol,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Server &&
          runtimeType == other.runtimeType &&
          ip == other.ip &&
          port == other.port &&
          username == other.username &&
          password == other.password &&
          protocol == other.protocol;

  @override
  int get hashCode =>
      ip.hashCode ^
      port.hashCode ^
      username.hashCode ^
      password.hashCode ^
      protocol.hashCode;
}
