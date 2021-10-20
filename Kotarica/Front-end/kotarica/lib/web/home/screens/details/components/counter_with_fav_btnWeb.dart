import 'package:flutter/material.dart';
import 'package:kotarica/constants/style.dart';


import 'cart_counterWeb.dart';
bool selected = false;

class CounterWithFavBtnWeb extends StatefulWidget {
   CounterWithFavBtnWeb({
    Key key,
  }) : super(key: key);

  @override
  _CounterWithFavBtnState createState() => _CounterWithFavBtnState();
}

class _CounterWithFavBtnState extends State<CounterWithFavBtnWeb> {
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        //ZA POVECAVANJE I SMANJIVANJE COUNTERA
        //CartCounter(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: zelena1,
            ),
          ),
          child:IconButton(
            icon: Icon(Icons.chat),
            //uzima boju oglasa na pocetnoj strani
            color: zelena1,
            onPressed: () {
              //---ZA SAD NEK IDE SAMO NA PORUKE---
            },
          ),
        ),
        Container(
         // padding: EdgeInsets.all(8),
          //moze da se doda sa favourites
          child: IconButton(
              icon: selected ? secondIcon : firstIcon,
              onPressed: () {
                setState(() {
                  selected = !selected;
                });
              }
    ),
         // Icon(Icons.star_border_sharp,size: 30,color: Colors.green[500],)) // Icons.favorite)
          //Image.asset("images/icons/heart.png"),
        )

      ],
    );
  }
}
