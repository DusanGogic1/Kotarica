import 'package:flutter/material.dart';
import 'package:kotarica/ads/kupljeniOglasi/modeli/Porudzbina.dart';
import 'package:kotarica/cart/models/Cart.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/strings.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/product/Product.dart';

import 'components/body.dart';

class kupljeni extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: BodyKupljeni(),
      //bottomNavigationBar: CheckoutCard(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Tema.dark ? svetloZelena : Colors.white),
          onPressed: () {
            //=> Navigator.of(context).pop(),
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }),
      backgroundColor: Tema.dark ? siva2 : zelena1,
      title: Column(
        children: [
          Text(
            "Kupili ste",
            style: TextStyle(color: Tema.dark ? svetloZelena : belaGlavna),
          ),
        ],
      ),
    );
  }
}
