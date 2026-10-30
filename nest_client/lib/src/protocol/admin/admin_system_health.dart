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
import 'package:nest_client/src/protocol/protocol.dart' as _ilcqbmdc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../admin/backup_run.dart' as _i2211eyr;
import '../sign_up_mode.dart' as _ieuswpfa;

/// System health page of the admin portal: metadata and counts only.
abstract class AdminSystemHealth
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminSystemHealth._({
    required this.serverTime,
    required this.version,
    required this.apiVersion,
    required this.startedAt,
    required this.databaseOk,
    this.databaseSizeBytes,
    this.diskFreeBytes,
    this.diskTotalBytes,
    required this.householdCount,
    required this.activeHouseholdCount,
    required this.userCount,
    required this.disabledUserCount,
    required this.signUpMode,
    required this.mailConfigured,
    required this.filmDataConfigured,
    required this.lastBackups,
    this.lastSuccessfulBackupAt,
  });

  factory AdminSystemHealth({
    required DateTime serverTime,
    required String version,
    required int apiVersion,
    required DateTime startedAt,
    required bool databaseOk,
    int? databaseSizeBytes,
    int? diskFreeBytes,
    int? diskTotalBytes,
    required int householdCount,
    required int activeHouseholdCount,
    required int userCount,
    required int disabledUserCount,
    required _ieuswpfa.SignUpMode signUpMode,
    required bool mailConfigured,
    required bool filmDataConfigured,
    required List<_i2211eyr.BackupRun> lastBackups,
    DateTime? lastSuccessfulBackupAt,
  }) = _AdminSystemHealthImpl;

  factory AdminSystemHealth.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminSystemHealth(
      serverTime: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
      version: jsonSerialization['version'] as String,
      apiVersion: jsonSerialization['apiVersion'] as int,
      startedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      databaseOk: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['databaseOk'],
      ),
      databaseSizeBytes: jsonSerialization['databaseSizeBytes'] as int?,
      diskFreeBytes: jsonSerialization['diskFreeBytes'] as int?,
      diskTotalBytes: jsonSerialization['diskTotalBytes'] as int?,
      householdCount: jsonSerialization['householdCount'] as int,
      activeHouseholdCount: jsonSerialization['activeHouseholdCount'] as int,
      userCount: jsonSerialization['userCount'] as int,
      disabledUserCount: jsonSerialization['disabledUserCount'] as int,
      signUpMode: _ieuswpfa.SignUpMode.fromJson(
        (jsonSerialization['signUpMode'] as String),
      ),
      mailConfigured: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['mailConfigured'],
      ),
      filmDataConfigured: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['filmDataConfigured'],
      ),
      lastBackups: _ilcqbmdc.Protocol().deserialize<List<_i2211eyr.BackupRun>>(
        jsonSerialization['lastBackups'],
      ),
      lastSuccessfulBackupAt:
          jsonSerialization['lastSuccessfulBackupAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSuccessfulBackupAt'],
            ),
    );
  }

  DateTime serverTime;

  String version;

  int apiVersion;

  /// When this server process started.
  DateTime startedAt;

  bool databaseOk;

  int? databaseSizeBytes;

  /// Disk of the server's data (null when it cannot be read).
  int? diskFreeBytes;

  int? diskTotalBytes;

  int householdCount;

  int activeHouseholdCount;

  int userCount;

  int disabledUserCount;

  _ieuswpfa.SignUpMode signUpMode;

  bool mailConfigured;

  bool filmDataConfigured;

  /// The newest backup run of each target.
  List<_i2211eyr.BackupRun> lastBackups;

  /// Newest successful backup of any target.
  DateTime? lastSuccessfulBackupAt;

  /// Returns a shallow copy of this [AdminSystemHealth]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminSystemHealth copyWith({
    DateTime? serverTime,
    String? version,
    int? apiVersion,
    DateTime? startedAt,
    bool? databaseOk,
    int? databaseSizeBytes,
    int? diskFreeBytes,
    int? diskTotalBytes,
    int? householdCount,
    int? activeHouseholdCount,
    int? userCount,
    int? disabledUserCount,
    _ieuswpfa.SignUpMode? signUpMode,
    bool? mailConfigured,
    bool? filmDataConfigured,
    List<_i2211eyr.BackupRun>? lastBackups,
    DateTime? lastSuccessfulBackupAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminSystemHealth',
      'serverTime': serverTime.toJson(),
      'version': version,
      'apiVersion': apiVersion,
      'startedAt': startedAt.toJson(),
      'databaseOk': databaseOk,
      if (databaseSizeBytes != null) 'databaseSizeBytes': databaseSizeBytes,
      if (diskFreeBytes != null) 'diskFreeBytes': diskFreeBytes,
      if (diskTotalBytes != null) 'diskTotalBytes': diskTotalBytes,
      'householdCount': householdCount,
      'activeHouseholdCount': activeHouseholdCount,
      'userCount': userCount,
      'disabledUserCount': disabledUserCount,
      'signUpMode': signUpMode.toJson(),
      'mailConfigured': mailConfigured,
      'filmDataConfigured': filmDataConfigured,
      'lastBackups': lastBackups.toJson(valueToJson: (v) => v.toJson()),
      if (lastSuccessfulBackupAt != null)
        'lastSuccessfulBackupAt': lastSuccessfulBackupAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminSystemHealth',
      'serverTime': serverTime.toJson(),
      'version': version,
      'apiVersion': apiVersion,
      'startedAt': startedAt.toJson(),
      'databaseOk': databaseOk,
      if (databaseSizeBytes != null) 'databaseSizeBytes': databaseSizeBytes,
      if (diskFreeBytes != null) 'diskFreeBytes': diskFreeBytes,
      if (diskTotalBytes != null) 'diskTotalBytes': diskTotalBytes,
      'householdCount': householdCount,
      'activeHouseholdCount': activeHouseholdCount,
      'userCount': userCount,
      'disabledUserCount': disabledUserCount,
      'signUpMode': signUpMode.toJson(),
      'mailConfigured': mailConfigured,
      'filmDataConfigured': filmDataConfigured,
      'lastBackups': lastBackups.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      if (lastSuccessfulBackupAt != null)
        'lastSuccessfulBackupAt': lastSuccessfulBackupAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminSystemHealthImpl extends AdminSystemHealth {
  _AdminSystemHealthImpl({
    required DateTime serverTime,
    required String version,
    required int apiVersion,
    required DateTime startedAt,
    required bool databaseOk,
    int? databaseSizeBytes,
    int? diskFreeBytes,
    int? diskTotalBytes,
    required int householdCount,
    required int activeHouseholdCount,
    required int userCount,
    required int disabledUserCount,
    required _ieuswpfa.SignUpMode signUpMode,
    required bool mailConfigured,
    required bool filmDataConfigured,
    required List<_i2211eyr.BackupRun> lastBackups,
    DateTime? lastSuccessfulBackupAt,
  }) : super._(
         serverTime: serverTime,
         version: version,
         apiVersion: apiVersion,
         startedAt: startedAt,
         databaseOk: databaseOk,
         databaseSizeBytes: databaseSizeBytes,
         diskFreeBytes: diskFreeBytes,
         diskTotalBytes: diskTotalBytes,
         householdCount: householdCount,
         activeHouseholdCount: activeHouseholdCount,
         userCount: userCount,
         disabledUserCount: disabledUserCount,
         signUpMode: signUpMode,
         mailConfigured: mailConfigured,
         filmDataConfigured: filmDataConfigured,
         lastBackups: lastBackups,
         lastSuccessfulBackupAt: lastSuccessfulBackupAt,
       );

  /// Returns a shallow copy of this [AdminSystemHealth]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminSystemHealth copyWith({
    DateTime? serverTime,
    String? version,
    int? apiVersion,
    DateTime? startedAt,
    bool? databaseOk,
    Object? databaseSizeBytes = _Undefined,
    Object? diskFreeBytes = _Undefined,
    Object? diskTotalBytes = _Undefined,
    int? householdCount,
    int? activeHouseholdCount,
    int? userCount,
    int? disabledUserCount,
    _ieuswpfa.SignUpMode? signUpMode,
    bool? mailConfigured,
    bool? filmDataConfigured,
    List<_i2211eyr.BackupRun>? lastBackups,
    Object? lastSuccessfulBackupAt = _Undefined,
  }) {
    return AdminSystemHealth(
      serverTime: serverTime ?? this.serverTime,
      version: version ?? this.version,
      apiVersion: apiVersion ?? this.apiVersion,
      startedAt: startedAt ?? this.startedAt,
      databaseOk: databaseOk ?? this.databaseOk,
      databaseSizeBytes: databaseSizeBytes is int?
          ? databaseSizeBytes
          : this.databaseSizeBytes,
      diskFreeBytes: diskFreeBytes is int? ? diskFreeBytes : this.diskFreeBytes,
      diskTotalBytes: diskTotalBytes is int?
          ? diskTotalBytes
          : this.diskTotalBytes,
      householdCount: householdCount ?? this.householdCount,
      activeHouseholdCount: activeHouseholdCount ?? this.activeHouseholdCount,
      userCount: userCount ?? this.userCount,
      disabledUserCount: disabledUserCount ?? this.disabledUserCount,
      signUpMode: signUpMode ?? this.signUpMode,
      mailConfigured: mailConfigured ?? this.mailConfigured,
      filmDataConfigured: filmDataConfigured ?? this.filmDataConfigured,
      lastBackups:
          lastBackups ?? this.lastBackups.map((e0) => e0.copyWith()).toList(),
      lastSuccessfulBackupAt: lastSuccessfulBackupAt is DateTime?
          ? lastSuccessfulBackupAt
          : this.lastSuccessfulBackupAt,
    );
  }
}
