import 'package:flutter/material.dart';


import 'package:kotarica/constants/style.dart';


//brojac na oglasnoj strani, koliko proizvoda zeli da doda u korpu

class CartCounterWeb extends StatefulWidget {
  @override
  _CartCounterState createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounterWeb> {
  int numOfItems = 1;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Row(
      children: <Widget>[
        buildOutlineButton(
          icon: Icons.remove,
          press: () {
            if (numOfItems > 1) {
              setState(() {
                numOfItems--;
              });
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
          child: Text(
            numOfItems.toString().padLeft(2, "0"),
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        buildOutlineButton(
            icon: Icons.add,
            press: () {
              setState(() {
                numOfItems++;
              });
            }),
      ],
    );
  }

  SizedBox buildOutlineButton({IconData icon, Function press}) {
    var size = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 10,
      height: 10,
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
}
