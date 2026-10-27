import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/household/household_repository.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/settings/data/profile_repository.dart';

part 'app_gate.g.dart';

/// Which part of the app the user may see. Drives the router redirects.
enum AppGate {
  /// Signed in, profile or households still loading.
  loading,

  /// Signed in, but loading the profile or households failed.
  unavailable,
  signedOut,

  /// Signed in for the first time; the name is still missing.
  needsName,

  /// Signed in without any household yet.
  needsHousehold,
  ready,
}

@Riverpod(keepAlive: true)
AppGate appGate(Ref ref) {
  if (!ref.watch(signedInProvider)) return AppGate.signedOut;

  final user = ref.watch(currentUserProvider);
  final households = ref.watch(myHouseholdsProvider);
  if (user.hasError || households.hasError) return AppGate.unavailable;
  if (!user.hasValue || !households.hasValue) return AppGate.loading;

  if (user.requireValue?.name.isEmpty ?? true) return AppGate.needsName;
  if (households.requireValue.isEmpty) return AppGate.needsHousehold;
  return AppGate.ready;
}
