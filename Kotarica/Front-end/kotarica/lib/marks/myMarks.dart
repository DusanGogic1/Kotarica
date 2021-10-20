import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';

/* --- PRIKAZ PROFILA I OCENA DRUGOG KORISNIKA ------ */

class MyMarks extends StatefulWidget {
  final String username;

  MyMarks({
    @required this.username,
  });

  @override
  _State createState() => _State(username: username);
}

class _State extends State<MyMarks> {
  String username;

  _State({this.username});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    bool positive;

    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(children: [
        Container(
          color: backgroundColor,
          child: Column(children: <Widget>[
            Stack(children: <Widget>[
              //HEADER!
              Container(
                padding: EdgeInsets.all(40),
                constraints: BoxConstraints.expand(height: 225),
                decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          lightGreen,
                          Color.fromRGBO(255, 112, 87, 1)
                        ], //lightGreen],
                        //colors: [ plavaGlavna, svetloZelena],//lightGreen],
                        begin: const FractionalOffset(1.0, 1.0),
                        end: const FractionalOffset(0.2, 0.2),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                    child: Center(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.assessment,
                                color: plavaTekst,
                                size: 45.0,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Center(
                              child: Text(
                            username,
                            style: titleStyleWhite,
                          )),
                    SizedBox(height: 10,),
                    /* ------- LOKACIJA ---------*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on_outlined,size: 20,),
                        Text("Kragujevac",
                            style: TextStyle(
                                color: siva2,
                                fontSize: 15,
                                fontFamily: "Montserrat")),
                      ],
                    ),
                          SizedBox(height: 2,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone,size: 20,),
                              Text("06032995647",
                                  style: TextStyle(
                                      color: siva2,
                                      fontSize: 15,
                                      fontFamily: "Montserrat")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ]),
            Container(
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
    ));
  }

  TextStyle titleStyleWhite = new TextStyle(
      color: plavaTekst,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
      fontSize: 20);
  Color lightBlueIsh = Color(0xFF33BBB5);
  Color lightGreen = Color(0xFF95E08E);
  Color backgroundColor = Color(0xFFEFEEF5);
  // ignore: non_constant_identifier_names
  final StyleZaBoxKomentar = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Color.fromRGBO(250, 129, 107,1) //Color.fromRGBO(125, 155, 206,1)//Color(0xFF95E08E),
      );
  // ignore: non_constant_identifier_names

  final StyleZaBoxKomentarPozitivan = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: svetloZelena, //Color.fromRGBO(149, 181, 178,1),
  );

  Column bulidPositiveMarks(size) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
              top: size * 0.02, left: size * 0.03, right: size * 0.03),
          child: Container(
            padding: EdgeInsets.all(size * 0.05),
            decoration: StyleZaBoxKomentarPozitivan,
            child: Column(
              children: [
                //prvi red u kontejneru
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.hand_thumbsup_fill,
                      size: 25,
                      color: Colors.green[500],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Mika Mikic",
                      style: TextStyle(
                        fontFamily: "Monserrat",
                        fontWeight: FontWeight.bold,
                        color: plavaTekst,
                        fontSize: 18.0,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                //KOMUNIKACIJA
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
                      "Da",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontFamily: "Ubuntu"),
                    ),
                  ],
                ),
                //KOMUNIKACIJA
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
                      "Da",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontFamily: "Ubuntu"),
                    ),
                  ],
                ),
                //KOMUNIKACIJA
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
                      "Da",
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
        ),
        /* ---- DRUGI KOMENTAR */
        Container(
          padding: EdgeInsets.only(
              top: size * 0.02, left: size * 0.03, right: size * 0.03),
          child: Container(
            padding: EdgeInsets.all(size * 0.05),
            decoration: StyleZaBoxKomentarPozitivan,
            child: Column(
              children: [
                //prvi red u kontejneru
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.hand_thumbsup_fill,
                      size: 25,
                      color: Colors.green[500],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Mika Mikic",
                      style: TextStyle(
                        fontFamily: "Monserrat",
                        fontWeight: FontWeight.bold,
                        color: plavaTekst,
                        fontSize: 18.0,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                //KOMUNIKACIJA
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
                      "Da",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontFamily: "Ubuntu"),
                    ),
                  ],
                ),
                //KOMUNIKACIJA
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
                      "Da",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontFamily: "Ubuntu"),
                    ),
                  ],
                ),
                //KOMUNIKACIJA
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
                      "Da",
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
        ),
        /* ---- TRECI KOMENTAR */
        Container(
          padding: EdgeInsets.only(
              top: size * 0.02, left: size * 0.03, right: size * 0.03),
          child: Container(
            padding: EdgeInsets.all(size * 0.05),
            decoration: StyleZaBoxKomentarPozitivan,
            child: Column(
              children: [
                //prvi red u kontejneru
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.hand_thumbsup_fill,
                      size: 25,
                      color: Colors.green[500],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Mika Mikic",
                      style: TextStyle(
                        fontFamily: "Monserrat",
                        fontWeight: FontWeight.bold,
                        color: plavaTekst,
                        fontSize: 18.0,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                //KOMUNIKACIJA
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
                      "Da",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontFamily: "Ubuntu"),
                    ),
                  ],
                ),
                //KOMUNIKACIJA
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
                      "Da",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontFamily: "Ubuntu"),
                    ),
                  ],
                ),
                //KOMUNIKACIJA
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
                      "Da",
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
        ),

        /* ---- PETI KOMENTAR */
        Container(
          padding: EdgeInsets.only(
              top: size * 0.02, left: size * 0.03, right: size * 0.03),
          child: Container(
            padding: EdgeInsets.all(size * 0.05),
            decoration: StyleZaBoxKomentarPozitivan,
            child: Column(
              children: [
                //prvi red u kontejneru
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.hand_thumbsup_fill,
                      size: 25,
                      color: Colors.green[500],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Mika Mikic",
                      style: TextStyle(
                        fontFamily: "Monserrat",
                        fontWeight: FontWeight.bold,
                        color: plavaTekst,
                        fontSize: 18.0,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                //KOMUNIKACIJA
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
                      "Da",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontFamily: "Ubuntu"),
                    ),
                  ],
                ),
                //KOMUNIKACIJA
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
                      "Da",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontFamily: "Ubuntu"),
                    ),
                  ],
                ),
                //KOMUNIKACIJA
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
                      "Da",
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
        ),

        /* ---- TRECI KOMENTAR */
        Container(
          padding: EdgeInsets.only(
              top: size * 0.02, left: size * 0.03, right: size * 0.03),
          child: Container(
            padding: EdgeInsets.all(size * 0.05),
            decoration: StyleZaBoxKomentarPozitivan,
            child: Column(
              children: [
                //prvi red u kontejneru
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.hand_thumbsup_fill,
                      size: 25,
                      color: Colors.green[500],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Mika Mikic",
                      style: TextStyle(
                        fontFamily: "Monserrat",
                        fontWeight: FontWeight.bold,
                        color: plavaTekst,
                        fontSize: 18.0,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                //KOMUNIKACIJA
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
                      "Da",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontFamily: "Ubuntu"),
                    ),
                  ],
                ),
                //KOMUNIKACIJA
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
                      "Da",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontFamily: "Ubuntu"),
                    ),
                  ],
                ),
                //KOMUNIKACIJA
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
                      "Da",
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
        ),
      ],
    );
  }
}
