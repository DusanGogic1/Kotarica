import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/web/WebModels/MarksProductModelWeb.dart';
import 'package:kotarica/web/WebModels/MarksUserModelWeb.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


//final _ratingController = TextEditingController();
//double _userRating = 4.5;
double _iconRating = 0;

//Koristi se za opis koji se nalazi u oglasu

class DescriptionWeb extends StatefulWidget {
  const DescriptionWeb({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<DescriptionWeb> {
  String ime;

  String Ucitanoime;
  Future<String> _loadData(String dataNeeded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = prefs.getString(dataNeeded);
    return data;
  }

  Future<void> _GetUsername() async {
    String username;
    username = await _loadData("username");
    setState(() => ime = username);
  }

  void initState() {
    super.initState();
    _GetUsername();
  }

  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModelWeb>(context, listen: false);
    var marksProductModel = Provider.of<MarksProductModelWeb>(context, listen: false);
    //print(marksProductModel.privateKey);
    var size = MediaQuery.of(context).size.width;
    return Column(
      children: [
        //padding
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.product.category+">"+ widget.product.subcategory,
                style:TextStyle(color:crvenaGlavna,
                    fontSize: 13)),
          ],
        ),
        SizedBox(height: size*0.009,),
        widget.product.type == "Nudim"?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
                future: marksProductModel.getMean(widget.product.id),
                builder: (context, snapshot) {
                  if(snapshot.data != null) {
                    if(snapshot.data != -1)
                      return Text(
                        snapshot.data.toStringAsFixed(2),
                        style: TextStyle(fontSize: 20, color: Tema.dark ? bela : crnaGlavna,  //DONJI DEO
                        ),
                      );
                    else return SizedBox();
                  }
                  else return CircularProgressIndicator();
                }
            ),

            Row(
              children: [
                FutureBuilder(
                    future: marksProductModel.getMean(widget.product.id),
                    builder: (context, snapshot) {
                      if(snapshot.data != null) {
                        if(snapshot.data != -1)
                          return RatingBar.builder(
                              unratedColor: Tema.dark ? bela : siva2,  //DONJI DEO,
                              itemSize: size*0.04,
                              initialRating: snapshot.data,
                              minRating: snapshot.data,
                              maxRating: snapshot.data,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              )
                          );
                        else return Text("Proizvod trenutno nema ocena");
                      }
                      else return CircularProgressIndicator();
                    }
                )
              ],
            ),
            SizedBox(width: 5),
          ],
        ):Container(),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: size * 0.01),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: ExpansionTile(
                    childrenPadding: EdgeInsets.all(10),
                    backgroundColor: Tema.dark? darken(widget.product.color,.3):(widget.product.color),
                    collapsedBackgroundColor:Tema.dark?darken(widget.product.color,.3): lighten(widget.product.color),
                    title: Text("Opis oglasa",
                        style: TextStyle( color: Tema.dark ? Colors.grey[100] : bela, fontSize: 16)),
                    children: [
                      Text(
                        widget.product.about,
                        style: TextStyle(height: 1.5, color: bela),
                      ),
                    ]),
              ),
              SizedBox(
                height: 5,
              ),

              SizedBox(
                height: 5,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: ExpansionTile(
                    childrenPadding: EdgeInsets.all(10),
                    backgroundColor: Tema.dark? darken(widget.product.color,.3):(widget.product.color),
                    collapsedBackgroundColor: Tema.dark? darken(widget.product.color,.3): lighten(widget.product.color),
                    title: Text("Informacije o prodavcu",
                        style: TextStyle( color: Tema.dark ? Colors.grey[100] : bela, fontSize: 16)),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              CupertinoIcons.profile_circled,
                              color: Tema.dark ? bela : bela
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          FutureBuilder(
                            future: userModel.GetFullNameOwner(
                                widget.product.ownerUsername),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                Ucitanoime = snapshot.data;
                                return Text(
                                  snapshot.data,
                                  style: (TextStyle(height: 1.5,  color: Tema.dark ? Colors.grey[100] : bela)),
                                );
                              } else
                                return Text("Nema");
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.location,
                            color: Tema.dark ? bela : bela,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          FutureBuilder(
                            future: userModel.GetCityOwner(
                                widget.product.ownerUsername),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Text(
                                  snapshot.data,
                                  style: (TextStyle(height: 1.5,  color: Tema.dark ? Colors.grey[100] : bela)),
                                );
                              } else
                                return Text("Nema");
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.phone,
                            color: Tema.dark ? Colors.grey[100] : bela,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          FutureBuilder(
                            future: userModel.GetNumberOwner(
                                widget.product.ownerUsername),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Text(
                                  snapshot.data,
                                  style: (TextStyle(height: 1.5,  color: Tema.dark ? Colors.grey[100] : bela)),
                                );
                              } else
                                return Text("Nema");
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      FlatButton(
                        height: 30,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        color:  Tema.dark ? siva : svetlaBoja,
                        onPressed: () {
                          prikaziProfil(widget.product.ownerUsername,widget.product.ownerId);

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => OwnerAdsMarks(
                          //             userId: widget.product.ownerId,
                          //             username: widget.product.ownerUsername
                          //         ) //(username:  widget.product.ownerUsername),
                          //     ));
                          // ProductMarks
                        },
                        child: Text(
                          "Pogledaj profil prodavca".toUpperCase(),
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Tema.dark?darken(widget.product.color,.1):widget.product.color,
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Future<void> prikaziProfil( String username,int userId) async {
    var productModel = Provider.of<ProductModelWeb>(context, listen: false);
    var size = MediaQuery.of(context).size.width;
    var userModel = Provider.of<UserModelWeb>(context, listen: false);

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              content:SingleChildScrollView(
                child: Stack(children: [
                  Column(
                      children: <Widget>[
                    Container(
                     // padding: EdgeInsets.all(40),
                     // constraints: BoxConstraints.expand(height: 300),
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
                     //   padding: EdgeInsets.only(top: 10),
                        child: Container(
                          width: 300,
                          child: Center(
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height:160,
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      width:200,
                      // final String username;
                      //   final int userId;
                      child: bulidPositiveMarks(size,username,userId),
                    )
                  ]),
                  Container(
                    margin: EdgeInsets.only(top: size * 0.002),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);

                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: plavaTekst,
                          size: 32.0,
                        )),
                  )
                ]),
              )
          );
        });
  }
  final StyleZaBoxKomentar = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Color.fromRGBO(250, 129, 107,1) //Color.fromRGBO(125, 155, 206,1)//Color(0xFF95E08E),
  );
// ignore: non_constant_identifier_names

  final StyleZaBoxKomentarPozitivan = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: svetloZelena, //Color.fromRGBO(149, 181, 178,1),
  );

  Column bulidPositiveMarks(size, final String username,int userId) {
    Future<List> _loadLikes() async {
      var userMarksModel = Provider.of<MarksUserModelWeb>(context, listen: false);

      return userMarksModel.dajLajkove(userId);
    }

    Future<List> _loadDislikes() async {
      var userMarksModel = Provider.of<MarksUserModelWeb>(context, listen: false);

      return userMarksModel.dajDislajkove(userId);
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


    var userModel = Provider.of<UserModelWeb>(context, listen: false);
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
