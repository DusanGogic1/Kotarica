import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/models/MarksUserModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/web/home/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kotarica/constants/style.dart';


double _iconRating = 0;
final _question1Controller = new TextEditingController();
final _question2Controller = new TextEditingController();
final _question3Controller = new TextEditingController();

class RatingPageWeb extends StatefulWidget {
  final int username;
  final int ID;
  //final EthereumAddress address;

  RatingPageWeb({
    @required this.username,
    @required this.ID,
    //@required this.address,
  });

  @override
  _State createState() => _State(username: username, ID: ID);
}

class _State extends State<RatingPageWeb> {
  int username;
  int ID;

  static const String DaNe = '["Da","Ne"]';
  List<dynamic> DaNeLista = json.decode(DaNe);
  List<DropdownMenuItem<String>> _dropDownMenuItemsDaNe;
  String _izabranoMsg1;
  String _izabranoMsg2;
  String _izabranoMsg3;

  //funkcija za DA NE
  //funkcija za Nudim/trazim
  List<DropdownMenuItem<String>> buildDropdownMenuItemsDaNe(
      List<dynamic> DaNeLista) {
    // ignore: deprecated_member_use
    List<DropdownMenuItem<String>> items = List();
    for (String dane in DaNeLista) {
      items.add(
        DropdownMenuItem(
          child: Text(
            dane,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Tema.dark ? bela :crnaGlavna,
              fontSize: 15,
            ),
          ),
          value: dane,
        ),
      );
    }
    return items;
  }
  int ime;
  Future<String> _loadData(String dataNeeded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = prefs.getString(dataNeeded);
    return data;
  }
  Future<void> _GetUsername() async {
    int  username;
    username= await _loadInts("id");
    setState(() => ime = username);
  }

  Future<int> _loadInts(String dataNeeded) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int data = prefs.getInt(dataNeeded);
    return data;
  }

  void initState() {
    _GetUsername();

    //--ZA da//ne
    _dropDownMenuItemsDaNe = buildDropdownMenuItemsDaNe(DaNeLista);
    _izabranoMsg1 = DaNeLista[0];
    _izabranoMsg2 = DaNeLista[0];
    _izabranoMsg3 = DaNeLista[0];
  }

  _State({this.username, this.ID});

  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context, listen: false);
    var marksUserModel = Provider.of<MarksUserModel>(context, listen: false);

    var size = MediaQuery.of(context).size.width;

    // String ime = userModel.currentUsername;

    return Scaffold(
      backgroundColor: Tema.dark ? darkPozadina : bela,
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            color: Tema.dark ? darkPozadina : backgroundColor,
            child: Column(children: <Widget>[
              Stack(children: <Widget>[
                //HEADER!
                Container(
                  padding: EdgeInsets.all(40),
                  constraints: BoxConstraints.expand(height: 190),
                  decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          //colors: [lightBlueIsh, svetloPlava3],//lightGreen],
                          colors:  Tema.dark ? <Color>[
                            zelena1,
                            crvenaGlavna
                          ]
                              :<Color>[
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
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.rate_review_rounded,
                            color: Tema.dark ? siva2 : plavaTekst,
                            size: 60.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'OCENITE OGLAS',
                            style: Tema.dark ? titleStyleDarkk: titleStyleWhite,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
              Container(
                child: bulidContainer(size),
              )
            ]),
          ),
          Container(
            margin: EdgeInsets.only(top: size * 0.07),
            child: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (_) => HomeScreenWeb()), (route) => false);
                  //DA SE IZMENI I DA SE VRACA NA OGLAS
                  //Navigator.push(
                    //context,
                    //MaterialPageRoute(
                      //builder: (context) => HomeScreen(),
                    //),
                  //);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: plavaTekst,
                  size: 32.0,
                )),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: bela,
        ),
        onPressed: () {
          //DA SE DODA POTVRDI
          int like;
          if(_izabranoMsg1 == "Ne" && (_izabranoMsg2 =="Ne" || _izabranoMsg3=="Ne")) {
            like=0;
            // print("dislike");
          }
          else if(_izabranoMsg2=="Ne" && ( _izabranoMsg1 =="Ne" || _izabranoMsg3=="Ne")) {
            like=0;
            // print("dislike");
          }
          else if(_izabranoMsg3=="Ne" && ( _izabranoMsg1 =="Ne" || _izabranoMsg2=="Ne")) {
            like=0;
            // print("dislike");
          }
          else {
            like=1;
          }
          if(like==0) //dislajkujemo
            {
            // print("dislike");
            // print("SALJEM: ");
             print(ime );
             print(username);
            // print( _izabranoMsg1 + _izabranoMsg2 +_izabranoMsg3);
            marksUserModel.addDislike(ime, username, _izabranoMsg1,_izabranoMsg2, _izabranoMsg3);

          }
          else //lajkujemo
            {
            // print("like");
            marksUserModel.addLike(ime, username, _izabranoMsg1,_izabranoMsg2, _izabranoMsg3);
          }
          _FinishRating();

        },
        backgroundColor: crvenaGlavna,
      ),
    );
  }

  TextStyle titleStyleWhitee = new TextStyle(
      color: plavaTekst,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
      fontSize: 20);

  Container bulidContainer(double size) {
    return Container(
      padding: EdgeInsets.only(
          top: size * 0.02, left: size * 0.03, right: size * 0.03),
      child: Container(
        padding: EdgeInsets.all(size * 0.05),
        height: 350,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:Tema.dark ? crvenaGlavna :  Color.fromRGBO(250, 129, 107, 1),

          //  color:  Colors.lightGreen[200]//Color(0xFF95E08E),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 25.0,
            ),
            //prvi red u kontejneru
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ocena: ",
                  style: TextStyle(
                    fontFamily: "Monserrat",
                    fontWeight: FontWeight.bold,
                    color: plavaTekst,
                    fontSize: 18.0,
                  ),
                ),
                GFRating(
                  color: GFColors.DARK,
                  borderColor: GFColors.DARK,
                  filledIcon: Icon(
                    Icons.star,
                    size: GFSize.LARGE,
                    color: GFColors.DANGER,
                  ),
                  size: GFSize.LARGE,
                  value: _iconRating,
                  onChanged: (value) {
                    setState(() {
                      _iconRating = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 25.0,
            ),
            //--PRVO PITANJE--
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "Da li je opis iz oglasa tačan?",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                        color:Tema.dark ? darkPozadina : svetloZelena2,
                        //padding: EdgeInsets.all(2),
                        width: 70,
                        child: Center(
                          child: DropdownButton(
                            dropdownColor: Tema.dark ? crvenaGlavna :svetlaBoja,
                            style: TextStyle(color: Tema.dark ? bela: plavaTekst),
                            value: _izabranoMsg1,
                            items: _dropDownMenuItemsDaNe,
                            onChanged: (newvalue) {
                              setState(() {
                                _izabranoMsg1 = newvalue;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //DRUGO PITANJE
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "Da li je komunikacija protekla dobro?",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                        color:Tema.dark ? darkPozadina : svetloZelena2,
                        //padding: EdgeInsets.all(2),
                        width: 70,
                        child: Center(
                          child: DropdownButton(
                            dropdownColor: svetlaBoja,
                            style: TextStyle(color: plavaGlavna),
                            value: _izabranoMsg2,
                            items: _dropDownMenuItemsDaNe,
                            onChanged: (newvalue) {
                              setState(() {
                                _izabranoMsg2 = newvalue;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //TRECE PITANJE
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "Da li je ispoštovan dogovor?",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                        color:Tema.dark ? darkPozadina : svetloZelena2,
                        //padding: EdgeInsets.all(2),
                        width: 70,
                        child: Center(
                          child: DropdownButton(
                            dropdownColor: svetlaBoja,
                            style: TextStyle(color: plavaGlavna),
                            value: _izabranoMsg3,
                            items: _dropDownMenuItemsDaNe,
                            onChanged: (newvalue) {
                              setState(() {
                                _izabranoMsg3 = newvalue;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  //Funkcija za alert -->Ne poklapaju se sifre
  Future<void> _FinishRating() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Uspesno ste ocenili korisnika',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          // content: ListBody(
          //   children: <Widget>[
          //     Text('Lozinke se ne poklapaju!'),
          //   ],
          // ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: zelena1,
                onPrimary: Colors.white,
              ),
              child: Text(
                'Povratak na glavnu stranu',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

}
