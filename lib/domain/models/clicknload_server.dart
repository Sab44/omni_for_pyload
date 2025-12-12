class ClickNLoadServer {
  final String ip;
  final int port;
  final String protocol;
  final bool allowInsecureConnections;

  ClickNLoadServer({
    required this.ip,
    required this.port,
    required this.protocol,
    required this.allowInsecureConnections,
  });

  /// Get the base URL for this ClickNLoadServer
  String get baseUrl {
    return '$protocol://$ip:$port';
  }
}
