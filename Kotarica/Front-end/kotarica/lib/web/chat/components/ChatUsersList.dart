import 'package:flutter/material.dart';
import 'package:kotarica/cart/models/Product.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:provider/provider.dart';

import '../ChatDetailPage.dart';
import '../ChatMain.dart';

class ChatUsersListWeb extends StatefulWidget {
  int advertId;
  int myId;
  int otherId;

  String otherUsername;
  String lastMessage;
  String image;
  String time;
  bool isMessageRead;

  ChatUsersListWeb(
      {@required this.advertId,
      @required this.myId,
      @required this.otherId,
      @required this.otherUsername,
      @required this.lastMessage,
      @required this.image,
      @required this.time,
      @required this.isMessageRead});

  @override
  _ChatUsersListWebState createState() =>
      _ChatUsersListWebState(advertId, myId, otherId, otherUsername);
}

class _ChatUsersListWebState extends State<ChatUsersListWeb> {
  int advertId;
  int myId;
  int otherId;
  String otherUsername;

  //String adsTitle = "Domaci ajvar";
  _ChatUsersListWebState(
      this.advertId, this.myId, this.otherId, this.otherUsername);

  Future<ImageProvider> getFirstImage() async {
    var productModel = Provider.of<ProductModelWeb>(context, listen: false);
    var productImage = (await productModel.getProductById(advertId)).images[0];
    return loadIpfsImage(productImage);
  }

  Future<String> getOwner() async {
    var productModel = Provider.of<ProductModelWeb>(context, listen: false);
    var product = await productModel.getProductById(advertId);
    return product.ownerId == widget.otherId ? ("Prodavac " + widget.otherUsername + ", ""\nproizvoda " + product.title) :
    ("Kupac " + widget.otherUsername + ", "+"\nproizvod " + product.title);
  }


  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) =>
                    ChatDetailPageWeb(advertId, otherId, otherUsername)))
            .then((value) => _reload(value));
        },
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    FutureBuilder(
                      future: getFirstImage(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null)
                          return Image(image: snapshot.data, width: 80);
                        else
                          return CircularProgressIndicator();
                      },
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FutureBuilder(
                              future: getOwner(),
                              builder: (context, snap) {
                                if(snap.data != null)
                                  return Text(snap.data,
                                    style: TextStyle(
                                    //IME KORISNIKA
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Tema.dark ? svetloZelena2 : crnaGlavna,
                                  ),);
                                else return CircularProgressIndicator();
                              }
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(widget.lastMessage,
                              style: TextStyle(
                                fontSize: 12,
                                color: Tema.dark ? svetloZelena : siva,
                              )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ------  VREME ------
              Text(widget.time.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: widget.isMessageRead
                      ? Tema.dark
                          ? plavaGlavna
                          : plavaTekst
                      : Tema.dark
                          ? svetlaBoja
                          : siva,
                )
              ),
            ],
          ),
        ),
      );
  }

  Future<void> _reload(var value) async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MainPageChatWeb()));
  }
}
