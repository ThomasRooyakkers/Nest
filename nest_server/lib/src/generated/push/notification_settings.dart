/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

/// The signed-in user's notification switches as the app sees them.
abstract class NotificationSettings
    implements _is.SerializableModel, _is.ProtocolSerialization {
  NotificationSettings._({
    required this.taskAssigned,
    required this.shoppingAdded,
  });

  factory NotificationSettings({
    required bool taskAssigned,
    required bool shoppingAdded,
  }) = _NotificationSettingsImpl;

  factory NotificationSettings.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationSettings(
      taskAssigned: _is.BoolJsonExtension.fromJson(
        jsonSerialization['taskAssigned'],
      ),
      shoppingAdded: _is.BoolJsonExtension.fromJson(
        jsonSerialization['shoppingAdded'],
      ),
    );
  }

  bool taskAssigned;

  bool shoppingAdded;

  /// Returns a shallow copy of this [NotificationSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotificationSettings copyWith({
    bool? taskAssigned,
    bool? shoppingAdded,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationSettings',
      'taskAssigned': taskAssigned,
      'shoppingAdded': shoppingAdded,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotificationSettings',
      'taskAssigned': taskAssigned,
      'shoppingAdded': shoppingAdded,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _NotificationSettingsImpl extends NotificationSettings {
  _NotificationSettingsImpl({
    required bool taskAssigned,
    required bool shoppingAdded,
  }) : super._(
         taskAssigned: taskAssigned,
         shoppingAdded: shoppingAdded,
       );

  /// Returns a shallow copy of this [NotificationSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotificationSettings copyWith({
    bool? taskAssigned,
    bool? shoppingAdded,
  }) {
    return NotificationSettings(
      taskAssigned: taskAssigned ?? this.taskAssigned,
      shoppingAdded: shoppingAdded ?? this.shoppingAdded,
    );
  }
}
