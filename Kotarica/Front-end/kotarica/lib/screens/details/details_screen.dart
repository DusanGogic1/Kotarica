import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/cart/cart_screen.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/screens/details/components/body.dart';
import 'package:provider/provider.dart';

import '../../models/ProductModel.dart';

class DetailsScreen extends StatelessWidget {
  final Product product;

  const DetailsScreen({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Tema.dark?darken(product.color,.3):product.color,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(child: Body(product: product)),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    var productModel = Provider.of<ProductModel>(context);
    return AppBar(
      //iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Tema.dark ? zelenaDark: zelena1,
      elevation: 0,
      actions: <Widget>[
        IconButton(icon: Badge(
          shape: BadgeShape.circle,
          badgeColor: Colors.white,
          badgeContent: Text(productModel.getCartLength().toString(),
            style: TextStyle(fontSize: 11, color: zelena1),
          ),
          position: BadgePosition.topEnd(top: -15, end: -15),
          animationType: BadgeAnimationType.scale,
          child: Icon(Icons.shopping_cart_outlined, color: Tema.dark ? bela : bela),),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CartScreen()));
          },
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
