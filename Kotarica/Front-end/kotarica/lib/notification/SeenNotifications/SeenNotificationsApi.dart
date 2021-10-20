import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kotarica/constants/network.dart';

const _seenNotificationsApiUrl = NetworkConstants.seenNotificationsApiUrl;
const _jsonHeader = const <String, String> {
  'Content-Type': 'application/json; charset=UTF-8',
};

class SeenNotificationsApi {
  SeenNotificationsApi._();

  static Future<List<dynamic>> getUserSeenNotifications(int userId) async {
    var requestUrl = "$_seenNotificationsApiUrl/$userId";
    var response = await http.get(requestUrl);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to get seen notifications at URL: $requestUrl");
    }
  }

  static Future<void> postUserSeenNotification(int userId, String transactionHash, int logIndex) async {
    var requestUrl = "$_seenNotificationsApiUrl/";
    var encodedNotification = _encodeUserSeenNotification(userId, transactionHash, logIndex);
    var response = await http.post(
      requestUrl,
      headers: _jsonHeader,
      body: encodedNotification,
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to post seen notification at URL: $requestUrl; Headers: $_jsonHeader; Body: $encodedNotification");
    }
  }

  static Future<void> deleteUserSeenNotifications(int userId) async {
    var requestUrl = "$_seenNotificationsApiUrl/$userId";
    var response = await http.delete(requestUrl);
    if (response.statusCode != 204) {
      throw Exception("Failed to delete seen notifications at URL: $requestUrl");
    }
  }

  static String _encodeUserSeenNotification(int userId, String transactionHash, int logIndex) {
    return jsonEncode(<String, dynamic>{
      'userId': userId,
      'transactionHash': transactionHash,
      'logIndex': logIndex,
    });
  }
}