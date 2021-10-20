import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/chat/ChatDetailPage.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/models/MarksUserModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* --- PRIKAZ PROFILA I OCENA DRUGOG KORISNIKA ------ */


Future<ImageProvider> _loadImage(String thumbnail) async {
  String image = await ipfsImage(thumbnail);
  return Image.memory(base64Decode(image)).image;
}

class OwnerAdsMarks extends StatefulWidget {
  final String username;
  final int userId;
  final int productId;

  OwnerAdsMarks({
    @required this.username,
    @required this.userId,
    @required this.productId,
  });

  @override
  _State createState() => _State(username: username, userId: userId);
}

class _State extends State<OwnerAdsMarks> {
  String username;
  int userId;

  _State({this.username, this.userId});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var userModel = Provider.of<UserModel>(context, listen: false);

    bool positive;

    Future<String> _getFirstnameLastname(int otherId) async {
      String _otherUsername = await Provider.of<UserModel>(context, listen: false).getFirstnameLastname(otherId);
      return _otherUsername;
    }

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
                    constraints: BoxConstraints.expand(height: 336),
                    decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors:  Tema.dark ? <Color>[
                              zelena1,
                              crvenaGlavna
                            ]
                                :<Color>[
                              lightGreen,
                              Color.fromRGBO(255, 112, 87, 1)
                            ],//lightGreen],
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
                              Container(
                                height:110,
                                width: 120,
                                child: Center(
                                    child: FutureBuilder(
                                        future: userModel.GetImageOwner(username),
                                        builder: (context, snapshot) {
                                          if(snapshot.data != null) {
                                            return CircleAvatar(backgroundImage: snapshot.data, radius: size*0.2);
                                          }
                                          else return CircularProgressIndicator();
                                        }
                                    )
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Center(
                                child:  FutureBuilder(
                                  future: userModel.GetFullNameOwner(username),
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      return Text(snapshot.data,
                                        style: (TextStyle(height: 1.5, color: Tema.dark?bela:plavaTekst, fontSize: 18)),
                                      );
                                    } else return Text("");
                                  },
                                ),
                              ),
                              SizedBox(height: 5,),
                              /* ------- LOKACIJA ---------*/
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_on_outlined,size: 20,color: Tema.dark?bela:plavaTekst),
                                  FutureBuilder(
                                    future: userModel.GetCityOwner(
                                        username),
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null) {
                                        return Text(
                                          snapshot.data,
                                          style: (TextStyle(height: 1.5,color: Tema.dark?bela:plavaTekst, fontSize: 18)),
                                        );
                                      } else
                                        return Text("");
                                    },
                                  ),
                                ],
                              ),
                              //broj
                              SizedBox(height: 2,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.phone,size: 20,color: Tema.dark?bela:plavaTekst),
                                  FutureBuilder(
                                    future: userModel.GetNumberOwner(
                                        username),
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null) {
                                        return Text(
                                          snapshot.data,
                                          style: (TextStyle(height: 1.5, color: Tema.dark?bela:plavaTekst,fontSize: 18)),
                                        );
                                      } else
                                        return Text("");
                                    },
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Tema.dark?svetloZelena:zelena1,
                                    onPrimary: Colors.white,
                                  ),
                                  child: Text(
                                    'Pošalji poruku',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () async {
                                    String _otherUsername = await _getFirstnameLastname(widget.userId);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailPage(widget.productId, widget.userId, _otherUsername)));
                                  }
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: bulidPositiveMarks(size),
                  ),
                    ],
                  ),
                ])),

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
    Future<List> _loadLikes() async {
      var userMarksModel = Provider.of<MarksUserModel>(context, listen: false);

      return userMarksModel.dajLajkove(widget.userId);
    }

    Future<List> _loadDislikes() async {
      var userMarksModel = Provider.of<MarksUserModel>(context, listen: false);

      return userMarksModel.dajDislajkove(widget.userId);
    }

    Future<List> merge() async {
      List likes = await _loadLikes();
      List dislikes = await _loadDislikes();

      List merged = likes;
      //print("PRE");
      //print(merged);
      for(int i=0; i < dislikes.length; i++)
      {
          merged.add(dislikes[i]);
      }
      merged = merged.reversed.toList();
      print(merged);
      //merged.removeAt(0);
      //merged.removeAt(0);
      //print("#######################");
      print(merged);
      return merged;
    }

    var userModel = Provider.of<UserModel>(context, listen: false);
    return Column(
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: FutureBuilder(
                future: merge(),
                builder: (context, snapshot){
                  if(snapshot.data != null)
                  {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Container(
                          padding: EdgeInsets.all(size * 0.05),
                          decoration: StyleZaBoxKomentarPozitivan,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(children: [
                                Icon(snapshot.data[index][2]?CupertinoIcons.hand_thumbsup_fill:CupertinoIcons.hand_thumbsdown_fill,
                                    color: snapshot.data[index][2]?Colors.green[500]:Colors.red[500]),
                                SizedBox(width: 10),
                                FutureBuilder(future: userModel.GetOwnerUsername(snapshot.data[index][1].toInt()),
                                  builder: (context, snap) {
                                    if(snap.data != null)
                                      return Text(snap.data ,
                                        style: TextStyle(
                                        fontFamily: "Monserrat",
                                        fontWeight: FontWeight.bold,
                                        color: plavaTekst,
                                        fontSize: 18.0,
                                      )
                                    );
                                    else return CircularProgressIndicator();
                                    }
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0,),
                              Row(children: [
                                Text("Opis iz oglasa tačan: ",
                                  style: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    ),
                                  ),
                                Text(snapshot.data[index][3],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    fontFamily: "Ubuntu"),
                                  ),
                                ],
                              ),
                              Row(children: [
                                Text("Komunikacija protekla dobro: ",
                                  style: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    ),
                                  ),
                                Text(snapshot.data[index][4],
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    fontFamily: "Ubuntu"),
                                  ),
                                ],
                              ),
                              Row(children: [
                                Text("Ispoštovan dogovor: ",
                                  style: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(snapshot.data[index][5],
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  fontFamily: "Ubuntu"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                       )
                      )
                    );
                  }
                  else return CircularProgressIndicator();
                }
              ),
            )
          ]
        )
      ],
    );
  }
}
