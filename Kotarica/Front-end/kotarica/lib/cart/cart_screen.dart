import 'package:flutter/material.dart';
import 'package:kotarica/cart/models/Cart.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:provider/provider.dart';

import '../constants/Tema.dart';
import '../constants/style.dart';
import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatelessWidget {
  //static String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
      bottomNavigationBar: CheckoutCard(),
    );
  }
  AppBar buildAppBar(BuildContext context) {
    var productModel = Provider.of<ProductModel>(context);
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color:Tema.dark?svetloZelena: Colors.white),
        onPressed: () { //=> Navigator.of(context).pop(),
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen()));

        }),
      backgroundColor: Tema.dark ? siva2 : zelena1,
      title: Column(
        children: [
          Text(
            "Vaša korpa",
            style: TextStyle( color: Tema.dark ? svetloZelena : belaGlavna),
          ),
          //--BROJ U KORPI--
          Text(
            productModel.getCartTopText(),
            style:TextStyle( color: Tema.dark ? svetloZelena :svetloZelena, fontSize: 12),
          ),
        ],
      ),
    );
  }
}