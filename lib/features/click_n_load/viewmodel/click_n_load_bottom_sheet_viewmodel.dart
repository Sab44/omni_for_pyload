/// Result of validating Click'N'Load configuration
sealed class ClickNLoadValidationResult {}

/// Validation was successful
class ClickNLoadValidationSuccess extends ClickNLoadValidationResult {
  final String ip;
  final int port;
  final String protocol;
  final bool allowInsecureConnections;

  ClickNLoadValidationSuccess({
    required this.ip,
    required this.port,
    required this.protocol,
    required this.allowInsecureConnections,
  });
}

/// Validation failed with an error message
class ClickNLoadValidationError extends ClickNLoadValidationResult {
  final String message;

  ClickNLoadValidationError(this.message);
}

/// ViewModel for the Click'N'Load bottom sheet
/// Handles validation and business logic for configuring Click'N'Load servers
class ClickNLoadBottomSheetViewModel {
  /// The callback to save the Click'N'Load configuration
  final Future<bool> Function(
    String ip,
    int port,
    String protocol,
    bool allowInsecureConnections,
  )
  onSave;

  ClickNLoadBottomSheetViewModel({required this.onSave});

  /// Validates the Click'N'Load configuration
  /// Returns a [ClickNLoadValidationResult] indicating success or failure
  ClickNLoadValidationResult validate({
    required String ip,
    required String portText,
    required String protocol,
    required bool allowInsecureConnections,
  }) {
    final trimmedIp = ip.trim();
    final trimmedPort = portText.trim();

    // Validate IP / hostname
    if (trimmedIp.isEmpty) {
      return ClickNLoadValidationError('IP or hostname is required');
    }

    // Validate port
    int? port;
    try {
      port = int.parse(trimmedPort);
    } catch (e) {
      return ClickNLoadValidationError('Port must be a valid number');
    }

    if (port <= 0 || port > 65535) {
      return ClickNLoadValidationError('Port must be between 1 and 65535');
    }

    return ClickNLoadValidationSuccess(
      ip: trimmedIp,
      port: port,
      protocol: protocol,
      allowInsecureConnections: allowInsecureConnections,
    );
  }

  /// Validates and saves the Click'N'Load configuration
  /// Returns true if the configuration was saved successfully, false otherwise
  /// The [onError] callback is called when validation fails
  Future<bool> validateAndSave({
    required String ip,
    required String portText,
    required String protocol,
    required bool allowInsecureConnections,
    required void Function(String errorMessage) onError,
  }) async {
    final result = validate(
      ip: ip,
      portText: portText,
      protocol: protocol,
      allowInsecureConnections: allowInsecureConnections,
    );

    switch (result) {
      case ClickNLoadValidationError():
        onError(result.message);
        return false;
      case ClickNLoadValidationSuccess():
        return await onSave(
          result.ip,
          result.port,
          result.protocol,
          result.allowInsecureConnections,
        );
    }
  }
}
