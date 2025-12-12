import 'package:flutter/material.dart';
import 'package:omni_for_pyload/features/error_dialog/ui/error_dialog.dart';

/// Bottom sheet widget for configuring a Click'N'Load server.
class AddClickNLoadBottomSheet extends StatefulWidget {
  /// The server IP to pre-fill in the form
  final String defaultIp;

  /// Callback when the user adds a Click'N'Load server configuration
  /// Parameters: ip, port, protocol, allowInsecureConnections
  /// Returns true if the configuration was saved successfully
  final Future<bool> Function(
    String ip,
    int port,
    String protocol,
    bool allowInsecureConnections,
  )
  onAdd;

  const AddClickNLoadBottomSheet({
    required this.defaultIp,
    required this.onAdd,
    super.key,
  });

  @override
  State<AddClickNLoadBottomSheet> createState() =>
      _AddClickNLoadBottomSheetState();
}

class _AddClickNLoadBottomSheetState extends State<AddClickNLoadBottomSheet> {
  late final TextEditingController _ipController;
  late final TextEditingController _portController;
  int _selectedProtocolIndex = 0; // 0 = http, 1 = https
  bool _allowInsecureConnections = false;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController(text: widget.defaultIp);
    _portController = TextEditingController(text: "9666");
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  String get _selectedProtocol =>
      _selectedProtocolIndex == 0 ? 'http' : 'https';

  Future<void> _addClickNLoadServer() async {
    final ip = _ipController.text.trim();
    final portText = _portController.text.trim();

    // Validate IP / hostname
    if (ip.isEmpty) {
      showErrorDialog(context, 'IP or hostname is required');
      return;
    }

    // Validate port
    int? port;
    try {
      port = int.parse(portText);
    } catch (e) {
      showErrorDialog(context, 'Port must be a valid number');
      return;
    }

    if (port <= 0 || port > 65535) {
      showErrorDialog(context, 'Port must be between 1 and 65535');
      return;
    }

    setState(() => _isAdding = true);

    final success = await widget.onAdd(
      ip,
      port,
      _selectedProtocol,
      _allowInsecureConnections,
    );

    if (mounted) {
      if (success) {
        Navigator.pop(context);
      } else {
        setState(() => _isAdding = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              "Add Click'N'Load server",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // IP / Hostname input
            TextField(
              controller: _ipController,
              enabled: !_isAdding,
              decoration: const InputDecoration(
                labelText: 'IP / Hostname',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Port input
            TextField(
              controller: _portController,
              enabled: !_isAdding,
              decoration: const InputDecoration(
                labelText: 'Port',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),

            // Protocol toggle
            Center(
              child: ToggleButtons(
                isSelected: [
                  _selectedProtocolIndex == 0,
                  _selectedProtocolIndex == 1,
                ],
                onPressed: _isAdding
                    ? null
                    : (index) {
                        setState(() {
                          _selectedProtocolIndex = index;
                          // Reset insecure checkbox when switching to http
                          if (index == 0) {
                            _allowInsecureConnections = false;
                          }
                        });
                      },
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('http'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('https'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Insecure connections checkbox (only visible for https)
            if (_selectedProtocolIndex == 1) ...[
              CheckboxListTile(
                value: _allowInsecureConnections,
                onChanged: _isAdding
                    ? null
                    : (value) {
                        setState(() {
                          _allowInsecureConnections = value ?? false;
                        });
                      },
                title: const Text('Allow insecure connections'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Warning: potentially dangerous',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 8),

            // Add button
            ElevatedButton(
              onPressed: _isAdding ? null : _addClickNLoadServer,
              child: _isAdding
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Add Click'N'Load server"),
            ),
          ],
        ),
      ),
    );
  }
}
