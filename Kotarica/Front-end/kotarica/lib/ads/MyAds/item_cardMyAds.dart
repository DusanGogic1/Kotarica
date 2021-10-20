import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'MojiProizvodi.dart';

bool selected = false;

class ItemCardMyAds extends StatefulWidget {
  final Product product;
  final Function press;

  const ItemCardMyAds({
    Key key,
    Product this.product,
    this.press,
  }) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCardMyAds> {
  Future<ImageProvider> _loadImage(String thumbnail) async {
    String image = await ipfsImage(thumbnail);
    return Image.memory(base64Decode(image)).image;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

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
                color: Tema.dark? darken(widget.product.color,.3):widget.product.color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Container(
                margin: EdgeInsets.only(left: size * 0, right: size * 0),
                child: Hero(
                  tag: "${widget.product.id}",
                  child: FutureBuilder(
                      future: _loadImage(widget.product.images[0]),
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
          Row(
            children: [
              Column(
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
                              color: Tema.dark ? bela : crnaGlavna,
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
            ],
          )
        ],
      ),
    );
  }
}
