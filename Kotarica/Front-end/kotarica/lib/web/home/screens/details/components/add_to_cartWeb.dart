import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/ad_rating/rating.dart';
import 'package:kotarica/ads/MyAds/mainView.dart';



import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/components/body.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/product/Product.dart';
import 'package:provider/provider.dart';

//import '../../../chat/ChatMain.dart';
//import '../../../home/HomeScreen.dart';



class AddToCartWeb extends StatefulWidget {
  const AddToCartWeb({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCartWeb> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Row(
        children: <Widget>[
          //--DUGME ZA CET--
          Container(
            margin: EdgeInsets.only(right: kDefaultPaddin),
            height: size * 0.05,
            width: size * 0.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: widget.product.color,
              ),
            ),
            child: IconButton(
              icon: Image.asset("images/icons/add_to_cart.png"),
              //uzima boju oglasa na pocetnoj strani
             // color: widget.product.color,
              onPressed: () {
              },
            ),
          ),
          //---DUGME KUPI---
          Expanded(
            child: SizedBox(
              height: 50,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: widget.product.color,
                onPressed: () {
                  _PopUpPlacanje();
                },
                child: Text(
                  "Kupi".toUpperCase(),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _PopUpPlacanje() async {
    var size = MediaQuery.of(context).size.width;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: SingleChildScrollView(
            child: ListBody(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Izaberite način plaćanja",
                          style: TextStyle(color: zelena1, fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  RadioButton(priceEth: widget.product.priceEth),
                ]
            ),
          ),
          actions: <Widget>[
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              color: zelena1,
              onPressed: () {
                // Navigator.of(context).pop();
                 Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) => RatingPage(username: widget.product.ownerId, ID: widget.product.id)));
              },
              child: Text(
                "Kupi".toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: belaGlavna,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}