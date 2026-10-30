import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

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

  /// The active household whose current invite code is [code].
  ///
  /// Throws [NestErrorCode.invalidInviteCode] when there is none and
  /// [NestErrorCode.inviteExpired] when the code has expired.
  static Future<Household> findHousehold(
    Session session,
    String code, {
    Transaction? transaction,
  }) async {
    final normalized = normalize(code);
    if (normalized.length != length) {
      throw NestException(code: NestErrorCode.invalidInviteCode);
    }

    final household = await Household.db.findFirstRow(
      session,
      where: (t) => t.inviteCode.equals(normalized),
      transaction: transaction,
    );
    if (household == null || household.status != HouseholdStatus.active) {
      throw NestException(code: NestErrorCode.invalidInviteCode);
    }
    final expiresAt = household.inviteExpiresAt;
    if (expiresAt == null || expiresAt.isBefore(DateTime.now())) {
      throw NestException(code: NestErrorCode.inviteExpired);
    }
    return household;
  }
}
