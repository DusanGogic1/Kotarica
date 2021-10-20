import 'package:flutter/material.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';

import 'DeleteChangeWeb.dart';
import 'MojiProizvodiWeb.dart';
import 'ProductTitleImageMyAdsWeb.dart';
import 'colorSizeMyAdsWeb.dart';
import 'descriptionMyAdsWeb.dart';

// import 'add_to_cartWeb.dart';
// import 'color_and_sizeWeb.dart';
// import 'counter_with_fav_btnWeb.dart';
// import 'descriptionWeb.dart';
// import 'product_title_with_imageWeb.dart';

class BodyDetailsWeb extends StatelessWidget {
  Product product;

  BodyDetailsWeb({Key key, this.product}) : super(key: key);
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
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  padding: EdgeInsets.only(
                    top: size.height * 0.12,
                    left: kDefaultPaddin,
                    right: kDefaultPaddin,
                  ),
                  // height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      ColorAndSizeMyAdsWeb(product: product),
                      SizedBox(height: kDefaultPaddin / 2),
                      DescriptionMyAdsWeb(product: product),
                      SizedBox(height: kDefaultPaddin / 2),
                      DeleteChangeWeb(product:product),
                    ],
                  ),
                ),
                ProductTitleWithImageMyAdsWeb(product: product)
              ],
            ),
          )
        ],
      ),
    );
  }
}
