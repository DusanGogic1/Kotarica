import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/ads/MyAds/mainView.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/marks/MyMarksNew.dart';
import 'package:kotarica/web/home/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/util/helper_functions.dart';

class UserInfoWeb extends StatefulWidget {
  //final String username;
  //final String password;
  UserInfoWeb();

  @override
  _State createState() => _State();
}

class _State extends State<UserInfoWeb> {

  // final usernameController = TextEditingController();
  // final passwordController = TextEditingController();

  _State();

  Future<String> _loadData(String dataNeeded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = prefs.getString(dataNeeded);
    return data;
  }

  Future<String> _loadName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String _name = prefs.getString("firstname") + " " + prefs.getString("lastname");
    print(_name);
    return _name;
}

Future<ImageProvider> _loadImage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String image = await ipfsImage(prefs.getString("image"));
  return Image.memory(base64Decode(image)).image;
}
  Brightness getBrightness() {
    return Tema.dark ? Brightness.dark : Brightness.light;
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    return Theme(
      data: ThemeData(
        brightness: getBrightness(),
      ),
      child: Scaffold(
        backgroundColor: Tema.dark ? darkPozadina : Colors.grey.shade200,
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width *0.5,
            child: SingleChildScrollView(
                /* ----- Zelena Pozadina ----- */
                child: Stack(
              children: [
                ClipPath(
                  clipper: MyCustomClipper(),
                  child: Container(
                    height: MediaQuery.of(context).size.height* 0.5,
                    color: zelena1,
                  ),
                ),
                /*---- Slika----*/
                Container(
                  padding: EdgeInsets.all(size * 0.02),
                  margin: EdgeInsets.only(
                      left: size * 0.29, top: size * 0.09, right: size * 0.29),
                  child: Center(
                      child: FutureBuilder(
                        future: _loadImage(),
                        builder: (context, snapshot) {
                          if(snapshot.data != null) {
                            return CircleAvatar(backgroundImage: snapshot.data, radius: size*0.2);
                          }
                          else return CircularProgressIndicator();
                        }
                      )
                    ),

                ),
                SizedBox(height:10),
                /* ----- Ime Korisnika ----- */
                Container(
                  margin: EdgeInsets.only(top:size*0.52),
                  child: Center(
                    child: FutureBuilder(
                      future: _loadName(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return Text(
                            snapshot.data,
                            style: Tema.dark ? StyleTextZaHeaderOglasDark: StyleTextZaHeaderOglasLight,
                          );
                        }
                        else return CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
                /* ---- Like i Dislike----*/
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(size * 0.02),
                      margin: EdgeInsets.only(left: size * 0.33, top: size * 0.59),
                      child: Icon(
                        CupertinoIcons.hand_thumbsup_fill,
                        size: size * 0.1,
                        color: Colors.green[800],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: size * 0.33, top: size * 0.01),
                      child: Text(
                        "212",
                        style: TextStyle(
                          color:  Tema.dark ? bela : siva2,
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(size * 0.02),
                      margin: EdgeInsets.only(left: size * 0.52, top: size * 0.599),
                      child: Icon(
                        CupertinoIcons.hand_thumbsdown_fill,
                        size: size * 0.1,
                        color: Colors.red[600],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: size * 0.53),
                      child: Text(
                        "12",
                        style: TextStyle(
                          color:  Tema.dark ? bela : siva2,
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                        ),
                      ),
                    )
                  ],
                ),
                /*Kolone za informacije*/
                Column(
                  children: [
                    /* --- USER NAME----*/
                    Container(
                      height: size * 0.12,
                      width: size * 0.9,
                      margin: EdgeInsets.only(
                          left: size * 0.06, top: size * 0.85, right: size * 0.06),
                      decoration: StyleZaInformacijeProfila,
                      child: Container(
                        margin: EdgeInsets.only(left: size * 0.04),
                        child: Row(
                          children: [
                            Icon(
                              Icons.text_rotation_none,
                              color: Tema.dark ? svetloZelena: Colors.white  ,
                            ),
                            SizedBox(
                              width: size * 0.02,
                            ),
                            Flexible(
                              child: FutureBuilder(
                                future: _loadData("username"),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                      snapshot.data,
                                      style: Tema.dark ? StyleZaInformacijeTextDark : StyleZaInformacijeTextLight,
                                    );
                                  }
                                  else return CircularProgressIndicator();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    /* ---- EMAIL ----*/
                    Container(
                      height: size * 0.12,
                      width: size * 0.9,
                      margin: EdgeInsets.only(
                          left: size * 0.06, top: size * 0.05, right: size * 0.06),
                      decoration: StyleZaInformacijeProfila,
                      child: Container(
                        margin: EdgeInsets.only(left: size * 0.04),
                        child: Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: Tema.dark ? svetloZelena: Colors.white  ,
                            ),
                            SizedBox(
                              width: size * 0.02,
                            ),
                            Flexible( ////DODATO ZA WRAP TEXT -->DA NE BI DOSLO DO OVERFLOW-A
                              child: FutureBuilder(
                                future: _loadData("email"),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                      snapshot.data,
                                      style: Tema.dark ? StyleZaInformacijeTextDark : StyleZaInformacijeTextLight,
                                    );
                                  }
                                  else return CircularProgressIndicator();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    /* ---- BROJ TELEFONA----*/
                    Container(
                      height: size * 0.12,
                      width: size * 0.9,
                      margin: EdgeInsets.only(
                          left: size * 0.06, top: size * 0.05, right: size * 0.06),
                      decoration: StyleZaInformacijeProfila,
                      child: Container(
                        margin: EdgeInsets.only(left: size * 0.04),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: Tema.dark ? svetloZelena: Colors.white  ,
                            ),
                            SizedBox(
                              width: size * 0.02,
                            ),
                            Flexible(
                              child: FutureBuilder(
                                future: _loadData("phone"),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                      snapshot.data,
                                      style: Tema.dark ? StyleZaInformacijeTextDark : StyleZaInformacijeTextLight,
                                    );
                                  }
                                  else return CircularProgressIndicator();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    /* ---- ADRESA -----*/
                    Container(
                      height: size * 0.12,
                      width: size * 0.9,
                      margin: EdgeInsets.only(
                          left: size * 0.06, top: size * 0.05, right: size * 0.06),
                      decoration: StyleZaInformacijeProfila,
                      child: Container(
                        margin: EdgeInsets.only(left: size * 0.04),
                        child: Row(
                          children: [
                            Icon(
                              Icons.home_sharp,
                              color: Tema.dark ? svetloZelena: Colors.white  ,
                            ),
                            SizedBox(
                              width: size * 0.02,
                            ),
                            FutureBuilder(
                              future: _loadData("personalAddress"),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                    snapshot.data,
                                    style: Tema.dark ? StyleZaInformacijeTextDark : StyleZaInformacijeTextLight,
                                  );
                                }
                                else return CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    /* ----- MESTO ------*/
                    Container(
                      height: size * 0.12,
                      width: size * 0.9,
                      margin: EdgeInsets.only(
                          left: size * 0.06, top: size * 0.05, right: size * 0.06),
                      decoration: StyleZaInformacijeProfila,
                      child: Container(
                        margin: EdgeInsets.only(left: size * 0.04),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.location,
                              color: Tema.dark ? svetloZelena: Colors.white  ,
                            ),
                            SizedBox(
                              width: size * 0.02,
                            ),
                            FutureBuilder(
                              future: _loadData("city"),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                    snapshot.data,
                                    style: Tema.dark ? StyleZaInformacijeTextDark : StyleZaInformacijeTextLight,
                                  );
                                }
                                else return CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    /*----- ZIPCODE-----*/
                    Container(
                      height: size * 0.12,
                      width: size * 0.9,
                      margin: EdgeInsets.only(
                          left: size * 0.06, top: size * 0.05, right: size * 0.06),
                      decoration: StyleZaInformacijeProfila,
                      child: Container(
                        margin: EdgeInsets.only(left: size * 0.04),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              color: Tema.dark ? svetloZelena: Colors.white  ,
                            ),
                            SizedBox(
                              width: size * 0.02,
                            ),
                            FutureBuilder(
                              future: _loadData("zipCode"),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                    snapshot.data,
                                    style: Tema.dark ? StyleZaInformacijeTextDark : StyleZaInformacijeTextLight,
                                  );
                                }
                                else return CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size * 0.1,
                    ),
                  ],
                ),
                /* ------ Dugme  moji oglasi -----*/
                Container(
                  margin:EdgeInsets.only(top:size*1.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: zelena1,
                              onPrimary: Colors.white,
                            ),
                            onPressed: ()  {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OcenePageNew(),
                                ),
                              );
                            },
                            child: Text(
                              "Moje ocene",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Tema.dark ? siva2: Colors.white,
                                fontSize: 15,
                              ),
                            )),
                      ),
                      SizedBox(width: 10,),
                      /* ------ Dugme  moje ocene -----*/
                      Container(
                        child: SizedBox(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: zelena1,
                              ),
                              onPressed: ()  {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => mainView(),
                                  ),
                                );

                              },
                              child: Text(
                                "Moji oglasi",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Tema.dark? siva2: Colors.white,
                                    fontSize: 15),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size * 1,
                ),
                Container(
                  margin: EdgeInsets.only(top: size * 0.07),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreenWeb(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: plavaTekst,
                        size: 32.0,
                      )),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}

//cliper
class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - size.height / 1.5);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
