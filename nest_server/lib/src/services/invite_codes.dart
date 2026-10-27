import 'dart:math';

/// Generates household invite codes.
abstract final class InviteCodes {
  /// Characters without look-alikes (no 0/O, 1/I/L).
  static const alphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  static const length = 8;

  /// How long a new invite code stays valid.
  static const validFor = Duration(days: 7);

  static final _random = Random.secure();

  static String generate() => String.fromCharCodes(
    List.generate(
      length,
      (_) => alphabet.codeUnitAt(_random.nextInt(alphabet.length)),
    ),
  );

  /// Upper-cases and strips spaces and dashes from a typed code.
  static String normalize(String input) =>
      input.toUpperCase().replaceAll(RegExp(r'[\s-]'), '');
}
