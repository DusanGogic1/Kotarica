import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/chat/ChatUtils/ChatAPI.dart';
import 'package:kotarica/chat/models/ChatMessage.dart';
import 'package:kotarica/chat/models/ChatPayload.dart';
import 'package:kotarica/chat/models/ChatUser.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:kotarica/web/home/CalendarSpace/CalendarSpace.dart';
import 'package:kotarica/web/home/NavigationBar/NavigationBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/ChatUsersList.dart';

class ChatPageWeb extends StatefulWidget {
  @override
  _ChatPageWebState createState() => _ChatPageWebState();
}

class _ChatPageWebState extends State<ChatPageWeb> {
  /* Main func */
  Future<List<ChatUser>> _getChatsForUser() async {
    List<ChatPayload> chatPayloads = [];
    ChatMessage lastMessage;
    String lastMessageUsername;

    List<ChatUser> chatsForUser = [];

    String _otherUsername;
    int _userId = await _loadId();

    // Get payload from db
    final _chatsParsed = await ChatApi.getChatsForUser(_userId);
    print(_chatsParsed);
    chatPayloads = _chatsParsed
        .map<ChatPayload>((json) => ChatPayload.fromJson(json))
        .toList();
    print(chatPayloads);

    // Create chats to show
    for (var i = 0; i < chatPayloads.length; i++) {
      // Get other user
      _otherUsername = await Provider.of<UserModelWeb>(context, listen: false)
          .getFirstnameLastname(_userId == chatPayloads[i].senderId
              ? chatPayloads[i].receiverId
              : chatPayloads[i].senderId);

      // Get last message for each chat
      final _messagesParsed = await ChatApi.getMessagesForChat(
          chatPayloads[i].advertId,
          _userId,
          _userId == chatPayloads[i].senderId
              ? chatPayloads[i].receiverId
              : chatPayloads[i].senderId);

      lastMessage = _messagesParsed
          .map<ChatMessage>((json) => ChatMessage.fromJson(json, _userId))
          .toList()[0];
      lastMessageUsername = await Provider.of<UserModelWeb>(context, listen: false)
          .getFirstnameLastname(lastMessage.sendedBy);

      // Create chats
      chatsForUser.add(new ChatUser(
          chatPayloads[i].advertId,
          _userId,
          _userId == chatPayloads[i].senderId
              ? chatPayloads[i].receiverId
              : chatPayloads[i].senderId,
          _otherUsername,
          lastMessageUsername + ": " + lastMessage.content,
          "images/profilePictureExample.jpg",
          //slika proizvoda!
          lastMessage.timeStamp));

      chatsForUser.sort(
          (a, b) => a.time.compareTo(b.time)); // Sorting based on last activity
    }

    return chatsForUser.reversed.toList();
  }

  Future<int> _loadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt("id");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Tema.dark ? darkPozadina : bela,
        body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.75,
        child: Stack(
          children: [
            NavigationBar(),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                  margin: EdgeInsets.only(left: size * 0.3),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Pretraga cetova
                    /*Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Pretraži...",
                          hintStyle: TextStyle(color: crvenaGlavna),
                          prefixIcon: Icon(
                            Icons.search,
                            color: crvenaGlavna,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: crvenaGlavna)),
                        ),
                      ),
                    ),*/
                    // Prikaz cetova
                    FutureBuilder(
                        future: _getChatsForUser(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<ChatUser> chats = snapshot.data;
                            return ListView.builder(
                              itemCount: chats.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 16),
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                //print(chats[index].advertId.toString() + " chat");
                                try {
                                  return ChatUsersListWeb(
                                    advertId: chats[index].advertId,
                                    myId: chats[index].myId,
                                    otherId: chats[index].otherId,
                                    otherUsername: chats[index].otherUsername,
                                    lastMessage: chats[index].secondaryText,
                                    image: chats[index].image,
                                    time: chats[index].time,
                                    isMessageRead: false,
                                  );
                                }
                              catch(error, trace) {
                                  print(error);
                                  print(trace);
                                return SizedBox();
                              }

                            }
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ],
                ))),
          ]
        )
      ),
    );
  }
}
