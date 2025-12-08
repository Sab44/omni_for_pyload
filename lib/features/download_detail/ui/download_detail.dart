import 'package:flutter/material.dart';
import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/core/service_locator.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/features/download_detail/viewmodel/download_detail_viewmodel.dart';

class DownloadDetailScreen extends StatefulWidget {
  final Server server;
  final int packageId;

  const DownloadDetailScreen({
    required this.server,
    required this.packageId,
    super.key,
  });

  @override
  State<DownloadDetailScreen> createState() => _DownloadDetailScreenState();
}

class _DownloadDetailScreenState extends State<DownloadDetailScreen> {
  late DownloadDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DownloadDetailViewModel(
      server: widget.server,
      packageId: widget.packageId,
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

  /// Format bytes to the next higher unit (KB, MB, GB, TB)
  /// until the whole number is below 1000 or TB is reached
  String _formatBytes(int? bytes) {
    if (bytes == null || bytes == 0) return '0 B';

    final units = ['B', 'KB', 'MB', 'GB', 'TB'];
    double size = bytes.toDouble();
    int unitIndex = 0;

    while (size >= 1000 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    if (unitIndex == 0) {
      return '${size.toInt()} ${units[unitIndex]}';
    } else {
      return '${size.toStringAsFixed(2)} ${units[unitIndex]}';
    }
  }

  /// Get icon based on file download status
  IconData? _getStatusIcon(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.FAILED:
      case DownloadStatus.ABORTED:
      case DownloadStatus.OFFLINE:
        return Icons.cancel;
      case DownloadStatus.FINISHED:
        return Icons.download_done;
      case DownloadStatus.WAITING:
      case DownloadStatus.QUEUED:
        return Icons.access_time;
      case DownloadStatus.SKIPPED:
        return Icons.arrow_forward;
      case DownloadStatus.DOWNLOADING:
        return Icons.downloading;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _viewModel.packageData?.name ?? 'Loading...',
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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

    if (_viewModel.packageData == null) {
      return const Center(child: Text('No package data available'));
    }

    final packageData = _viewModel.packageData!;
    final links = packageData.links ?? [];

    if (links.isEmpty) {
      return const Center(child: Text('No files in this package'));
    }

    return ListView.builder(
      itemCount: links.length,
      itemBuilder: (context, index) {
        final file = links[index];
        final statusIcon = _getStatusIcon(file.status);

        return Container(
          decoration: BoxDecoration(
            border: index < links.length - 1
                ? Border(bottom: BorderSide(color: Colors.grey[200]!))
                : null,
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Status icon on the left
              if (statusIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Icon(statusIcon, color: Colors.grey[600], size: 20),
                ),
              // File details on the right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // File name with marquee effect
                    Text(
                      file.name,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Bottom row with statusmsg, size, and plugin
                    Row(
                      children: [
                        // Left-aligned: statusmsg
                        Expanded(
                          child: Text(
                            file.statusmsg,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Center-aligned: size
                        Expanded(
                          child: Center(
                            child: Text(
                              _formatBytes(file.size),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                        ),
                        // Right-aligned: plugin
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              file.plugin,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 11,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
