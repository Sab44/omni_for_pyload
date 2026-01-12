import 'package:flutter/material.dart';
import 'package:omni_for_pyload/core/utils/format_utils.dart';
import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

/// Widget that displays a list of packages (used for Queue and Collector tabs).
class PackageListTab extends StatelessWidget {
  final List<PackageData> packages;
  final String emptyMessage;
  final String? error;
  final Set<int> selectedPackageIds;
  final bool isSelectionMode;
  final Server server;
  final void Function(int packageId) onToggleSelection;
  final void Function(int packageId) onPackageTap;

  const PackageListTab({
    required this.packages,
    required this.emptyMessage,
    required this.selectedPackageIds,
    required this.isSelectionMode,
    required this.server,
    required this.onToggleSelection,
    required this.onPackageTap,
    this.error,
    super.key,
  });

  Color _getProgressBarColor(int linksDone, int linksTotal) {
    if (linksDone == linksTotal) {
      return Colors.lightGreen[400] ?? Colors.lightGreen;
    } else {
      return Colors.blue[400] ?? Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return _buildErrorUI(context);
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
        final isSelected = selectedPackageIds.contains(package.pid);

        return Material(
          color: isSelected
              ? Theme.of(context).primaryColor.withAlpha(100)
              : Colors.transparent,
          child: InkWell(
            onTap: () {
              if (isSelectionMode) {
                onToggleSelection(package.pid);
              } else {
                onPackageTap(package.pid);
              }
            },
            onLongPress: () {
              onToggleSelection(package.pid);
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
                        style: Theme.of(context).textTheme.bodySmall,
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
                              '${formatBytes(package.sizedone)} / ${formatBytes(package.sizetotal)}',
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

  Widget _buildErrorUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Error: $error'),
          ),
        ],
      ),
    );
  }
}
