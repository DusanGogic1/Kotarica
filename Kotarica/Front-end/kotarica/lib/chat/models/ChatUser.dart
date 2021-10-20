import 'package:flutter/cupertino.dart';

class ChatUser {
  int advertId;
  int myId;
  int otherId;

  String otherUsername;
  String secondaryText;
  String image;
  String time;

  ChatUser(this.advertId, this.myId, this.otherId, this.otherUsername, this.secondaryText, this.image, this.time);
}
