import 'package:flutter/material.dart';
import 'package:kotarica/cart/cart_screen.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/screens/details/components/body.dart';
import 'package:kotarica/web/cart/cart_screenWeb.dart';

import 'components/bodyWeb.dart';

class DetailsScreenWeb extends StatelessWidget {
  final Product product;

  const DetailsScreenWeb({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: product.color,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(child: BodyWeb(product: product)),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: zelena1,
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Image.asset(
            "images/icons/cart.png",
            color: svetlaBoja,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CartScreenWeb()));
          },
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
