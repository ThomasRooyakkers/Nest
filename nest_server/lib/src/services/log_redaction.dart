/// Removes personal details from log text before it is stored in a
/// security event or shown in the admin portal.
abstract final class LogRedaction {
  static final _email = RegExp(
    r'[A-Za-z0-9._%+\-]+@([A-Za-z0-9\-]+\.)+[A-Za-z]{2,}',
  );

  /// Sign-up and reset codes are logged as `<code>` when mail is off.
  static final _code = RegExp(r'<[A-Za-z0-9]{4,}>');

  /// `thomas@example.com` → `t***@example.com`.
  static String maskEmail(String email) {
    final at = email.indexOf('@');
    if (at <= 0) return '***';
    return '${email[0]}***${email.substring(at)}';
  }

  /// [text] with every email masked and every code hidden, shortened to
  /// [maxLength] characters.
  static String redact(String text, {int maxLength = 4000}) {
    final redacted = text
        .replaceAllMapped(_email, (m) => maskEmail(m[0]!))
        .replaceAll(_code, '<code>');
    return redacted.length <= maxLength
        ? redacted
        : '${redacted.substring(0, maxLength)}…';
  }

  static String? redactOrNull(String? text, {int maxLength = 4000}) =>
      text == null ? null : redact(text, maxLength: maxLength);

  /// The first line of [text], redacted and at most [maxLength] long.
  static String? firstLine(String? text, {int maxLength = 300}) {
    if (text == null) return null;
    final line = text.trim().split('\n').first;
    return redact(line, maxLength: maxLength);
  }
}
