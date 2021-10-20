import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kotarica/cart/cart_screen.dart';
import 'package:kotarica/cart/components/cart_card.dart';
import 'package:kotarica/cart/components/check_out_card.dart';
import 'package:kotarica/cart/models/Cart.dart';

import 'package:kotarica/cart/size/size_config.dart';
import 'package:kotarica/cart/size/constants.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:provider/provider.dart';

import '../cart_screen.dart';
import '../cart_screen.dart';


class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    var productModel = Provider.of<ProductModel>(context);
    return Container(
      color: Tema.dark ? siva : bela,
      child: Padding(
        padding:EdgeInsets.symmetric(horizontal: 5),
        child: ListView.builder(
          itemCount: ProductModel.cart.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Dismissible(
              key: Key(ProductModel.cart[index].id.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                productModel.removeFromCart(ProductModel.cart[index]);
                  
              },
              background: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Tema.dark ? Color.fromRGBO(24,44,37,1) :Color(0xFFFFE6E6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Spacer(),
                    //--KANTA KAD SE PREVUCE ZA BRISANJE--
                    Image.asset("images/icons/Trash.png"),
                  ],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                    color: Tema.dark ? siva2 : svetloZelena2,
                    child: CartCard(product: ProductModel.cart[index])),
              ),
            ),
          ),
        ),
      ),
    );
  }
}