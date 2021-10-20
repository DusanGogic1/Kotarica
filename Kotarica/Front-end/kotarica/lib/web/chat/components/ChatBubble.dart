import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/chat/models/ChatMessage.dart';
import 'package:kotarica/constants/style.dart';

import '../ChatDetailPage.dart';

class ChatBubbleWeb extends StatefulWidget {
  ChatMessage chatMessage;

  ChatBubbleWeb({@required this.chatMessage});

  @override
  _ChatBubbleWebState createState() => _ChatBubbleWebState();
}

class _ChatBubbleWebState extends State<ChatBubbleWeb> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Align(
        alignment: (widget.chatMessage.type == MessageType.Receiver
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: (widget.chatMessage.type == MessageType.Receiver
                ? Colors.redAccent[200]
                : svetloZelena),
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            widget.chatMessage.content,
            style: TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.bold,
              color: plavaTekst,
            ),
          ),
        ),
      ),
    );
  }
}
