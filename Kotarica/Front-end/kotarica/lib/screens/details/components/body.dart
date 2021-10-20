import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';

import 'add_to_cart.dart';
import 'color_and_size.dart';
import 'counter_with_fav_btn.dart';
import 'description.dart';
import 'product_title_with_image.dart';

class Body extends StatelessWidget {
  final Product product;

  const Body({Key key, this.product}) : super(key: key);
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
                        ColorAndSize(product: product),
                       // SizedBox(height: kDefaultPaddin / 5),
                        Description(product: product), //user
                        SizedBox(height: kDefaultPaddin / 2),
                        CounterWithFavBtn(product: product,),
                        SizedBox(height: kDefaultPaddin / 2),
                        if(product.type == "Nudim")
                          AddToCart(product: product)
                      ],
                    ),
                  ),
                ),
                ProductTitleWithImage(product: product)
              ],
            ),
          )
        ],
      ),
    );
  }
}
