import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/ads/AddAdvertPageOne.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/navigation_drawer/maindrawer.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';

import '../constants/style.dart';
import 'ChatPage.dart';

class MainPageChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: Drawer(
        child: MainDrawer(),
      ),
      body: ChatPage(),
      backgroundColor: Tema.dark?darkPozadina:bela,
      //BOTTOM BAR
      appBar: buildAppBar(context),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn2",
        child: Icon(
          Icons.pending_actions,
          color: bela,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddAdvertPageOne()));
        },
        backgroundColor: crvenaGlavna,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: buildBottomBar(context),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Poruke", style: Theme.of(context).textTheme.headline4.copyWith(
                color: belaGlavna, fontWeight: FontWeight.bold, fontSize: 25)),
          ],
        ),
      ),
      backgroundColor:Tema.dark?zelenaDark: zelena1,
      elevation: 0,
      actions: <Widget>[
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
