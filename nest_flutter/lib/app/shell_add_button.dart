import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_shared/nest_shared.dart';

/// The round + button of a tab screen, kept above the floating tab bar.
///
/// On Android, Material shows a button's tooltip below it after a long
/// press, where it covers the tab bar; there [label] is only given to
/// screen readers (TalkBack). iOS keeps the tooltip.
class ShellAddButton extends StatelessWidget {
  const ShellAddButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.tabBarSpace,
  });

  final String label;
  final VoidCallback onPressed;

  /// Height of the floating tab bar: `MediaQuery.paddingOf(context).bottom`
  /// read by the screen outside its own Scaffold, which removes it for the
  /// button.
  final double tabBarSpace;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final android = Theme.of(context).platform == TargetPlatform.android;
    return Padding(
      // The shell's tab bar floats over the body, which the button's
      // default position ignores.
      padding: EdgeInsets.only(bottom: tabBarSpace),
      child: FloatingActionButton(
        tooltip: android ? null : label,
        backgroundColor: colors.accent,
        foregroundColor: colors.onAccent,
        elevation: 0,
        shape: const CircleBorder(),
        onPressed: onPressed,
        // The button reads its icon's label out.
        child: Icon(LucideIcons.plus, semanticLabel: android ? label : null),
      ),
    );
  }
}
