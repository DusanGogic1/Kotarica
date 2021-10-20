import 'package:flutter/material.dart';
import 'package:kotarica/ads/MyAds/MojiProizvodi.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/product/Product.dart';
import 'package:provider/provider.dart';

import 'DetailsBody.dart';
import 'mainView.dart';

class DetailsScreenMyAds extends StatelessWidget {
  final Product product;

  Brightness getBrightness() {
    return Tema.dark ? Brightness.dark : Brightness.light;
  }

  const DetailsScreenMyAds({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tema.dark?darken(product.color,.3):product.color,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(child: BodyDetails(product: product, )),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Tema.dark? zelenaDark :zelena1,
      elevation: 0,
      actions: <Widget>[
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}