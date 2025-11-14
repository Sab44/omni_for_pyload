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
    // Start polling immediately since the first tab (Overview) is selected by default
    _viewModel.setSelectedTab(0);
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
        return _buildOverviewTab();
      case 1:
        return const Center(child: Text('Queue Tab'));
      case 2:
        return const Center(child: Text('Collector Tab'));
      default:
        return const Center(child: Text('Overview Tab'));
    }
  }

  Widget _buildOverviewTab() {
    if (_viewModel.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text('Error: ${_viewModel.error}'),
          ],
        ),
      );
    }

    if (_viewModel.downloads.isEmpty) {
      return const Center(child: Text('No active downloads'));
    }

    return ListView.builder(
      itemCount: _viewModel.downloads.length,
      itemBuilder: (context, index) {
        final download = _viewModel.downloads[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Download name with marquee effect
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  download.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: download.percent / 100,
                  minHeight: 6,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue[400] ?? Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Row with speed, percentage, and format size
              Row(
                children: [
                  // Left-aligned: speed
                  Expanded(
                    child: Text(
                      'Speed: ${(download.speed / 1048576).toStringAsFixed(2)} MB/s',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  // Center-aligned: percentage
                  Expanded(
                    child: Center(
                      child: Text(
                        '${download.percent}%',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  // Right-aligned: format size
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        download.formatSize,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
