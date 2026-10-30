import 'package:nest_server/src/services/disk_space.dart';
import 'package:test/test.dart';

void main() {
  test('parses df -Pk output', () {
    const output = '''
Filesystem     1024-blocks      Used Available Capacity Mounted on
/dev/sda2        479152840 120000000 340000000      27% /
''';
    expect(parseDf(output), (
      freeBytes: 340000000 * 1024,
      totalBytes: 479152840 * 1024,
    ));
  });

  test('returns null for unexpected output', () {
    expect(parseDf(''), isNull);
    expect(parseDf('Filesystem\nnone'), isNull);
  });
}
