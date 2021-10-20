import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kotarica/constants/network.dart';

const _chatApiUrl = NetworkConstants.chatApiUrl;
const _jsonHeader = const <String, String> {
  'Content-Type': 'application/json; charset=UTF-8',
};

class ChatApi {
  ChatApi._();

  static Future<http.Response> _get(String requestUrl, String errorMsg) async {
    var response = await http.get(requestUrl);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(errorMsg);
    }
  }

  static Future<List<dynamic>> getChatsForUser(int userId) async {
    var requestUrl = "$_chatApiUrl/$userId";
    var response = await _get(requestUrl, "Failed to get chats for user at URL: $requestUrl");
    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getMessagesForChat(int productId, int userId, int otherId) async {
    var requestUrl = "$_chatApiUrl/$productId/$userId/$otherId";
    var response = await _get(requestUrl, "Failed to get messages for chat at URL: $requestUrl");
    return jsonDecode(response.body);
  }

  // Example message GUID string: "2aab7976-f102-4165-bbe3-6704a8862653"
  static Future<dynamic> getMessage(String messageGuidString) async {
    var requestUrl = "$_chatApiUrl/Message/$messageGuidString";
    var response = await _get(requestUrl, "Failed to get message at URL: $requestUrl");
    return jsonDecode(response.body);
  }

  static Future<dynamic> sendMessage(int productId, int sellerUserId, int receiverUserId, String messageType, String messageContent) async {
    assert(messageType == "text" || messageType == "images");
    var requestUrl = "$_chatApiUrl/";
    var encodedMessage = _encodeMessage(productId, sellerUserId, receiverUserId, messageType, messageContent);
    var response = await http.post(
      requestUrl,
      headers: _jsonHeader,
      body: encodedMessage,
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to post message at URL: $requestUrl; Headers: $_jsonHeader; Body: $encodedMessage");
    }
    return jsonDecode(response.body);
  }

  static String _encodeMessage(int productId, int sellerUserId, int receiverUserId, String messageType, String messageContent) {
    return jsonEncode(<String, dynamic>{
      'productId': productId,
      'senderId': sellerUserId,
      'receiverId': receiverUserId,
      'messageType': messageType,
      'content': messageContent
    });
  }
}