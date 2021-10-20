import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/web/cart/cart_screenWeb.dart';

import 'components/body.dart';

class DetailsScreenWeb2 extends StatefulWidget {
  final Product product;

  const DetailsScreenWeb2({Key key, this.product}) : super(key: key);

  @override
  _DetailsScreenWeb2State createState() => _DetailsScreenWeb2State();
}

class _DetailsScreenWeb2State extends State<DetailsScreenWeb2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Tema.dark?darken(widget.product.color,.3):widget.product.color,
        appBar: buildAppBar(context),
        body: SingleChildScrollView(child: BodyWebOglas(product: widget.product)),
      ),
    );
  }



  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      //iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Tema.dark ? zelenaDark: zelena1,
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.shopping_cart_outlined, color: Tema.dark ? bela : bela),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CartScreenWeb()));
          },
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}