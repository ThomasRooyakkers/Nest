import 'dart:io';

/// Free and total bytes of a disk.
typedef DiskSpace = ({int freeBytes, int totalBytes});

/// Reads the disk the server's files are on with `df`, which exists in the
/// server image (busybox) and on macOS. Null when it cannot be read.
Future<DiskSpace?> readDiskSpace([String path = '.']) async {
  try {
    final result = await Process.run('df', ['-Pk', path]);
    if (result.exitCode != 0) return null;
    return parseDf(result.stdout as String);
  } on Exception {
    return null;
  }
}

/// Parses POSIX `df -Pk` output (1024-byte blocks).
DiskSpace? parseDf(String output) {
  final lines = output.trim().split('\n');
  if (lines.length < 2) return null;
  final columns = lines.last.trim().split(RegExp(r'\s+'));
  if (columns.length < 4) return null;
  final total = int.tryParse(columns[1]);
  final available = int.tryParse(columns[3]);
  if (total == null || available == null) return null;
  return (freeBytes: available * 1024, totalBytes: total * 1024);
}
