import 'package:flutter/material.dart';
import 'package:kotarica/chat/ChatDetailPage.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/product/Product.dart';
import 'package:provider/provider.dart';

import 'cart_counter.dart';

bool selected = false;

class CounterWithFavBtn extends StatefulWidget {
  Product product;
  CounterWithFavBtn({
    this.product,
    Key key,
  }) : super(key: key);

  @override
  _CounterWithFavBtnState createState() => _CounterWithFavBtnState();
}

class _CounterWithFavBtnState extends State<CounterWithFavBtn> {
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
        //ZA POVECAVANJE I SMANJIVANJE COUNTERA
        widget.product.type == "Nudim"
            ? CartCounter()
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Tema.dark ? svetloZelena : zelena1,
                  ),
                ),
                child: IconButton(
                  icon: Icon(Icons.chat),
                  //uzima boju oglasa na pocetnoj strani
                  color: Tema.dark ? svetloZelena : zelena1,
                  onPressed: () async {
                    String _otherUsername =
                        await _getFirstnameLastname(widget.product.ownerId);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ChatDetailPage(widget.product.id,
                          widget.product.ownerId, _otherUsername);
                    }));
                  },
                ),
              ),

        // Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(18),
        //     border: Border.all(
        //         color: Tema.dark ? svetloZelena : zelena1,
        //     ),
        //   ),
        //   child:IconButton(
        //     icon: Icon(Icons.chat),
        //     //uzima boju oglasa na pocetnoj strani
        //     color: Tema.dark ? svetloZelena : zelena1,
        //     onPressed: () {
        //     },
        //   ),
        // ),
        Container(
          // padding: EdgeInsets.all(8),
          //moze da se doda sa favourites
          child: IconButton(
              icon: selected ? secondIcon : firstIcon,
              onPressed: () {
                setState(() {
                  selected = !selected;
                });
              }),
          // Icon(Icons.star_border_sharp,size: 30,color: Colors.green[500],)) // Icons.favorite)
          //Image.asset("images/icons/heart.png"),
        )
      ],
    );
  }
}