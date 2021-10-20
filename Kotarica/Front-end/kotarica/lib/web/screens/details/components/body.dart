import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/screens/details/components/color_and_size.dart';
import 'package:kotarica/screens/details/components/counter_with_fav_btn.dart';
import 'package:kotarica/screens/details/components/description.dart';
import 'package:kotarica/screens/details/components/product_title_with_image.dart';

import 'add_to_cart.dart';
import 'color_and_size.dart';
import 'counter_with_fav_btn.dart';
import 'description.dart';
import 'product_title_with_image.dart';

class BodyWebOglas extends StatelessWidget {
  final Product product;

  const BodyWebOglas({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container( //BELI DEO NA OGLASU
                  margin: EdgeInsets.only(top: size.height * 0.35),
                  padding: EdgeInsets.only(
                    top: size.height * 0.02 ,
                    left: kDefaultPaddin,
                    right: kDefaultPaddin,
                  ),
                  // height: 500,
                  decoration: BoxDecoration(
                    color: Tema.dark ? darkPozadina : bela,  //DONJI DEO
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        //opciono
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24)
                    ),
                  ),
                  child: SingleChildScrollView(  ///DODALA SAM ZBOG SCROL-A NA MANJEM UREDJAJU
                    child: Column(
                      children: <Widget>[
                        ColorAndSizeWeb(product: product),
                        // SizedBox(height: kDefaultPaddin / 5),
                        DescriptionWeb(product: product), //user
                        SizedBox(height: kDefaultPaddin / 2),
                        CounterWithFavBtnWeb(),
                        SizedBox(height: kDefaultPaddin / 2),
                        //if(product.type == "Nudim")
                          //AddToCart(product: product)
                      ],
                    ),
                  ),
                ),
                ProductTitleWithImageWeb(product: product)
              ],
            ),
          )
        ],
      ),
    );
  }
}
