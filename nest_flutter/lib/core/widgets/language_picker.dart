import 'package:flutter/material.dart';
import 'package:nest_shared/nest_shared.dart';

/// English / Nederlands segmented picker.
class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key, required this.onChanged});

  final ValueChanged<Locale> onChanged;

  @override
  Widget build(BuildContext context) {
    final shared = NestSharedLocalizations.of(context);
    return SegmentedButton<String>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(value: 'en', label: Text(shared.languageEnglish)),
        ButtonSegment(value: 'nl', label: Text(shared.languageDutch)),
      ],
      selected: {Localizations.localeOf(context).languageCode},
      onSelectionChanged: (selection) => onChanged(Locale(selection.single)),
    );
  }
}
