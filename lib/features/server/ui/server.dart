import 'package:flutter/material.dart';
import 'package:omni_for_pyload/core/service_locator.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/features/server/viewmodel/server_viewmodel.dart';

class ServerScreen extends StatefulWidget {
  final Server server;

  const ServerScreen({required this.server, super.key});

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  late ServerViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ServerViewModel(
      server: widget.server,
      pyLoadApiRepository: getIt<IPyLoadApiRepository>(),
    );
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.server.protocol}://${widget.server.ip}:${widget.server.port}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildTabContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _viewModel.selectedTabIndex,
        onTap: (index) {
          _viewModel.setSelectedTab(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Overview',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Queue'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Collector'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_viewModel.selectedTabIndex) {
      case 0:
        return const Center(child: Text('Overview Tab'));
      case 1:
        return const Center(child: Text('Queue Tab'));
      case 2:
        return const Center(child: Text('Collector Tab'));
      default:
        return const Center(child: Text('Overview Tab'));
    }
  }
}
