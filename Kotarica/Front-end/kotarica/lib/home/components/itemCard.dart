import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kotarica/ads/SavedAds/savedAdsPage.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/models/SavedAdsModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:kotarica/web/WebModels/SavedAdsModelWeb.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/style.dart';
import '../../constants/style.dart';
import '../../constants/style.dart';

class ItemCard extends StatefulWidget {
  final Product product;
  final Function press;

  final String izabranaKategorija;
  final String izabranaPotkategorija;

  const ItemCard(
      {Key key,
      this.product,
      this.press,
      this.izabranaKategorija,
      this.izabranaPotkategorija})
      : super(key: key);

  @override
  _ItemCardState createState() =>
      _ItemCardState(izabranaKategorija, izabranaPotkategorija);
}

class _ItemCardState extends State<ItemCard> {
  bool exists;

  var image;
  String ime;
  int id;

  String izabranaKategorija;
  String izabranaPotkategorija;

  _ItemCardState(this.izabranaKategorija, this.izabranaPotkategorija);

  void _checkAdvert() async {
    exists = null;
    bool _answer = await Provider.of<SavedAdsModel>(context, listen: false)
        .checkIfExists(widget.product.id);

    setState(() {
      exists = _answer;
    });
  }

  void initState() {
    super.initState();

    _checkAdvert();
    _getId();
    image = _loadImage(widget.product.images[0]);
  }

  Future<String> _loadData(String dataNeeded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = prefs.getString(dataNeeded);
    return data;
  }

  Future<int> _loadDataInt(String dataNeeded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int data = prefs.getInt(dataNeeded);
    return data;
  }

  Future<void> _getUsername() async {
    String username;
    username = await _loadData("username");
    setState(() => ime = username);
  }

  Future<void> _getId() async {
    int _id;
    _id = await _loadDataInt("id");
    setState(() => id = _id);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    Icon firstIcon = Icon(
      Icons.bookmark_border_rounded, // Icons.favorite
      color: Tema.dark ? svetloZelena : crnaGlavna, // Colors.red
      size: 30,
    );

    Icon firstIconDisabled = Icon(
      Icons.bookmark_border_rounded, // Icons.favorite
      color: Tema.dark ? disabledDark : disabled, // Colors.red
      size: 30,
    );

    Icon secondIcon = Icon(
      Icons.bookmark, // Icons.favorite_border
      color: Colors.green,
      size: 30,
    );

    return GestureDetector(
      onTap: widget.press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: size * 0.0001),
              //-----PROMENA VELICINE SLIKE--------
              height: size * 1.2,
              width: size * 0.9,
              padding: EdgeInsets.only(top: size * 0.01, bottom: size * 0.01),
              decoration: BoxDecoration(
                color: Tema.dark
                    ? darken(widget.product.color, .3)
                    : widget.product.color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Container(
                margin: EdgeInsets.only(left: size * 0, right: size * 0),
                child: Hero(
                  tag: "${widget.product.id}",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FutureBuilder(
                        future: image,
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return Image(image: snapshot.data);
                          } else
                            return CircularProgressIndicator();
                        }),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: size * 0.0),
                      child: Padding(
                        padding: EdgeInsets.only(left: size * 0.01),
                        child: Container(
                          margin: EdgeInsets.only(top: size * 0.0001),
                          child: Text(
                            widget.product.title,
                            style: TextStyle(
                                color: Tema.dark ? svetloZelena : crnaGlavna,
                                fontSize: 12,
                                fontFamily: "Montserrat"),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: size * 0.0),
                      child: Text(
                        "${widget.product.priceRsd} RSD",
                        style: TextStyle(
                            color: Tema.dark ? bela : crnaGlavna,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: exists != null
                    ? IconButton(
                        icon: id != widget.product.ownerId
                            ? exists
                                ? secondIcon
                                : firstIcon
                            : firstIconDisabled,
                        onPressed: () async {
                          if (id != widget.product.ownerId) {
                            showLoadingDialog(context);
                            bool answer = await Provider.of<SavedAdsModelWeb>(context, listen: false).save(id, widget.product.ownerId, widget.product.id);

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomeScreen(
                                            izabranaKategorija:
                                                izabranaKategorija,
                                            izabranaPotkategorija:
                                                izabranaPotkategorija)),
                                (Route<dynamic> route) => false);

                            Fluttertoast.showToast(
                                msg: !exists && answer
                                    ? "Oglas uspešno sačuvan"
                                    : exists && answer
                                        ? "Oglas uspešno uklonjen"
                                        : "Greška pri čuvanju oglasa",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Nije moguće dodati sopstveni oglas na listu želja",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        })
                    : Center(
                        child: SizedBox(),
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<ImageProvider> _loadImage(String thumbnail) async {
    print("hash: " + thumbnail);
    String image = await ipfsImage(thumbnail);
    return Image.memory(base64Decode(image)).image;
  }
}
