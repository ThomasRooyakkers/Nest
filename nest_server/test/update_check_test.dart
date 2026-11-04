import 'package:nest_server/src/services/update_check.dart';
import 'package:test/test.dart';

void main() {
  test('newest picks the highest version and ignores other tags', () {
    expect(
      UpdateCheck.newest(['v0.9.0', 'v0.13.1', 'v0.10.2', 'latest', '1.0']),
      '0.13.1',
    );
    expect(UpdateCheck.newest(['nightly']), isNull);
  });

  test('isNewer compares numerically, not as text', () {
    expect(UpdateCheck.isNewer('0.13.0', '0.9.9'), isTrue);
    expect(UpdateCheck.isNewer('v0.13.1', '0.13.1'), isFalse);
    expect(UpdateCheck.isNewer('0.13.0', '0.13.1'), isFalse);
  });
}
