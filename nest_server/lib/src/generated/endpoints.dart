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
import 'dart:typed_data' as _idt;
import 'package:nest_server/src/generated/household_feature.dart' as _iez4op0n;
import 'package:nest_server/src/generated/household_status.dart' as _i544oeia;
import 'package:nest_server/src/generated/meals/meal_plan_entry.dart'
    as _i33h3ld7;
import 'package:nest_server/src/generated/meals/meal_slot.dart' as _iliwnvwg;
import 'package:nest_server/src/generated/recipes/recipe.dart' as _iei9bazg;
import 'package:nest_server/src/generated/shopping/new_shopping_item.dart'
    as _i97lm970;
import 'package:nest_server/src/generated/shopping/shopping_item_status.dart'
    as _id8ue2wm;
import 'package:nest_server/src/generated/shopping/shopping_list.dart'
    as _iustknb5;
import 'package:nest_server/src/generated/shopping/store.dart' as _iq3p81du;
import 'package:nest_server/src/generated/tasks/task.dart' as _iw4rp4ni;
import 'package:nest_server/src/generated/watchlist/watch_status.dart'
    as _im087wsz;
import 'package:nest_server/src/generated/watchlist/watch_type.dart'
    as _izyu0w1k;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../endpoints/admin/admin_audit_endpoint.dart' as _isry7q4f;
import '../endpoints/admin/admin_backups_endpoint.dart' as _ihn2grnq;
import '../endpoints/admin/admin_households_endpoint.dart' as _iy84ve0g;
import '../endpoints/admin/admin_system_endpoint.dart' as _ip4fayzs;
import '../endpoints/admin/admin_users_endpoint.dart' as _iscnlbye;
import '../endpoints/health_endpoint.dart' as _ica9y4w0;
import '../endpoints/household_endpoint.dart' as _izqmqbob;
import '../endpoints/meal_plan_endpoint.dart' as _ioif1jmi;
import '../endpoints/profile_endpoint.dart' as _i2cx2pww;
import '../endpoints/recipe_endpoint.dart' as _iotgfwtb;
import '../endpoints/shopping_endpoint.dart' as _i0uz9s3h;
import '../endpoints/sign_up_endpoint.dart' as _im0g34lo;
import '../endpoints/task_endpoint.dart' as _idmllfay;
import '../endpoints/watchlist_endpoint.dart' as _is4r6sri;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'adminAudit': _isry7q4f.AdminAuditEndpoint()
        ..initialize(
          server,
          'adminAudit',
          null,
        ),
      'adminBackups': _ihn2grnq.AdminBackupsEndpoint()
        ..initialize(
          server,
          'adminBackups',
          null,
        ),
      'adminHouseholds': _iy84ve0g.AdminHouseholdsEndpoint()
        ..initialize(
          server,
          'adminHouseholds',
          null,
        ),
      'adminSystem': _ip4fayzs.AdminSystemEndpoint()
        ..initialize(
          server,
          'adminSystem',
          null,
        ),
      'adminUsers': _iscnlbye.AdminUsersEndpoint()
        ..initialize(
          server,
          'adminUsers',
          null,
        ),
      'health': _ica9y4w0.HealthEndpoint()
        ..initialize(
          server,
          'health',
          null,
        ),
      'household': _izqmqbob.HouseholdEndpoint()
        ..initialize(
          server,
          'household',
          null,
        ),
      'mealPlan': _ioif1jmi.MealPlanEndpoint()
        ..initialize(
          server,
          'mealPlan',
          null,
        ),
      'profile': _i2cx2pww.ProfileEndpoint()
        ..initialize(
          server,
          'profile',
          null,
        ),
      'recipe': _iotgfwtb.RecipeEndpoint()
        ..initialize(
          server,
          'recipe',
          null,
        ),
      'shopping': _i0uz9s3h.ShoppingEndpoint()
        ..initialize(
          server,
          'shopping',
          null,
        ),
      'signUp': _im0g34lo.SignUpEndpoint()
        ..initialize(
          server,
          'signUp',
          null,
        ),
      'task': _idmllfay.TaskEndpoint()
        ..initialize(
          server,
          'task',
          null,
        ),
      'watchlist': _is4r6sri.WatchlistEndpoint()
        ..initialize(
          server,
          'watchlist',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['adminAudit'] = _is.EndpointConnector(
      name: 'adminAudit',
      endpoint: endpoints['adminAudit']!,
      methodConnectors: {
        'entries': _is.MethodConnector(
          name: 'entries',
          params: {
            'beforeId': _is.ParameterDescription(
              name: 'beforeId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminAudit'] as _isry7q4f.AdminAuditEndpoint)
                      .entries(
                        session,
                        beforeId: params['beforeId'],
                        limit: params['limit'],
                      ),
        ),
      },
    );
    connectors['adminBackups'] = _is.EndpointConnector(
      name: 'adminBackups',
      endpoint: endpoints['adminBackups']!,
      methodConnectors: {
        'overview': _is.MethodConnector(
          name: 'overview',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminBackups'] as _ihn2grnq.AdminBackupsEndpoint)
                      .overview(session),
        ),
        'requestBackup': _is.MethodConnector(
          name: 'requestBackup',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminBackups'] as _ihn2grnq.AdminBackupsEndpoint)
                      .requestBackup(session),
        ),
      },
    );
    connectors['adminHouseholds'] = _is.EndpointConnector(
      name: 'adminHouseholds',
      endpoint: endpoints['adminHouseholds']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminHouseholds']
                          as _iy84ve0g.AdminHouseholdsEndpoint)
                      .list(session),
        ),
        'setStatus': _is.MethodConnector(
          name: 'setStatus',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<_i544oeia.HouseholdStatus>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminHouseholds']
                          as _iy84ve0g.AdminHouseholdsEndpoint)
                      .setStatus(
                        session,
                        params['householdId'],
                        params['status'],
                      ),
        ),
      },
    );
    connectors['adminSystem'] = _is.EndpointConnector(
      name: 'adminSystem',
      endpoint: endpoints['adminSystem']!,
      methodConnectors: {
        'health': _is.MethodConnector(
          name: 'health',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSystem'] as _ip4fayzs.AdminSystemEndpoint)
                      .health(session),
        ),
      },
    );
    connectors['adminUsers'] = _is.EndpointConnector(
      name: 'adminUsers',
      endpoint: endpoints['adminUsers']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminUsers'] as _iscnlbye.AdminUsersEndpoint)
                      .list(session),
        ),
        'setDisabled': _is.MethodConnector(
          name: 'setDisabled',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'disabled': _is.ParameterDescription(
              name: 'disabled',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminUsers'] as _iscnlbye.AdminUsersEndpoint)
                      .setDisabled(
                        session,
                        params['userId'],
                        params['disabled'],
                      ),
        ),
      },
    );
    connectors['health'] = _is.EndpointConnector(
      name: 'health',
      endpoint: endpoints['health']!,
      methodConnectors: {
        'ping': _is.MethodConnector(
          name: 'ping',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['health'] as _ica9y4w0.HealthEndpoint).ping(
                session,
              ),
        ),
      },
    );
    connectors['household'] = _is.EndpointConnector(
      name: 'household',
      endpoint: endpoints['household']!,
      methodConnectors: {
        'listMine': _is.MethodConnector(
          name: 'listMine',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _izqmqbob.HouseholdEndpoint)
                  .listMine(session),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _izqmqbob.HouseholdEndpoint)
                  .create(
                    session,
                    params['name'],
                  ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['household'] as _izqmqbob.HouseholdEndpoint).get(
                    session,
                    params['householdId'],
                  ),
        ),
        'members': _is.MethodConnector(
          name: 'members',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _izqmqbob.HouseholdEndpoint)
                  .members(
                    session,
                    params['householdId'],
                  ),
        ),
        'rename': _is.MethodConnector(
          name: 'rename',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _izqmqbob.HouseholdEndpoint)
                  .rename(
                    session,
                    params['householdId'],
                    params['name'],
                  ),
        ),
        'setFeatures': _is.MethodConnector(
          name: 'setFeatures',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'features': _is.ParameterDescription(
              name: 'features',
              type: _is.getType<List<_iez4op0n.HouseholdFeature>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _izqmqbob.HouseholdEndpoint)
                  .setFeatures(
                    session,
                    params['householdId'],
                    params['features'],
                  ),
        ),
        'setMealSlots': _is.MethodConnector(
          name: 'setMealSlots',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'slots': _is.ParameterDescription(
              name: 'slots',
              type: _is.getType<List<_iliwnvwg.MealSlot>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _izqmqbob.HouseholdEndpoint)
                  .setMealSlots(
                    session,
                    params['householdId'],
                    params['slots'],
                  ),
        ),
        'createInvite': _is.MethodConnector(
          name: 'createInvite',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _izqmqbob.HouseholdEndpoint)
                  .createInvite(
                    session,
                    params['householdId'],
                  ),
        ),
        'revokeInvite': _is.MethodConnector(
          name: 'revokeInvite',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _izqmqbob.HouseholdEndpoint)
                  .revokeInvite(
                    session,
                    params['householdId'],
                  ),
        ),
        'join': _is.MethodConnector(
          name: 'join',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['household'] as _izqmqbob.HouseholdEndpoint).join(
                    session,
                    params['code'],
                  ),
        ),
        'leave': _is.MethodConnector(
          name: 'leave',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['household'] as _izqmqbob.HouseholdEndpoint).leave(
                    session,
                    params['householdId'],
                  ),
        ),
      },
    );
    connectors['mealPlan'] = _is.EndpointConnector(
      name: 'mealPlan',
      endpoint: endpoints['mealPlan']!,
      methodConnectors: {
        'entries': _is.MethodConnector(
          name: 'entries',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'from': _is.ParameterDescription(
              name: 'from',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'to': _is.ParameterDescription(
              name: 'to',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mealPlan'] as _ioif1jmi.MealPlanEndpoint).entries(
                    session,
                    params['householdId'],
                    params['from'],
                    params['to'],
                  ),
        ),
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'entry': _is.ParameterDescription(
              name: 'entry',
              type: _is.getType<_i33h3ld7.MealPlanEntry>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mealPlan'] as _ioif1jmi.MealPlanEndpoint).save(
                    session,
                    params['householdId'],
                    params['entry'],
                  ),
        ),
        'remove': _is.MethodConnector(
          name: 'remove',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'entryId': _is.ParameterDescription(
              name: 'entryId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mealPlan'] as _ioif1jmi.MealPlanEndpoint).remove(
                    session,
                    params['householdId'],
                    params['entryId'],
                  ),
        ),
        'watch': _is.MethodStreamConnector(
          name: 'watch',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['mealPlan'] as _ioif1jmi.MealPlanEndpoint).watch(
                session,
                params['householdId'],
              ),
        ),
      },
    );
    connectors['profile'] = _is.EndpointConnector(
      name: 'profile',
      endpoint: endpoints['profile']!,
      methodConnectors: {
        'me': _is.MethodConnector(
          name: 'me',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i2cx2pww.ProfileEndpoint).me(
                session,
              ),
        ),
        'updateMe': _is.MethodConnector(
          name: 'updateMe',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'locale': _is.ParameterDescription(
              name: 'locale',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['profile'] as _i2cx2pww.ProfileEndpoint).updateMe(
                    session,
                    params['name'],
                    params['locale'],
                  ),
        ),
        'deleteMe': _is.MethodConnector(
          name: 'deleteMe',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i2cx2pww.ProfileEndpoint)
                  .deleteMe(session),
        ),
      },
    );
    connectors['recipe'] = _is.EndpointConnector(
      name: 'recipe',
      endpoint: endpoints['recipe']!,
      methodConnectors: {
        'recipes': _is.MethodConnector(
          name: 'recipes',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recipe'] as _iotgfwtb.RecipeEndpoint).recipes(
                    session,
                    params['householdId'],
                  ),
        ),
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'recipe': _is.ParameterDescription(
              name: 'recipe',
              type: _is.getType<_iei9bazg.Recipe>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['recipe'] as _iotgfwtb.RecipeEndpoint).save(
                session,
                params['householdId'],
                params['recipe'],
              ),
        ),
        'setFavorite': _is.MethodConnector(
          name: 'setFavorite',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'recipeId': _is.ParameterDescription(
              name: 'recipeId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'favorite': _is.ParameterDescription(
              name: 'favorite',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recipe'] as _iotgfwtb.RecipeEndpoint).setFavorite(
                    session,
                    params['householdId'],
                    params['recipeId'],
                    params['favorite'],
                  ),
        ),
        'setPhoto': _is.MethodConnector(
          name: 'setPhoto',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'recipeId': _is.ParameterDescription(
              name: 'recipeId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'photo': _is.ParameterDescription(
              name: 'photo',
              type: _is.getType<_idt.ByteData?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recipe'] as _iotgfwtb.RecipeEndpoint).setPhoto(
                    session,
                    params['householdId'],
                    params['recipeId'],
                    params['photo'],
                  ),
        ),
        'photo': _is.MethodConnector(
          name: 'photo',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'recipeId': _is.ParameterDescription(
              name: 'recipeId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recipe'] as _iotgfwtb.RecipeEndpoint).photo(
                    session,
                    params['householdId'],
                    params['recipeId'],
                  ),
        ),
        'remove': _is.MethodConnector(
          name: 'remove',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'recipeId': _is.ParameterDescription(
              name: 'recipeId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recipe'] as _iotgfwtb.RecipeEndpoint).remove(
                    session,
                    params['householdId'],
                    params['recipeId'],
                  ),
        ),
        'watch': _is.MethodStreamConnector(
          name: 'watch',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['recipe'] as _iotgfwtb.RecipeEndpoint).watch(
                session,
                params['householdId'],
              ),
        ),
      },
    );
    connectors['shopping'] = _is.EndpointConnector(
      name: 'shopping',
      endpoint: endpoints['shopping']!,
      methodConnectors: {
        'lists': _is.MethodConnector(
          name: 'lists',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['shopping'] as _i0uz9s3h.ShoppingEndpoint).lists(
                    session,
                    params['householdId'],
                  ),
        ),
        'saveList': _is.MethodConnector(
          name: 'saveList',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<_iustknb5.ShoppingList>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shopping'] as _i0uz9s3h.ShoppingEndpoint)
                  .saveList(
                    session,
                    params['householdId'],
                    params['list'],
                  ),
        ),
        'deleteList': _is.MethodConnector(
          name: 'deleteList',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'listId': _is.ParameterDescription(
              name: 'listId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shopping'] as _i0uz9s3h.ShoppingEndpoint)
                  .deleteList(
                    session,
                    params['householdId'],
                    params['listId'],
                  ),
        ),
        'stores': _is.MethodConnector(
          name: 'stores',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['shopping'] as _i0uz9s3h.ShoppingEndpoint).stores(
                    session,
                    params['householdId'],
                  ),
        ),
        'saveStore': _is.MethodConnector(
          name: 'saveStore',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'store': _is.ParameterDescription(
              name: 'store',
              type: _is.getType<_iq3p81du.Store>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shopping'] as _i0uz9s3h.ShoppingEndpoint)
                  .saveStore(
                    session,
                    params['householdId'],
                    params['store'],
                  ),
        ),
        'deleteStore': _is.MethodConnector(
          name: 'deleteStore',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'storeId': _is.ParameterDescription(
              name: 'storeId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shopping'] as _i0uz9s3h.ShoppingEndpoint)
                  .deleteStore(
                    session,
                    params['householdId'],
                    params['storeId'],
                  ),
        ),
        'catalog': _is.MethodConnector(
          name: 'catalog',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['shopping'] as _i0uz9s3h.ShoppingEndpoint).catalog(
                    session,
                    params['householdId'],
                  ),
        ),
        'items': _is.MethodConnector(
          name: 'items',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['shopping'] as _i0uz9s3h.ShoppingEndpoint).items(
                    session,
                    params['householdId'],
                  ),
        ),
        'addItem': _is.MethodConnector(
          name: 'addItem',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'listId': _is.ParameterDescription(
              name: 'listId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'newItem': _is.ParameterDescription(
              name: 'newItem',
              type: _is.getType<_i97lm970.NewShoppingItem>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['shopping'] as _i0uz9s3h.ShoppingEndpoint).addItem(
                    session,
                    params['householdId'],
                    params['listId'],
                    params['newItem'],
                  ),
        ),
        'addItems': _is.MethodConnector(
          name: 'addItems',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'listId': _is.ParameterDescription(
              name: 'listId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'newItems': _is.ParameterDescription(
              name: 'newItems',
              type: _is.getType<List<_i97lm970.NewShoppingItem>>(),
              nullable: false,
            ),
            'sourceRecipeId': _is.ParameterDescription(
              name: 'sourceRecipeId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shopping'] as _i0uz9s3h.ShoppingEndpoint)
                  .addItems(
                    session,
                    params['householdId'],
                    params['listId'],
                    params['newItems'],
                    params['sourceRecipeId'],
                  ),
        ),
        'updateItem': _is.MethodConnector(
          name: 'updateItem',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'itemId': _is.ParameterDescription(
              name: 'itemId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'spec': _is.ParameterDescription(
              name: 'spec',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'storeIds': _is.ParameterDescription(
              name: 'storeIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shopping'] as _i0uz9s3h.ShoppingEndpoint)
                  .updateItem(
                    session,
                    params['householdId'],
                    params['itemId'],
                    params['spec'],
                    params['storeIds'],
                  ),
        ),
        'setItemStatus': _is.MethodConnector(
          name: 'setItemStatus',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'itemId': _is.ParameterDescription(
              name: 'itemId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<_id8ue2wm.ShoppingItemStatus>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shopping'] as _i0uz9s3h.ShoppingEndpoint)
                  .setItemStatus(
                    session,
                    params['householdId'],
                    params['itemId'],
                    params['status'],
                  ),
        ),
        'removeItem': _is.MethodConnector(
          name: 'removeItem',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'itemId': _is.ParameterDescription(
              name: 'itemId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shopping'] as _i0uz9s3h.ShoppingEndpoint)
                  .removeItem(
                    session,
                    params['householdId'],
                    params['itemId'],
                  ),
        ),
        'watch': _is.MethodStreamConnector(
          name: 'watch',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['shopping'] as _i0uz9s3h.ShoppingEndpoint).watch(
                session,
                params['householdId'],
              ),
        ),
      },
    );
    connectors['signUp'] = _is.EndpointConnector(
      name: 'signUp',
      endpoint: endpoints['signUp']!,
      methodConnectors: {
        'redeemInvite': _is.MethodConnector(
          name: 'redeemInvite',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'inviteCode': _is.ParameterDescription(
              name: 'inviteCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['signUp'] as _im0g34lo.SignUpEndpoint)
                  .redeemInvite(
                    session,
                    params['email'],
                    params['inviteCode'],
                  ),
        ),
      },
    );
    connectors['task'] = _is.EndpointConnector(
      name: 'task',
      endpoint: endpoints['task']!,
      methodConnectors: {
        'tasks': _is.MethodConnector(
          name: 'tasks',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['task'] as _idmllfay.TaskEndpoint).tasks(
                session,
                params['householdId'],
              ),
        ),
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'task': _is.ParameterDescription(
              name: 'task',
              type: _is.getType<_iw4rp4ni.Task>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['task'] as _idmllfay.TaskEndpoint).save(
                session,
                params['householdId'],
                params['task'],
              ),
        ),
        'setDone': _is.MethodConnector(
          name: 'setDone',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'taskId': _is.ParameterDescription(
              name: 'taskId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'done': _is.ParameterDescription(
              name: 'done',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'today': _is.ParameterDescription(
              name: 'today',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['task'] as _idmllfay.TaskEndpoint).setDone(
                session,
                params['householdId'],
                params['taskId'],
                params['done'],
                params['today'],
              ),
        ),
        'remove': _is.MethodConnector(
          name: 'remove',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'taskId': _is.ParameterDescription(
              name: 'taskId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['task'] as _idmllfay.TaskEndpoint).remove(
                session,
                params['householdId'],
                params['taskId'],
              ),
        ),
        'watch': _is.MethodStreamConnector(
          name: 'watch',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['task'] as _idmllfay.TaskEndpoint).watch(
                session,
                params['householdId'],
              ),
        ),
      },
    );
    connectors['watchlist'] = _is.EndpointConnector(
      name: 'watchlist',
      endpoint: endpoints['watchlist']!,
      methodConnectors: {
        'items': _is.MethodConnector(
          name: 'items',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['watchlist'] as _is4r6sri.WatchlistEndpoint).items(
                    session,
                    params['householdId'],
                  ),
        ),
        'search': _is.MethodConnector(
          name: 'search',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'query': _is.ParameterDescription(
              name: 'query',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['watchlist'] as _is4r6sri.WatchlistEndpoint)
                  .search(
                    session,
                    params['householdId'],
                    params['query'],
                  ),
        ),
        'add': _is.MethodConnector(
          name: 'add',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'type': _is.ParameterDescription(
              name: 'type',
              type: _is.getType<_izyu0w1k.WatchType>(),
              nullable: false,
            ),
            'tmdbId': _is.ParameterDescription(
              name: 'tmdbId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['watchlist'] as _is4r6sri.WatchlistEndpoint).add(
                    session,
                    params['householdId'],
                    params['type'],
                    params['tmdbId'],
                  ),
        ),
        'setStatus': _is.MethodConnector(
          name: 'setStatus',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'itemId': _is.ParameterDescription(
              name: 'itemId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<_im087wsz.WatchStatus>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['watchlist'] as _is4r6sri.WatchlistEndpoint)
                  .setStatus(
                    session,
                    params['householdId'],
                    params['itemId'],
                    params['status'],
                  ),
        ),
        'setRating': _is.MethodConnector(
          name: 'setRating',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'itemId': _is.ParameterDescription(
              name: 'itemId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'rating': _is.ParameterDescription(
              name: 'rating',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['watchlist'] as _is4r6sri.WatchlistEndpoint)
                  .setRating(
                    session,
                    params['householdId'],
                    params['itemId'],
                    params['rating'],
                  ),
        ),
        'remove': _is.MethodConnector(
          name: 'remove',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'itemId': _is.ParameterDescription(
              name: 'itemId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['watchlist'] as _is4r6sri.WatchlistEndpoint)
                  .remove(
                    session,
                    params['householdId'],
                    params['itemId'],
                  ),
        ),
        'watch': _is.MethodStreamConnector(
          name: 'watch',
          params: {
            'householdId': _is.ParameterDescription(
              name: 'householdId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['watchlist'] as _is4r6sri.WatchlistEndpoint).watch(
                    session,
                    params['householdId'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
