import 'package:nest_server/src/services/log_redaction.dart';
import 'package:test/test.dart';

void main() {
  test('emails are masked and codes hidden', () {
    expect(
      LogRedaction.redact('Code for thomas.r@mail.example.be: <K7PM3Q>'),
      'Code for t***@mail.example.be: <code>',
    );
  });

  test('text is shortened', () {
    expect(LogRedaction.redact('x' * 10, maxLength: 4), 'xxxx…');
    expect(LogRedaction.firstLine('one\ntwo'), 'one');
  });

  test('a malformed email is fully hidden', () {
    expect(LogRedaction.maskEmail('@x'), '***');
  });
}
