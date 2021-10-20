import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kotarica/cart/models/Cart.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';

import 'package:kotarica/cart/size/size_config.dart';
import 'package:kotarica/cart/size/constants.dart';
import 'package:kotarica/util/helper_functions.dart';

Future<ImageProvider> _loadImage(String thumbnail) async {
  String image = await ipfsImage(thumbnail);
  return Image.memory(base64Decode(image)).image;
}

class CartCardWeb extends StatelessWidget {
  const CartCardWeb({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Tema.dark ? Color.fromRGBO(24,44,37,1) : Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FutureBuilder(
                future: _loadImage(product.images[0]),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Image(image: snapshot.data);
                } else
                  return CircularProgressIndicator();
              }),
            ),
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.title,
              style: TextStyle(
                  color: Tema.dark ? svetloZelena : Colors.black,
                  fontSize: 18),
              maxLines: 2,
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: "${product.priceRsd}.00 rsd",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: kPrimaryColor),
              ),
            ),
            Text.rich(
              TextSpan(
                text: "${product.priceEth} eth",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: kPrimaryColor),
              ),
            )
          ],
        )
      ],
    );
  }
}