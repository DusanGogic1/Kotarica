import 'package:flutter/material.dart';
import 'package:kotarica/ads/MyAds/MojiProizvodi.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:provider/provider.dart';

import 'DetailsBodyWeb.dart';
import 'mainViewWeb.dart';

class DetailsScreenMyAdsWeb extends StatelessWidget {
  final Product product;

  const DetailsScreenMyAdsWeb({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: product.color,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(child: BodyDetailsWeb(product: product)),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: zelena1,
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Image.asset(
            "images/icons/search.png",
            color: svetlaBoja,
          ),
          onPressed: () {
            showSearch(context: context, delegate: DataSearch(Provider.of<ProductModelWeb>(context, listen: false).Myproducts));
          },
        ),
        IconButton(
          icon: Image.asset(
            "images/icons/cart.png",
            color: svetlaBoja,
          ),
          onPressed: () {},
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
