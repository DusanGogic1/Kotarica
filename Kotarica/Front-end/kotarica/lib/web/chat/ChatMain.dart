import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/navigation_drawer/maindrawer.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/web/ads/AddAdvertPageOneWeb.dart';
import 'package:kotarica/web/home/CalendarSpace/CalendarSpace.dart';
import 'package:kotarica/web/home/HomeScreen.dart';
import 'package:kotarica/web/home/NavigationBar/NavigationBar.dart';

import 'ChatPage.dart';

class MainPageChatWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: Tema.dark?darkPozadina:bela,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children:[
          ChatPageWeb(),
          CalendarSpace(),
        ])

      ),
      backgroundColor: Tema.dark?darkPozadina:bela,
      floatingActionButton: FloatingActionButton(
        heroTag: "btn2",
        child: Icon(
          Icons.pending_actions,
          color: bela,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddAdvertPageOneWeb()));
        },
        backgroundColor: crvenaGlavna,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
