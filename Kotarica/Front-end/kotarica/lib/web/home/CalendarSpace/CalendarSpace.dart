import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/cart/cart_screenWeb.dart';
import 'package:kotarica/web/cart/models/Cart.dart';
import 'package:kotarica/web/home/CalendarSpace/src/CalendarSection.dart';
import 'package:kotarica/web/home/CalendarSpace/src/MeetingsSection.dart';
import 'package:kotarica/web/home/CalendarSpace/src/TopContainer.dart';
import 'package:provider/provider.dart';

import '../../../constants/navigation_drawer/maindrawer.dart';
import '../../cart/cart_screenWeb.dart';
import '../HomeScreen.dart';

class CalendarSpace extends StatefulWidget {
  @override
  _CalendarSpaceState createState() => _CalendarSpaceState();
}

class _CalendarSpaceState extends State<CalendarSpace> {
  void promeniTemu() {
    setState(() {
      Tema.dark = !Tema.dark;
      print("promenio");
      //  Glob().dark=!Glob().dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        color: Tema.dark? lighten(darkPozadina):belaGlavna,

   //     color: Color(0xffF7F7FF),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.15,
        child: Column(
          children: [
            SizedBox(
              height: size * .03,
            ),
            IconButton(
              //hoverColor: zelenaGlavna,
              iconSize: size * 0.02,
              icon: Image.asset("images/icons/cart.png",
                  // By default our  icon color is white
                  color: Tema.dark ? bela : crnaGlavna),
              onPressed: () {
                //Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => CartScreenWeb()),
                        (route) => false);
              },
            ),
            IconButton(
              //hoverColor: zelenaGlavna,
              iconSize: size * 0.02,
              icon: Image.asset("images/icons/search.png",
                  // By default our  icon color is white
                  color: Tema.dark ? bela : crnaGlavna),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: DataSearch(
                        Provider.of<ProductModelWeb>(context, listen: false)
                            .productsToShow));
              },
            ),
            IconButton(
              //hoverColor: zelenaGlavna,
              iconSize: size * 0.02,
              icon: Tema.dark==false? Icon(FontAwesomeIcons.moon):Icon(FontAwesomeIcons.solidMoon),
                  // By default our  icon color is white
                  color: Tema.dark ? bela : crnaGlavna,
              onPressed: () {
                promeniTemu();

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreenWeb()),
                        (route) => false);
              },
            ),
          ],
        ),
      ),

    );
  }
}




