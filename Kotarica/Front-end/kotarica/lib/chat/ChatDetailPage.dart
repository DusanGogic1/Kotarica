import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/chat/ChatUtils/ChatAPI.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/ChatBubble.dart';
import 'components/ChatDetailPageAppBar.dart';
import 'models/ChatMessage.dart';
import 'models/SendMenuItems.dart';

enum MessageType {
  Sender,
  Receiver,
}

bool isLoading = false;

class ChatDetailPage extends StatefulWidget {
  int advertId;
  int otherId;
  String otherUsername;

  ChatDetailPage(this.advertId, this.otherId, this.otherUsername);

  @override
  _ChatDetailPageState createState() =>
      _ChatDetailPageState(advertId, otherId, otherUsername);
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  int advertId;
  int otherId;
  String otherUsername;

  //String adsTitle="Domaći ajvar";

  _ChatDetailPageState(this.advertId, this.otherId, this.otherUsername);

  /* Main func */
  Future<List<ChatMessage>> _getMessagesForUser() async {
    List<ChatMessage> messagesForUser = [];
    int _userId = await _loadId();

    // Get messages from db
    final _messagesParsed =
        await ChatApi.getMessagesForChat(advertId, _userId, otherId);

    messagesForUser = _messagesParsed
        .map<ChatMessage>((json) => ChatMessage.fromJson(json, _userId))
        .toList();

    return messagesForUser.reversed.toList();
  }

  Future<int> _loadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt("id");
  }

  _sendMessage() async {
    setState(() {
      isLoading = true;
    });

    if (messageInput.text.isNotEmpty) {
      int _userId = await _loadId();

      print("Request: productId: " +
          advertId.toString() +
          ' senderId: ' +
          _userId.toString() +
          ' receiverId: ' +
          otherId.toString() +
          ' messageType: ' +
          "text" +
          ' content: ' +
          messageInput.text);

      var response = await ChatApi.sendMessage(
          advertId, _userId, otherId, "text", messageInput.text);

      print("Response: " + response.toString());
    }

    setState(() {
      isLoading = false;
      messageInput.clear();
    });
  }

  // DODATAK ZA PORUKE
  List<SendMenuItems> menuItems = [
    // SendMenuItems(text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
    // SendMenuItems(text: "Document", icons: Icons.insert_drive_file, color: Colors.blue),
    // SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.orange),
    // SendMenuItems(text: "Location", icons: Icons.location_on, color: Colors.green),
    // SendMenuItems(text: "Contact", icons: Icons.person, color: Colors.purple),
  ];

  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    itemCount: menuItems.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: menuItems[index].color.shade50,
                            ),
                            height: 50,
                            width: 50,
                            child: Icon(
                              menuItems[index].icons,
                              size: 20,
                              color: menuItems[index].color.shade400,
                            ),
                          ),
                          title: Text(menuItems[index].text),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  TextEditingController messageInput = new TextEditingController();
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<ImageProvider> getFirstImage() async {
    var productModel = Provider.of<ProductModel>(context, listen: false);
    var productImage = (await productModel.getProductById(advertId)).images[0];
    return loadIpfsImage(productImage);
  }

  Future<String> getOwner() async {
    var productModel = Provider.of<ProductModel>(context, listen: false);
    var product = await productModel.getProductById(advertId);
    return product.ownerId == widget.otherId
        ? ("Prodavac " +
            widget.otherUsername +
            ", " "\nproizvoda " +
            product.title)
        : ("Kupac " +
            widget.otherUsername +
            ", " +
            "\nproizvod " +
            product.title);
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 1),
      () => _controller.hasClients
          ? _controller.jumpTo(_controller.position.maxScrollExtent)
          : null,
    );
    /*String punoIme = ProductModel.totalProducts[advertId].ownerId==widget.otherId?
    ("Prodavac: "+widget.otherUsername + "\nProizvod: " + ProductModel.totalProducts[advertId].title):
    ("Kupac: "+widget.otherUsername + "\nProizvod: " + ProductModel.totalProducts[advertId].title);*/
    return Scaffold(
      backgroundColor: Tema.dark ? darkPozadina : bela,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.00),
          child: AppBar(
            //elevation: 0, opciono za dodavanje
            automaticallyImplyLeading: false,
            backgroundColor: Tema.dark ? siva2 : bela,
            foregroundColor: Tema.dark ? bela : siva2,
            flexibleSpace: FutureBuilder(
                future: getOwner(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return ChatDetailPageAppBar(snapshot.data, advertId);
                  } else
                    return Text("");
                }),
          )),
      /*ChatDetailPageAppBar(punoIme, advertId),*/
      body: Stack(
        children: <Widget>[
          // isLoading
          //   ? Center(
          //       child: CircularProgressIndicator(),
          // ) :
          SingleChildScrollView(
            controller: _controller,
            child: Container(
              child: FutureBuilder(
                  future: _getMessagesForUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<ChatMessage> messages = snapshot.data;
                      return ListView.builder(
                        itemCount: messages.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatBubble(
                            chatMessage: messages[index],
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ),
          /* ------- INPUT ZA PORUKU ------*/
          if (ProductModel.totalProducts[advertId] != null)
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                height: 80,
                width: double.infinity,
                color: Tema.dark ? darkPozadina : bela,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        minLines: 2,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        controller: messageInput,
                        decoration: InputDecoration(
                          hintText: "Napiši poruku...",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                                color: Tema.dark ? bela : plavaTekst,
                                width: 0.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                                color: Tema.dark ? crvenaGlavna : plavaTekst,
                                width: 0.5),
                          ),

                          //border: InputBorder.none
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          /* ------DUGME ZA SLANJE ---------*/
          if (ProductModel.totalProducts[advertId] != null)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.only(right: 30, bottom: 50),
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _sendMessage();
                      print("message sended...");
                    });
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  backgroundColor: crvenaGlavna,
                  elevation: 0,
                ),
              ),
            ),
          if (ProductModel.totalProducts[advertId] == null)
            Align(
              child: Padding(
                  child: Text("Ovaj oglas je obrisan. Ne možete slati poruke.",
                      style: TextStyle(
                          color: Tema.dark ? Colors.white : Colors.black)),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20)),
              alignment: Alignment.bottomCenter,
            )
        ],
      ),
    );
  }
}
