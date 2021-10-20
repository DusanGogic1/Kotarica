import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';

import 'package:kotarica/cart/size/constants.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:provider/provider.dart';

import '../../chat/ChatDetailPage.dart';
import '../../models/UserModel.dart';
import '../../screens/details/components/counter.dart';

Future<ImageProvider> _loadImage(String thumbnail) async {
  String image = await ipfsImage(thumbnail);
  return Image.memory(base64Decode(image)).image;
}

class CartCard extends StatelessWidget {
  const CartCard({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {

    SizedBox buildOutlineButton({IconData icon, Function press}) {
      var size = MediaQuery.of(context).size.width;
      return SizedBox(
        width: size * 0.08,
        height: size * 0.08,
        child: OutlineButton(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          onPressed: press,
          child: Icon(icon),
        ),
      );
    }
    int numOfItems = 1;

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
                text: "${product.priceRsd}.00 RSD",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: kPrimaryColor),
              ),
            ),
            Text.rich(
              TextSpan(
                text: "${product.priceEth.toStringAsFixed(6)} ETH",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: kPrimaryColor),
              ),
            ),
            Text.rich(
              TextSpan(
                text: "Količina: ${product.amount.toString() + product.measuringUnit} ",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: kPrimaryColor),
              ),
            ),
            Counter(product: product)
          ],
        )
      ],
    );
  }
}

class Counter extends StatefulWidget {
  Product product;
  Counter({
    this.product,
    Key key,
  }) : super(key: key);

  @override
  CounterState createState() => CounterState();
}

class CounterState extends State<Counter> {
  Icon firstIcon = Icon(
    Icons.bookmark_border, // Icons.favorite
    color: Colors.green, // Colors.red
    size: 30,
  );

  Icon secondIcon = Icon(
    Icons.bookmark, // Icons.favorite_border
    color: Colors.green,
    size: 30,
  );
  Future<String> _getFirstnameLastname(int otherId) async {
    String _otherUsername = await Provider.of<UserModel>(context, listen: false)
        .getFirstnameLastname(otherId);
    return _otherUsername;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
            CartCounter(product: widget.product)
      ],
    );
  }
}