/// Format bytes to the next higher unit (KB, MB, GB, TB)
/// until the whole number is below 1000 or TB is reached
String formatBytes(num? bytes) {
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
