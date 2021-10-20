import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/models/BuyingModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_core/wallet_core.dart';
import "package:convert/convert.dart" show hex;
import "package:ethereum_address/ethereum_address.dart";

import '../models/MarksUserModel.dart';
import '../models/UserModel.dart';

/* --- PRIKAZ PROFILA I OCENA DRUGOG KORISNIKA ------ */

class YouRated extends StatefulWidget {
  final String username;

  YouRated({
    @required this.username,
  });

  @override
  _State createState() => _State(username: username);
}

class _State extends State<YouRated> {
  String username;

  _State({this.username});

  @override
  Widget build(BuildContext context) {
    var marksUserModel = Provider.of<BuyingModel>(context, listen: false);
    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            color: Tema.dark ? darkPozadina : Colors.grey.shade200,
            child: Column(children: <Widget>[
              Stack(children: <Widget>[
                Container(
                  padding: EdgeInsets.all(40),
                  //   padding: EdgeInsets.only(left:30,right:30,top:30),
                  constraints: BoxConstraints.expand(height: 225),
                  decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          //colors: [lightBlueIsh, svetloPlava3],//lightGreen],
                          colors: Tema.dark
                              ? <Color>[zelena1, crvenaGlavna]
                              : <Color>[
                                  lightGreen,
                                  Color.fromRGBO(255, 112, 87, 1)
                                ],
                          begin: const FractionalOffset(1.0, 1.0),
                          end: const FractionalOffset(0.2, 0.2),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Container(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.rate_review_rounded,
                            color: Tema.dark ? crnaGlavna : plavaTekst,
                            size: 60.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'OCENILI STE ',
                            style: titleStyleWhite,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
              Container(
                color: Tema.dark ? darkPozadina : Colors.grey.shade200,
                child: bulidPositiveMarks(size),
              )
            ]),
          ),
          Container(
            margin: EdgeInsets.only(top: size * 0.07),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: plavaTekst,
                  size: 32.0,
                )),
          )
        ]),
      ),
      backgroundColor: Tema.dark ? darkPozadina : Colors.grey.shade200,
    );
  }

  TextStyle titleStyleWhite = new TextStyle(
      color: Tema.dark ? crnaGlavna : plavaTekst,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
      fontSize: 20);
  Color lightBlueIsh = Color(0xFF33BBB5);
  Color lightGreen = Color(0xFF95E08E);
  Color backgroundColor = Color(0xFFEFEEF5);
  // ignore: non_constant_identifier_names

  Column bulidPositiveMarks(size) {
    var userModel = Provider.of<UserModel>(context, listen: false);
    var marksUserModel = Provider.of<MarksUserModel>(context, listen: false);

    return Column(children: [
      Padding(
          padding: EdgeInsets.only(
              left: size * 0.05, right: size * 0.05, bottom: size * 0.01),
          child: Column(children: [
            FutureBuilder(
                future: marksUserModel.giveMeMyReviews(),
                builder: (context, snapshot) {
                  if (snapshot.data != null)
                    return ListView.builder(
                        shrinkWrap: true, //ovo mora da se postavi da bi radilo
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: size * 0.05,
                                    left: size * 0.05,
                                    right: size * 0.05,
                                    bottom: size * 0.05),
                                decoration: Tema.dark
                                    ? snapshot.data[index][2]
                                        ? StyleZaBoxKomentarDark
                                        : StyleZaBoxKomentarDarkNegative
                                    : snapshot.data[index][2]
                                        ? StyleZaBoxKomentarLight
                                        : StyleZaBoxKomentarLightNegative,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                            snapshot.data[index][2]
                                                ? CupertinoIcons
                                                    .hand_thumbsup_fill
                                                : CupertinoIcons
                                                    .hand_thumbsdown_fill,
                                            color: snapshot.data[index][2]
                                                ? Colors.green[500]
                                                : Colors.red[900]),
                                        SizedBox(width: 10),
                                        FutureBuilder(
                                            future: userModel.GetOwnerUsername(
                                                snapshot.data[index][1]
                                                    .toInt()),
                                            builder: (context, snap) {
                                              if (snap.data != null)
                                                return Text(snap.data,
                                                    style: TextStyle(
                                                      fontFamily: "Monserrat",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: plavaTekst,
                                                      fontSize: 18.0,
                                                    ));
                                              else
                                                return CircularProgressIndicator();
                                            }),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Opis iz oglasa tačan: ",
                                          style: TextStyle(
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[index][3],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                              fontFamily: "Ubuntu"),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Komunikacija protekla dobro: ",
                                          style: TextStyle(
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[index][4],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                              fontFamily: "Ubuntu"),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Ispoštovan dogovor: ",
                                          style: TextStyle(
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[index][5],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                              fontFamily: "Ubuntu"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ));
                  else
                    return CircularProgressIndicator();
                })
          ]))
    ]);
  }
}
