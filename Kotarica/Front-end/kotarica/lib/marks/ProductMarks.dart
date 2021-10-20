import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/models/MarksProductModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:provider/provider.dart';
/* ---- OCENE PROIZVODA ---- */

class ProductMarks extends StatefulWidget {
  final int id;

  ProductMarks( {
    @required this.id,
  });

  @override
  _State createState() => _State(value: id);
}

class _State extends State<ProductMarks> {
  int value;

  _State({this.value});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    bool positive;

    return Scaffold(
        body: SingleChildScrollView(
          child: Stack(children: [
            Container(
              color: Tema.dark? darkPozadina:bela,
              child: Column(children: <Widget>[
                Stack(children: <Widget>[
                  //HEADER!
                  Container(
                    padding: EdgeInsets.all(40),
                    constraints: BoxConstraints.expand(height: 180),
                    decoration: BoxDecoration(
                        gradient: new LinearGradient(
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
                                height: 10,
                              ),
                              Text(
                                'OCENE ZA PROIZVOD:',
                                style: titleOcena,
                              )
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
        ),
    backgroundColor: Tema.dark? darkPozadina:bela,
    );
  }


  TextStyle titleOcena = new TextStyle(
      color: plavaTekst,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
      fontSize: 16);
  Color lightBlueIsh = Color(0xFF33BBB5);
  Color lightGreen = Color(0xFF95E08E);
  Color backgroundColor = Color(0xFFEFEEF5);
  // ignore: non_constant_identifier_names
  final StyleZaBoxKomentar = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Color(0xFF95E08E),
  );
  // ignore: non_constant_identifier_names


  Column bulidPositiveMarks(size) {
    var marksProductModel = Provider.of<MarksProductModel>(context, listen: false);
    var userModel = Provider.of<UserModel>(context, listen: false);
    var marks = marksProductModel.getMarks(widget.id);
    return Column(
        children: [
          Column(
              children: <Widget>[
                FutureBuilder(
                    future: marksProductModel.getMarks(widget.id),
                    builder: (context, snapshot){
                      if(snapshot.data != null) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.last,
                            itemBuilder: (context, index) => Container(
                              child: ListTile(
                                  selectedTileColor: lightGreen,
                                  focusColor: lightGreen,
                                  title: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      color: Tema.dark? lighten(zelenaDark): svetloZelena,
                                      child: Row(
                                        children: [
                                          Container(
                                            child: FutureBuilder(
                                              future: userModel.GetOwnerUsername(snapshot.data[index][0].toInt()),
                                              builder: (context, snap) {
                                                if(snap.data != null)
                                                  return Text(snap.data, style: TextStyle(
                                                    fontFamily: "Monserrat",
                                                    fontWeight: FontWeight.bold,
                                                    color: Tema.dark? bela:plavaTekst,
                                                    fontSize: 18.0,
                                                  ));
                                                else return CircularProgressIndicator();
                                              }
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          //OCENA
                                          GFRating(
                                              color: Tema.dark?GFColors.WARNING:GFColors.ALT,
                                              borderColor: Tema.dark?GFColors.WARNING:GFColors.ALT,
                                              filledIcon: Icon(
                                                Icons.star,
                                                size: GFSize.MEDIUM,
                                                color: Tema.dark?GFColors.WARNING:GFColors.ALT,
                                              ),
                                              value: snapshot.data[index][2].toInt()/10
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                            )
                        );
                      }
                      else return CircularProgressIndicator();
                    }
                )
              ]
          )
        ]
    );
  }
}
