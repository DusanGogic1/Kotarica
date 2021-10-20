import 'package:flutter/cupertino.dart';

/* Cet korisnika */
class ChatPayload {
  final int advertId;
  final int senderId;
  final int receiverId;

  ChatPayload(
      {@required this.advertId, @required this.senderId, @required this.receiverId});

  factory ChatPayload.fromJson(Map<String, dynamic> json) {
    return ChatPayload(
        advertId: json['productId'] as int,
        senderId: json['buyer'] as int,
        receiverId: json['seller'] as int);
  }
}
