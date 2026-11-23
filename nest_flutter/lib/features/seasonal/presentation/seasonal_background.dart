import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../tasks/presentation/task_providers.dart';
import '../domain/seasonal_logic.dart';
import 'seasonal_decor.dart';
import 'seasonal_providers.dart';

/// Falling snow behind a main page's content while the Christmas theme
/// shows. The dashboard has its own backdrop (with the greeting surprise).
class SeasonalBackground extends ConsumerWidget {
  const SeasonalBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockProvider)();
    final theme = ref.watch(
      seasonalThemeProvider(DateTime(now.year, now.month, now.day)),
    );
    if (theme != SeasonalTheme.christmas) return child;
    return Stack(
      children: [
        const Positioned.fill(
          child: SeasonalBackdrop(theme: SeasonalTheme.christmas),
        ),
        child,
      ],
    );
  }
}
