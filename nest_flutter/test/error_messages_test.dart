import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/core/backend/error_messages.dart';
import 'package:nest_flutter/l10n/app_localizations.dart';
import 'package:nest_flutter/l10n/app_localizations_en.dart';
import 'package:nest_flutter/l10n/app_localizations_nl.dart';

void main() {
  for (final AppLocalizations l10n in [
    AppLocalizationsEn(),
    AppLocalizationsNl(),
  ]) {
    test('every NestErrorCode has its own ${l10n.localeName} message', () {
      final messages = {
        for (final code in NestErrorCode.values)
          errorMessage(l10n, NestException(code: code)),
      };
      expect(messages, hasLength(NestErrorCode.values.length));
      expect(messages, isNot(contains(l10n.errorUnknown)));
    });
  }

  test('unknown errors get the generic message', () {
    final l10n = AppLocalizationsEn();
    expect(errorMessage(l10n, StateError('x')), l10n.errorUnknown);
  });
}
