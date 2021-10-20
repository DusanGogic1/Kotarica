import 'dart:collection';

class SeenNotifications {
  final _seenNotifications = HashMap<String, Set<int>>();

  bool isNotificationSeen(String transactionHash, int logIndex) {
    return _seenNotifications[transactionHash]?.contains(logIndex) ?? false;
  }

  void addSeenNotification(String transactionHash, int logIndex) {
    _seenNotifications[transactionHash] ??= <int>{}
        ..add(logIndex);
  }
}