import 'package:flutter/material.dart';
import 'package:openapi_client/api.dart';
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
  late Set<int> _expandedQueueItems;

  @override
  void initState() {
    super.initState();
    _expandedQueueItems = {};
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

  void _toggleQueueItem(int index) {
    setState(() {
      if (_expandedQueueItems.contains(index)) {
        _expandedQueueItems.remove(index);
      } else {
        _expandedQueueItems.clear();
        _expandedQueueItems.add(index);
      }
    });
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
          _expandedQueueItems.clear();
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
        return _buildQueueTab();
      case 2:
        return _buildCollectorTab();
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

  Widget _buildQueueTab() {
    return _buildPackageListTab(
      packages: _viewModel.queueData,
      emptyMessage: 'No packages in queue',
    );
  }

  Widget _buildCollectorTab() {
    return _buildPackageListTab(
      packages: _viewModel.collectorData,
      emptyMessage: 'No packages in collector',
    );
  }

  Widget _buildPackageListTab({
    required List<PackageData> packages,
    required String emptyMessage,
  }) {
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

    if (packages.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.builder(
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final package = packages[index];
        final isExpanded = _expandedQueueItems.contains(index);
        final linksDone = package.linksdone ?? 0;
        final linksTotal = package.links?.length ?? 0;

        return GestureDetector(
          onTap: () => _toggleQueueItem(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Package name spanning full width at the top
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        package.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: linksTotal > 0 ? linksDone / linksTotal : 0,
                        minHeight: 6,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue[400] ?? Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row with size, percentage, and links
                              Row(
                                children: [
                                  // Left-aligned: size
                                  Expanded(
                                    child: Text(
                                      '${_formatBytes(package.sizedone)} / ${_formatBytes(package.sizetotal)}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ),
                                  // Right-aligned: links
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '$linksDone / $linksTotal',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Arrow indicator on the right edge
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            12.0,
                            12.0,
                            0,
                            12.0,
                          ),
                          child: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expanded state - show file list
                  if (isExpanded &&
                      package.links != null &&
                      package.links!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: package.links!.length,
                        itemBuilder: (context, fileIndex) {
                          final file = package.links![fileIndex];
                          final statusIcon = _getStatusIcon(file.status);

                          return Container(
                            decoration: BoxDecoration(
                              border: fileIndex < package.links!.length - 1
                                  ? Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[200]!,
                                      ),
                                    )
                                  : null,
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Status icon on the left
                                if (statusIcon != null)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Icon(
                                      statusIcon,
                                      color: Colors.grey[600],
                                      size: 20,
                                    ),
                                  ),
                                // File details on the right
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // File name with marquee effect
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          file.name,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Bottom row with statusmsg, size, and plugin
                                      Row(
                                        children: [
                                          // Left-aligned: statusmsg
                                          Expanded(
                                            child: Text(
                                              file.statusmsg,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
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
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
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
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
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
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
