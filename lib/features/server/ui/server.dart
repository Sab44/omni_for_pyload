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
  static const String _menuResumeQueue = 'Resume Queue';
  static const String _menuPauseQueue = 'Pause Queue';
  static const String _menuStopQueue = 'Stop Queue';
  static const String _menuAddPackage = 'Add Package';
  static const String _menuClearFinished = 'Clear Finished';
  static const String _menuRestartFailed = 'Restart Failed';

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

  /// Format bytes to the next higher unit (KB, MB, GB, TB)
  /// until the whole number is below 1000 or TB is reached
  String _formatBytes(num? bytes) {
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

  Color _getProgressBarColor(int linksDone, int linksTotal) {
    if (linksDone == linksTotal) {
      return Colors.lightGreen[400] ?? Colors.lightGreen;
    } else {
      return Colors.blue[400] ?? Colors.blue;
    }
  }

  Color _getStatusColor(DownloadStatus status) {
    if (status == DownloadStatus.WAITING) {
      return const Color(0xFFF0AD4E);
    } else if (status == DownloadStatus.STARTING) {
      return const Color(0xFF5BC0DE);
    } else if (status == DownloadStatus.DOWNLOADING) {
      return const Color(0xFF5CB85C);
    } else if (status == DownloadStatus.PROCESSING) {
      return const Color(0xFF337AB7);
    } else {
      return const Color(0xFF777777);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _viewModel.isSelectionMode
          ? _buildSelectionAppBar()
          : _buildDefaultAppBar(),
      body: _buildTabContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _viewModel.selectedTabIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.backgroundColor,
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

  PreferredSizeWidget _buildDefaultAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.server.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${widget.server.protocol}://${widget.server.ip}:${widget.server.port}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontSize: 12),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) async {
            bool success = false;
            switch (value) {
              case _menuResumeQueue:
                success = await _viewModel.resumeQueue();
                if (mounted) {
                  _showSnackBar(
                    success
                        ? 'Success: Queue resumed'
                        : 'Error: Failed to resume queue',
                  );
                }
                break;
              case _menuPauseQueue:
                success = await _viewModel.pauseQueue();
                if (mounted) {
                  _showSnackBar(
                    success
                        ? 'Success: Queue paused'
                        : 'Error: Failed to pause queue',
                  );
                }
                break;
              case _menuStopQueue:
                success = await _viewModel.stopQueue();
                if (mounted) {
                  _showSnackBar(
                    success
                        ? 'Success: Queue stopped'
                        : 'Error: Failed to stop queue',
                  );
                }
                break;
              case _menuAddPackage:
                _viewModel.addPackage();
                break;
              case _menuClearFinished:
                success = await _viewModel.clearFinished();
                if (mounted) {
                  _showSnackBar(
                    success
                        ? 'Success: Finished packages cleared'
                        : 'Error: Failed to clear finished packages',
                  );
                }
                break;
              case _menuRestartFailed:
                success = await _viewModel.restartFailed();
                if (mounted) {
                  _showSnackBar(
                    success
                        ? 'Success: Restarted failed packages'
                        : 'Error: Failed to restart failed packages',
                  );
                }
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            final List<PopupMenuEntry<String>> items = [
              const PopupMenuItem(
                value: _menuResumeQueue,
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(_menuResumeQueue),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: _menuPauseQueue,
                child: Row(
                  children: [
                    Icon(Icons.pause, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(_menuPauseQueue),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: _menuStopQueue,
                child: Row(
                  children: [
                    Icon(Icons.stop, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(_menuStopQueue),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: _menuAddPackage,
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(_menuAddPackage),
                  ],
                ),
              ),
            ];

            if (_viewModel.selectedTabIndex == 1 ||
                _viewModel.selectedTabIndex == 2) {
              items.add(const PopupMenuDivider());
              items.add(
                const PopupMenuItem(
                  value: _menuClearFinished,
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.black54),
                      SizedBox(width: 8),
                      Text(_menuClearFinished),
                    ],
                  ),
                ),
              );
              items.add(
                const PopupMenuItem(
                  value: _menuRestartFailed,
                  child: Row(
                    children: [
                      Icon(Icons.restart_alt, color: Colors.black54),
                      SizedBox(width: 8),
                      Text(_menuRestartFailed),
                    ],
                  ),
                ),
              );
            }

            return items;
          },
        ),
      ],
    );
  }

  PreferredSizeWidget _buildSelectionAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => _viewModel.clearSelection(),
      ),
      title: Text('${_viewModel.selectedPackageIds.length}'),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            final success = await _viewModel.deleteSelectedPackages();
            if (mounted) {
              _showSnackBar(
                success
                    ? 'Success: Package(s) deleted.'
                    : 'Error: Package deletion failed.',
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.restart_alt),
          onPressed: () async {
            final result = await _viewModel.restartSelectedPackages();
            if (mounted) {
              String message;
              switch (result) {
                case Result.success:
                  message = 'Success: Package(s) restarted.';
                  break;
                case Result.partial:
                  message = 'Error: Some packages failed to restart.';
                  break;
                case Result.failure:
                  message = 'Error: Package(s) failed to restart.';
                  break;
              }
              _showSnackBar(message);
            }
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'Move') {
              final result = await _viewModel.moveSelectedPackages();
              if (mounted) {
                String message;
                switch (result) {
                  case Result.success:
                    message = 'Success: Packages moved';
                    break;
                  case Result.partial:
                    message = 'Some packages failed to move';
                    break;
                  case Result.failure:
                    message = 'Error: Failed to move packages';
                    break;
                }
                _showSnackBar(message);
              }
            }
            if (value == 'Extract') {
              final result = await _viewModel.extractSelectedPackages();
              if (mounted) {
                _showSnackBar(
                  result
                      ? 'Success: Package extraction triggered.'
                      : 'Error: Failed to trigger package extraction.',
                );
              }
            }
          },
          itemBuilder: (BuildContext context) {
            final moveDestination = _viewModel.selectedTabIndex == 1
                ? 'Collector'
                : 'Queue';
            return [
              PopupMenuItem(
                value: 'Move',
                child: Row(
                  children: [
                    const Icon(Icons.drive_file_move, color: Colors.black54),
                    const SizedBox(width: 8),
                    Text('Move to $moveDestination'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'Extract',
                child: Row(
                  children: [
                    Icon(Icons.unarchive, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Extract'),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
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
      return _buildErrorUI();
    }

    if (_viewModel.downloads.isEmpty) {
      return const Center(child: Text('No active downloads'));
    }

    return ListView.builder(
      itemCount: _viewModel.downloads.length,
      itemBuilder: (context, index) {
        final download = _viewModel.downloads[index];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Download name
                  Text(
                    download.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  // Row with size downloaded, percentage, and total size
                  Row(
                    children: [
                      // Left-aligned: size downloaded
                      Expanded(
                        child: Text(
                          _formatBytes(download.size - download.bleft),
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
                      // Right-aligned: total size
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _formatBytes(download.size),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  LinearProgressIndicator(
                    value: download.percent / 100,
                    minHeight: 6,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue[400] ?? Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row with status chip and speed
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left-aligned: status chip
                      Chip(
                        label: Text(
                          download.statusmsg,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: _getStatusColor(download.status),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                      const Spacer(),
                      // Right-aligned: speed
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${(_formatBytes(download.speed))}/s',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (index < _viewModel.downloads.length - 1)
              Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),
          ],
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

  Widget _buildErrorUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Error: ${_viewModel.error}'),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageListTab({
    required List<PackageData> packages,
    required String emptyMessage,
  }) {
    if (_viewModel.error != null) {
      return _buildErrorUI();
    }

    if (packages.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.builder(
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final package = packages[index];
        final linksDone = package.linksdone ?? 0;
        final linksTotal = package.linkstotal ?? 0;
        final progressBarColor = _getProgressBarColor(linksDone, linksTotal);
        final isSelected = _viewModel.selectedPackageIds.contains(package.pid);

        return Material(
          color: isSelected
              ? Theme.of(context).primaryColor.withAlpha(100)
              : Colors.transparent,
          child: InkWell(
            onTap: () {
              if (_viewModel.isSelectionMode) {
                _viewModel.toggleSelection(package.pid);
              } else {
                Navigator.pushNamed(
                  context,
                  '/download-detail',
                  arguments: {
                    'server': widget.server,
                    'packageId': package.pid,
                  },
                );
              }
            },
            onLongPress: () {
              _viewModel.toggleSelection(package.pid);
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Package name
                      Text(
                        package.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      // Progress bar
                      LinearProgressIndicator(
                        value: linksTotal > 0 ? linksDone / linksTotal : 0,
                        minHeight: 6,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressBarColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Row with size and links
                      Row(
                        children: [
                          // Left-aligned: size
                          Expanded(
                            child: Text(
                              '${_formatBytes(package.sizedone)} / ${_formatBytes(package.sizetotal)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          // Right-aligned: links
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '$linksDone / $linksTotal',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Arrow indicator row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                if (index < packages.length - 1)
                  Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),
              ],
            ),
          ),
        );
      },
    );
  }
}
