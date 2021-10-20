import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kotarica/ads/SavedAds/savedAdsPage.dart';
import 'package:kotarica/constants/Tema.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/models/SavedAdsModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedItemCard extends StatefulWidget {
  final Product product;
  final Function press;

  const SavedItemCard({
    Key key,
    this.product,
    this.press,
  }) : super(key: key);

  @override
  _SavedItemCardState createState() => _SavedItemCardState();
}

class _SavedItemCardState extends State<SavedItemCard> {
  var image;

  void initState() {
    super.initState();
    _getUsername();
    _getId();
    image = _loadImage(widget.product.images[0]);
  }

  String ime;
  int id;

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
    var savedAdsModel = Provider.of<SavedAdsModel>(context, listen: false);
    var userModel = Provider.of<UserModel>(context, listen: false);

    Icon removeIcon = Icon(
      Icons.close, // Icons.favorite_border
      color: Colors.red,
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
                color: widget.product.color,
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
                child: IconButton(
                    icon: removeIcon,
                    onPressed: () async {
                      savedAdsModel.setSavedProductsReady(true);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SavedAdsPage()),
                          (Route<dynamic> route) => false);

                      // String username = (ime != null ? ime : "");

                      bool answer = await savedAdsModel.save(id, widget.product.ownerId, widget.product.id);

                      Fluttertoast.showToast(
                          msg: answer ? "Oglas uspešno uklonjen" : "Greška pri uklanjanju oglasa",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }),
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
