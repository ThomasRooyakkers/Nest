import 'dart:io';

import 'package:test/test.dart';

import 'integration/endpoint_registry.dart';

/// Reads `endpoint.method` names from the generated protocol.yaml.
Set<String> generatedMethods() {
  final lines = File('lib/src/generated/protocol.yaml').readAsLinesSync();
  final methods = <String>{};
  String? endpoint;
  for (final line in lines) {
    final endpointMatch = RegExp(r'^(\w+):$').firstMatch(line);
    final methodMatch = RegExp(r'^\s+- (\w+):$').firstMatch(line);
    if (endpointMatch != null) endpoint = endpointMatch.group(1);
    if (methodMatch != null) methods.add('$endpoint.${methodMatch.group(1)}');
  }
  return methods;
}

void main() {
  test('every endpoint method is classified in endpoint_registry.dart', () {
    final classified = {
      ...householdScopedMethods,
      ...adminMethods,
      ...unscopedMethods,
    };
    expect(generatedMethods(), isNotEmpty);
    expect(
      generatedMethods().difference(classified),
      isEmpty,
      reason:
          'Add new methods to endpoint_registry.dart and to the '
          'isolation or admin test.',
    );
    expect(classified.difference(generatedMethods()), isEmpty);
  });

  test('admin methods all live on admin endpoints', () {
    expect(adminMethods.every((m) => m.startsWith('admin')), isTrue);
  });
}
