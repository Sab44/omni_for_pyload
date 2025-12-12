import 'package:hive/hive.dart';
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';

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

  @HiveField(5)
  late String name;

  // Click'N'Load configuration (nullable - not configured by default)
  @HiveField(6)
  String? clickNLoadIp;

  @HiveField(7)
  int? clickNLoadPort;

  @HiveField(8)
  String? clickNLoadProtocol;

  @HiveField(9)
  bool? clickNLoadAllowInsecure;

  Server({
    required this.ip,
    required this.port,
    required this.username,
    required this.password,
    required this.protocol,
    this.name = 'pyLoad',
    this.clickNLoadIp,
    this.clickNLoadPort,
    this.clickNLoadProtocol,
    this.clickNLoadAllowInsecure,
  });

  /// Check if Click'N'Load is configured for this server
  bool get hasClickNLoad =>
      clickNLoadIp != null &&
      clickNLoadPort != null &&
      clickNLoadProtocol != null &&
      clickNLoadAllowInsecure != null;

  /// Get a ClickNLoadServer instance from the configured properties
  /// Returns null if Click'N'Load is not configured
  ClickNLoadServer? get clickNLoadServer {
    if (!hasClickNLoad) return null;
    return ClickNLoadServer(
      ip: clickNLoadIp!,
      port: clickNLoadPort!,
      protocol: clickNLoadProtocol!,
      allowInsecureConnections: clickNLoadAllowInsecure!,
    );
  }

  /// Configure Click'N'Load for this server
  void configureClickNLoad({
    required String ip,
    required int port,
    required String protocol,
    required bool allowInsecureConnections,
  }) {
    clickNLoadIp = ip;
    clickNLoadPort = port;
    clickNLoadProtocol = protocol;
    clickNLoadAllowInsecure = allowInsecureConnections;
  }

  /// Clear Click'N'Load configuration for this server
  void clearClickNLoad() {
    clickNLoadIp = null;
    clickNLoadPort = null;
    clickNLoadProtocol = null;
    clickNLoadAllowInsecure = null;
  }

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
    String? name,
    String? clickNLoadIp,
    int? clickNLoadPort,
    String? clickNLoadProtocol,
    bool? clickNLoadAllowInsecure,
  }) {
    return Server(
      ip: ip ?? this.ip,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      protocol: protocol ?? this.protocol,
      name: name ?? this.name,
      clickNLoadIp: clickNLoadIp ?? this.clickNLoadIp,
      clickNLoadPort: clickNLoadPort ?? this.clickNLoadPort,
      clickNLoadProtocol: clickNLoadProtocol ?? this.clickNLoadProtocol,
      clickNLoadAllowInsecure:
          clickNLoadAllowInsecure ?? this.clickNLoadAllowInsecure,
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
          protocol == other.protocol &&
          name == other.name &&
          clickNLoadIp == other.clickNLoadIp &&
          clickNLoadPort == other.clickNLoadPort &&
          clickNLoadProtocol == other.clickNLoadProtocol &&
          clickNLoadAllowInsecure == other.clickNLoadAllowInsecure;

  @override
  int get hashCode =>
      ip.hashCode ^
      port.hashCode ^
      username.hashCode ^
      password.hashCode ^
      protocol.hashCode ^
      name.hashCode ^
      clickNLoadIp.hashCode ^
      clickNLoadPort.hashCode ^
      clickNLoadProtocol.hashCode ^
      clickNLoadAllowInsecure.hashCode;
}
