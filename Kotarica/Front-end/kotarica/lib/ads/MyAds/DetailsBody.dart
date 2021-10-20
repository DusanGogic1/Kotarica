import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';

import 'DeleteChange.dart';
import 'MojiProizvodi.dart';
import 'ProductTitleImageMyAds.dart';
import 'colorSizeMyAds.dart';
import 'descriptionMyAds.dart';

// import 'add_to_cartWeb.dart';
// import 'color_and_sizeWeb.dart';
// import 'counter_with_fav_btnWeb.dart';
// import 'descriptionWeb.dart';
// import 'product_title_with_imageWeb.dart';

class BodyDetails extends StatelessWidget {
  Product product;
  Brightness getBrightness() {
    return Tema.dark ? Brightness.dark : Brightness.light;
  }
  BodyDetails({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height -91,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.35),
                  padding: EdgeInsets.only(
                    top: size.height * 0.02,
                    left: kDefaultPaddin,
                    right: kDefaultPaddin,
                  ),
                  //height: size.height*0.5,
                  decoration: BoxDecoration(
                    color: Tema.dark ? darkPozadina : Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                        //opciono
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24)
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ColorAndSizeMyAds(product: product),
                        DescriptionMyAds(product: product),
                        SizedBox(height: kDefaultPaddin / 2),
                        DeleteChange(product:product),
                      ],
                    ),
                  ),
                ),
                ProductTitleWithImageMyAds(product: product)
              ],
            ),
          )
        ],
      ),
    );
  }
}
