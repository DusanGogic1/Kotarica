import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../ChatDetailPage.dart';

// Sadrzaj poruke
class ChatMessage {
  final String id;
  final int advertId;
  final int myId;
  final int otherId;
  final String messageType;
  final String content;
  final String timeStamp;
  final MessageType type;
  final int sendedBy;

  ChatMessage(
      {@required this.id,
      @required this.advertId,
      @required this.myId,
      @required this.otherId,
      @required this.messageType,
      @required this.content,
      @required this.timeStamp,
      @required this.type,
      @required this.sendedBy});

  factory ChatMessage.fromJson(Map<String, dynamic> json, int userId) {
    final DateFormat formatter = DateFormat('HH:mm dd-MM-yyyy');
    final String formattedDate =
        formatter.format(DateTime.parse(json['timeStamp'].toString()));

    var tempType;
    var tempOtherId;
    var tempSendedBy;
    if (userId == int.parse(json['senderId'].toString())) {
      tempOtherId = int.parse(json['receiverId'].toString());
      tempType = MessageType.Sender;
      tempSendedBy = userId;
    } else {
      tempOtherId = int.parse(json['senderId'].toString());
      tempType = MessageType.Receiver;
      tempSendedBy = tempOtherId;
    }

    return ChatMessage(
        id: json['id'] as String,
        advertId: json['productId'] as int,
        myId: userId as int,
        otherId: tempOtherId as int,
        messageType: json['messageType'] as String,
        content: json['content'] as String,
        timeStamp: formattedDate as String,
        type: tempType as MessageType,
        sendedBy: tempSendedBy as int);
  }
}
