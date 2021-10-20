import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tuple/tuple.dart';
import 'package:wallet_core/wallet_core.dart';
import '../notification/NotificationClasses.dart';

class PushNotificationHelper {
  static const _initSettings = InitializationSettings(android: AndroidInitializationSettings('app_icon'));

  final _plugin = FlutterLocalNotificationsPlugin();
  final NotificationDetails _notificationDetails;

  final String channelId;
  final String channelName;
  final String channelDescription;
  int _index = 0;

  final Future<dynamic> Function(String payload) _onSelectNotification;

  PushNotificationHelper({
    @required this.channelId,
    @required this.channelName,
    @required this.channelDescription,
    Future<dynamic> Function(String payload) onSelectNotification,
  }) : _onSelectNotification = onSelectNotification,
        _notificationDetails = NotificationDetails(android: AndroidNotificationDetails(channelId, channelName, channelDescription)) {
    _plugin.initialize(_initSettings, onSelectNotification: _onSelectNotification);
  }

  int reserveId() => _index++;

  Future<int> show (String title, String body, {int id, String payload}) async {
    id ??= _index++;
    await _plugin.show(id, title, body, _notificationDetails, payload: payload);
    return id;
  }

  Future<void> cancel (int id, {String tag}) => _plugin.cancel(id, tag: tag);
}