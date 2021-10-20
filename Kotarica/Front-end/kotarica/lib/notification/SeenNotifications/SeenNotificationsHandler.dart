import 'SeenNotifications.dart';
import 'SeenNotificationsApi.dart';

class SeenNotificationsHandler {
  static SeenNotificationsHandler _globalHandler;
  static SeenNotificationsHandler get globalHandler => _globalHandler;
  static Future<void> initializingGlobalHandler;

  SeenNotifications _seenNotifications;

  final int userId;

  SeenNotificationsHandler._(this.userId);

  static Future<SeenNotificationsHandler> createHandler(int userId) async {
    var handler = SeenNotificationsHandler._(userId);
    await handler._initiateSetup();
    return handler;
  }

  static Future<void> setGlobalHandlerFromUserId(int userId) async {
    print("FUN");
    initializingGlobalHandler = _setGlobalHandlerFromUserId(userId);
    print("FUN2");

    await initializingGlobalHandler;
  }

  static Future<void> _setGlobalHandlerFromUserId(int userId) async {
    _globalHandler = await createHandler(userId);
  }

  Future<void> _initiateSetup() async {
    var decoded = await SeenNotificationsApi.getUserSeenNotifications(userId);
    _seenNotifications = _makeSeenNotifications(decoded);
  }

  SeenNotifications _makeSeenNotifications(List<dynamic> decoded) {
    var seen = SeenNotifications();
    for (var map in decoded) {
      assert(map is Map);
      assert(map.containsKey('userId') && map.containsKey('transactionHash') && map.containsKey('logIndex'));
      seen.addSeenNotification(map['transactionHash'], map['logIndex']);
    }
    return seen;
  }

  bool isNotificationSeen(String transactionHash, int logIndex)
  => _seenNotifications.isNotificationSeen(transactionHash, logIndex);

  Future<void> addSeenNotification(String transactionHash, int logIndex) async {
    _seenNotifications.addSeenNotification(transactionHash, logIndex);
    await SeenNotificationsApi.postUserSeenNotification(userId, transactionHash, logIndex);
  }
}