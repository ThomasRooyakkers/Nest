import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/built_in_catalog.dart';
import 'package:nest_server/src/services/push/fcm_client.dart';
import 'package:nest_server/src/services/push/push_notifications.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

/// Records pushes instead of sending them.
class FakePushSender implements PushSender {
  final sent = <PushMessage>[];

  @override
  bool get delivers => true;

  @override
  Future<PushOutcome> send(PushMessage message) async {
    sent.add(message);
    return PushOutcome.sent;
  }
}

void main() {
  withServerpod('Given push notifications', (sessionBuilder, endpoints) {
    late FakePushSender sender;
    late TestSessionBuilder anna;
    late TestSessionBuilder bram;
    late TestSessionBuilder carla;
    late int householdId;
    late int bramId;
    late ShoppingList list;

    setUp(() async {
      sender = FakePushSender();
      PushNotifications.senderOverride = sender;
      PushNotifications.shoppingDelay = Duration.zero;
      await BuiltInCatalog.sync(sessionBuilder.build());
      anna = await signedInUser(sessionBuilder, name: 'Anna');
      bram = await signedInUser(sessionBuilder, name: 'Bram');
      carla = await signedInUser(sessionBuilder, name: 'Carla');
      householdId = (await endpoints.household.create(
        anna,
        'Home',
      )).household.id!;
      for (final user in [bram, carla]) {
        final code = (await endpoints.household.createInvite(
          anna,
          householdId,
        )).code;
        await endpoints.household.join(user, code);
      }
      bramId = (await endpoints.profile.me(bram)).id!;
      await endpoints.notification.registerDevice(
        anna,
        'token-anna',
        PushPlatform.ios,
      );
      await endpoints.notification.registerDevice(
        bram,
        'token-bram',
        PushPlatform.android,
      );
      await endpoints.notification.registerDevice(
        carla,
        'token-carla',
        PushPlatform.ios,
      );
      list = (await endpoints.shopping.lists(anna, householdId)).single;
    });

    tearDown(() {
      PushNotifications.senderOverride = null;
    });

    Future<Task> saveTask(Task task, {TestSessionBuilder? as}) =>
        endpoints.task.save(as ?? anna, householdId, task);

    Future<void> addItem(String name, {TestSessionBuilder? as}) =>
        endpoints.shopping.addItem(
          as ?? anna,
          householdId,
          list.id!,
          NewShoppingItem(name: name, spec: '', storeIds: const []),
        );

    List<String> tokens() => [for (final m in sender.sent) m.token]..sort();

    test('assigning a task notifies only the assignee', () async {
      await saveTask(
        Task(householdId: 0, title: 'Water the plants', assigneeId: bramId),
      );
      await PushNotifications.flush();
      expect(tokens(), ['token-bram']);
      final message = sender.sent.single;
      expect(message.title, 'New task for you');
      expect(message.body, 'Anna assigned you: Water the plants');
      expect(message.data['type'], 'task');
      expect(message.data['householdId'], '$householdId');
    });

    test('saving a task again without a new assignee sends nothing', () async {
      final task = await saveTask(
        Task(householdId: 0, title: 'Bins', assigneeId: bramId),
      );
      await PushNotifications.flush();
      sender.sent.clear();
      await saveTask(task.copyWith(title: 'Bins out'));
      await PushNotifications.flush();
      expect(sender.sent, isEmpty);
    });

    test('assigning a task to yourself sends nothing', () async {
      await saveTask(
        Task(householdId: 0, title: 'Mine', assigneeId: bramId),
        as: bram,
      );
      await PushNotifications.flush();
      expect(sender.sent, isEmpty);
    });

    test('the text follows the recipient\'s language', () async {
      await endpoints.profile.updateMe(bram, 'Bram', 'nl');
      await saveTask(
        Task(householdId: 0, title: 'Afwassen', assigneeId: bramId),
      );
      await PushNotifications.flush();
      expect(sender.sent.single.title, 'Nieuwe taak voor jou');
      expect(
        sender.sent.single.body,
        'Anna heeft je een taak gegeven: Afwassen',
      );
    });

    test('a switched-off notification is not sent', () async {
      await endpoints.notification.saveSettings(
        bram,
        NotificationSettings(taskAssigned: false, shoppingAdded: true),
      );
      expect(
        (await endpoints.notification.settings(bram)).taskAssigned,
        isFalse,
      );
      await saveTask(Task(householdId: 0, title: 'Bins', assigneeId: bramId));
      await PushNotifications.flush();
      expect(sender.sent, isEmpty);
    });

    test('adding items notifies the other household members', () async {
      await addItem('Milk');
      await PushNotifications.flush();
      expect(tokens(), ['token-bram', 'token-carla']);
      expect(sender.sent.first.title, list.name);
      expect(sender.sent.first.body, 'Anna added 1 item to ${list.name}');
      expect(sender.sent.first.data['listId'], '${list.id}');
    });

    test('additions within the delay become one notification', () async {
      PushNotifications.shoppingDelay = const Duration(minutes: 2);
      await addItem('Milk');
      await addItem('Bread');
      await addItem('Eggs');
      await PushNotifications.flush();
      PushNotifications.shoppingDelay = Duration.zero;
      expect(tokens(), ['token-bram', 'token-carla']);
      expect(sender.sent.first.body, 'Anna added 3 items to ${list.name}');
    });

    test('a list with members notifies only its members', () async {
      final saved = await endpoints.shopping.saveList(
        anna,
        householdId,
        list.copyWith(memberIds: [bramId]),
      );
      list = saved;
      await addItem('Milk');
      await PushNotifications.flush();
      expect(tokens(), ['token-bram']);
    });

    test('an item that is already to buy sends nothing', () async {
      await addItem('Milk');
      await PushNotifications.flush();
      sender.sent.clear();
      await addItem('Milk');
      await PushNotifications.flush();
      expect(sender.sent, isEmpty);
    });

    test('a token moves to the user who registers it last', () async {
      await endpoints.notification.registerDevice(
        carla,
        'token-bram',
        PushPlatform.android,
      );
      await saveTask(Task(householdId: 0, title: 'Bins', assigneeId: bramId));
      await PushNotifications.flush();
      expect(sender.sent, isEmpty);
    });

    test('an unregistered phone gets nothing', () async {
      await endpoints.notification.unregisterDevice(bram, 'token-bram');
      await saveTask(Task(householdId: 0, title: 'Bins', assigneeId: bramId));
      await PushNotifications.flush();
      expect(sender.sent, isEmpty);
    });

    test('an empty token is refused', () async {
      await expectLater(
        endpoints.notification.registerDevice(anna, '  ', PushPlatform.ios),
        throwsA(isA<NestException>()),
      );
    });

    test('the health ping reports push in development', () async {
      expect((await endpoints.health.ping(anna)).pushNotifications, isTrue);
    });
  });

  test('FCM answers that mean a token is gone', () {
    expect(FcmClient.isInvalidTokenResponse(404, ''), isTrue);
    expect(
      FcmClient.isInvalidTokenResponse(400, '{"errorCode":"UNREGISTERED"}'),
      isTrue,
    );
    expect(
      FcmClient.isInvalidTokenResponse(
        400,
        'INVALID_ARGUMENT: The registration token is not a valid FCM token',
      ),
      isTrue,
    );
    expect(FcmClient.isInvalidTokenResponse(500, 'oops'), isFalse);
    expect(FcmClient.isInvalidTokenResponse(401, 'auth'), isFalse);
  });

  test('a PKCS#8 service account key signs an RS256 token', () {
    final credentials = FcmCredentials.parse(
      jsonEncode({
        'project_id': 'p',
        'client_email': 'e@x',
        'private_key': _testKey,
      }),
    )!;
    final token = JWT({'iss': credentials.clientEmail}).sign(
      RSAPrivateKey(credentials.privateKey),
      algorithm: JWTAlgorithm.RS256,
      expiresIn: const Duration(hours: 1),
    );
    expect(token.split('.'), hasLength(3));
  });

  test('a service account key is read', () {
    final credentials = FcmCredentials.parse(
      '{"project_id":"p","client_email":"e@x","private_key":"k"}',
    );
    expect(credentials?.projectId, 'p');
    expect(FcmCredentials.parse('not json'), isNull);
    expect(FcmCredentials.parse('{"project_id":"p"}'), isNull);
  });
}

/// A throwaway RSA key in the PKCS#8 form Google service accounts use,
/// generated for this test only.
const _testKey =
    '-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDWx8LDuYi5/Fsf\nm5U/jUiIeVgEpN4O6wkg7CMmttUCzy2jOX3GG/m0+iQZHXU9Rf/2eZsNpXJjqyC9\noH++Lf2LE46pYyYzTlTioVAFQCFRFStEkzD042UZGO/0ERKOCfF5oZ4Ebu1AjUyE\nJbCmqVB+lOTIgjnX1Nk44DptFgizUsHaKeUJhMIPgd5+pf7N39Fagmn9FDe53fRn\n0SSSuGN57E9faMkioI48JPSIZEqCpmSSV01q62J+GFawdJARVhtFVgHO0bX9Mvm/\nxXZdLTQx9HXETWerYsnzfb9AjIOS1YcCeIwneU0hl80y9Qj45X8/+V8lcHa9ilki\nXX1PdeSRAgMBAAECggEACpyMHkQ6r/N6vGdS1Vh8IxiuzE/wvrOb+FnwlnA+nhOG\nsYqj5h6qDYR8UjPIxweAEQd1nzBeQJ61rTxSg2XdhWUMP2yIlOlZAqIfy34rlXMG\nBfXT+BunXcdZWzCY+AhY9EWh19bJL+urQkqc3W43UWVFERkC6u8h8XPTFH7GlZpV\ng1471/NIVMTBE2vum/U+ULCnMKK2ILAcCR6Zqj4BRgKXTrmS0G1JXmo48QNUA+Jh\n3U7bEBmE2OvQogR8RA6Yg8gYOTy4o3d/umQGuv/+vnBVD0jVfH2kOXE6Ta2r5Ov5\nFPClHqeU1i/DtCgWGomeXrEbzcMhOnlkgn+HqlS9bwKBgQD7aI4dGEMGolJiMSiQ\n5TODM+qN7Ua6Dhg3a3+CsCmPrxHo5yEnHODo9RrHbJYZJ44/z9g2jr8D5MDBVJII\npS8Gisucn5JjelHWvdhNkf+L6/Mffv60YwaWPlEbnPRPAWsZoQPc6iJI+mLqym20\nz0fBcx0DGr5JwSjSIVlZBSHCUwKBgQDas/QD/28ivDXjhKBrvAyuzjeNq57oGxmb\nGjc5lnAi+yho7BJmFrH2RRdTOpeW0NXUe6t2XL+zyggjj8sRpq/7FkQ0dLDITczQ\nwZAF3jAvg92YsirWVZoQhu01D1q1/8jIoC2o4vN/ykT2+Ibec15JsuG0lH1YW0pS\n43GT46fpCwKBgQD50vgFaWqRWRPMh1TsRxZdNmXKCxLRJ9hgme3ni+6A3VNKwQJs\nv4GvfIDT0s+Ex43PU1ZjQI4H7HSuqL9E4ABO2/Vg+iCZwZ85aQVcb8wk2p6JmcS4\ns/6DpgErE1iieaJXoW0ZRYA0TLum3OkPVzrSvPUDdLvKxqstw/3pO/RECQKBgQCX\ncnws9Iq6TAkpN6N7V2qU9nqj4U+WPYX60Smi+FlI8BGorqmDBn5QIsInQXDN4Gni\nzY0L1uhtkR8XuTCPVZWR03aBuLjezHljqlaYqadGkBM49VASwo6AmV7UGoDffXRF\n8h4MULT8Lk6Zk7qZety1PmlsClPOhtEuGxCAr+qLxwKBgQDMqI3X2RnghayIrSED\nm6BL+fPXQfD3oqaKcsnMFHs7ISrby7q/58cSvhfuuEUc8w+rShwuss7MNoeN/Qlj\nxCHf3mUUU/obEJpRTNGkTwj+2HNAJ8gnDX+RqifADDjAt5tPb1L34BMeS7ljtxYZ\n/Qmy0WyY30jL1nt6Kn834LGZww==\n-----END PRIVATE KEY-----';
