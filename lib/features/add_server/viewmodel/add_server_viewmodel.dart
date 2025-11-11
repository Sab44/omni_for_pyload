import 'package:omni_for_pyload/data/repositories/server_repository.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

class AddServerViewModel {
  /// Validate and add a server
  /// Returns the server if successful, or throws an exception with error message
  Future<Server> validateAndAddServer({
    required String ip,
    required String port,
    required String username,
    required String password,
    required bool isHttps,
  }) async {
    // Validate IP/Hostname
    if (ip.isEmpty) {
      throw 'IP or hostname is required';
    }

    // Validate port
    int? portNumber;
    try {
      portNumber = int.parse(port);
    } catch (e) {
      throw 'Port must be a valid number';
    }

    if (portNumber <= 0 || portNumber > 65535) {
      throw 'Port must be between 1 and 65535';
    }

    // Validate username
    if (username.isEmpty) {
      throw 'Username is required';
    }

    // Validate password
    if (password.isEmpty) {
      throw 'Password is required';
    }

    // Check if server with same IP and port already exists
    final exists = await ServerRepository.serverExists(ip, portNumber);
    if (exists) {
      throw 'A server with this IP and port already exists';
    }

    // Create and save server
    final server = Server(
      ip: ip,
      port: portNumber,
      username: username,
      password: password,
      isHttps: isHttps,
    );

    await ServerRepository.addServer(server);
    return server;
  }
}
