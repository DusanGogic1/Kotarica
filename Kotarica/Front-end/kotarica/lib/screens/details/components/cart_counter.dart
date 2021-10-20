import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';


import 'package:kotarica/constants/style.dart';


//brojac na oglasnoj strani, koliko proizvoda zeli da doda u korpu

class CartCounter extends StatefulWidget {
  @override
  CartCounterState createState() => CartCounterState();
}

class CartCounterState extends State<CartCounter> {
  static int numOfItems = 1;
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
            style: TextStyle(color: Tema.dark?bela:crnaGlavna,
            ),
          ),
        ),
        buildOutlineButton(
            icon: Icons.add,
            press: () {
              setState(() {
                numOfItems++;
              });
            }

            ),
      ],
    );
  }

  SizedBox buildOutlineButton({IconData icon, Function press}) {
    var size = MediaQuery.of(context).size.width;
    return SizedBox(
      width: size * 0.08,
      height: size * 0.08,
      child: OutlineButton(
        color: Tema.dark?bela:crnaGlavna,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: press,
        child: Icon(icon,color:Tema.dark?bela:crnaGlavna),
      ),
    );
  }
}
