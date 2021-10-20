import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kotarica/ad_rating/rating.dart';

import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/models/BuyingModel.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/models/MarksProductModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:provider/provider.dart';
import 'package:kotarica/product/Product.dart';

class BodyKupljeni extends StatefulWidget {
  const BodyKupljeni({
    Key key,
  }) : super(key: key);
  @override
  _BodyKupljeniState createState() => _BodyKupljeniState();
}

class _BodyKupljeniState extends State<BodyKupljeni> {
  @override
  Widget build(BuildContext context) {
    var image;
    String ime;
    int id;

    void initState() {
      super.initState();
    }

    Future<List> pendingBuyer() async {
      var buyingModel = Provider.of<BuyingModel>(context, listen: false);
      return await buyingModel.getAllPendingBuyer();
    }

    Future<List> confirmedBuyer() async {
      var buyingModel = Provider.of<BuyingModel>(context, listen: false);
      return await buyingModel.getAllConfirmedBuyer();
    }

    Future<List> canceledBuyer() async {
      var buyingModel = Provider.of<BuyingModel>(context, listen: false);
      return await buyingModel.getAllCanceledBuyer();
    }

    Future<Product> getProductById(int id) async {
      var productModel = Provider.of<ProductModel>(context, listen: false);
      print("id proizvoda: " + id.toString());
      return await productModel.getProductById(id);
    }

    var size = MediaQuery.of(context).size.width;
    var size2 = MediaQuery.of(context).size.height;

    return Container(
        color: Tema.dark ? siva : bela,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: DefaultTabController(
                length: 3,
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.15,
                    width: MediaQuery.of(context).size.width,
                    child: Scaffold(
                        body: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 74,
                          child: AppBar(
                            backgroundColor:
                                Tema.dark ? darkPozadina : Colors.grey.shade200,
                            automaticallyImplyLeading: false,
                            bottom: TabBar(
                              indicatorColor: zelena1,
                              tabs: [
                                Tab(
                                    child: Text(
                                  "Na čekanju",
                                  style: TextStyle(color: zelena1),
                                )),
                                Tab(
                                    child: Text(
                                  "Potvrdjene",
                                  style: TextStyle(color: zelena1),
                                )),
                                Tab(
                                    child: Text(
                                  "Otkazane",
                                  style: TextStyle(color: zelena1),
                                )),
                              ],
                            ),
                          ),
                        ),
                        //
                        Expanded(
                            child: TabBarView(
                          children: [
                            //--NA CEKANJU---//
                            Container(
                                child: FutureBuilder(
                                future: pendingBuyer(),
                                builder: (context, snapshot) {
                                  if(snapshot.data != null) {
                                    return GridView.builder(
                                        itemCount: snapshot.data.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2, //BROJ ELEMENATA U VRSTI
                                          mainAxisSpacing: size * 0.03,
                                          crossAxisSpacing: size * 0.03,
                                        ),
                                        itemBuilder: (context, index) =>
                                            GestureDetector(
                                                onTap:(){
                                                  popUpPorudzbinaKupacPending(snapshot.data[index][1].toInt(),
                                                    snapshot.data[index][2].toInt(), snapshot.data[index][5],
                                                      snapshot.data[index][6], snapshot.data[index][3].toInt(),
                                                      snapshot.data[index][4]);
                                                },
                                                child: FutureBuilder(
                                                  future: getProductById(snapshot.data[index][2].toInt()),
                                                  builder: (context, snap) {
                                                    if(snap.data != null) {
                                                      return Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Container(
                                                              margin: EdgeInsets.only(top: size * 0.01),
                                                              //-----PROMENA VELICINE SLIKE--------
                                                              height: size2 * 0.2,
                                                              width: size * 0.65,
                                                              decoration: BoxDecoration(
                                                                color: Tema.dark
                                                                    ? darken(snap.data.color)
                                                                    : snap.data.color,
                                                                borderRadius:
                                                                BorderRadius.circular(14),
                                                              ),
                                                              child: Container(
                                                                child: Hero(
                                                                  tag: "${snap.data.id}",
                                                                  child: ClipRRect(
                                                                    borderRadius:BorderRadius.circular(5),
                                                                    child: FutureBuilder(
                                                                          future: loadIpfsImage(snap.data.images[0]),
                                                                          builder: (context, sna) {
                                                                            if(sna.data == null) return CircularProgressIndicator();
                                                                            else return Image(image: sna.data);
                                                                          }
                                                                        )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            Row(children: [
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(right: size * 0.0),
                                                                    child: Padding(
                                                                      padding: EdgeInsets.only(left: size * 0.01),
                                                                      child: Container(
                                                                        margin: EdgeInsets.only(top: size * 0.0001),
                                                                        child: Text(
                                                                          snap.data.title,
                                                                          style: TextStyle(
                                                                              color: Tema.dark
                                                                                  ? svetloZelena
                                                                                  : crnaGlavna,
                                                                              fontSize: 12,
                                                                              fontFamily:
                                                                              "Montserrat"),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: size * 0.00),
                                                                    child: Text(
                                                                      "${snap.data.priceRsd} RSD",
                                                                      style: TextStyle(
                                                                          color: Tema.dark
                                                                              ? bela
                                                                              : crnaGlavna,
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          fontSize: 12),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]
                                                            )
                                                          ]
                                                      );
                                                    }
                                                    else return CircularProgressIndicator();
                                                  }
                                                )
                                            )
                                    );
                                  }
                                  else return CircularProgressIndicator();
                                }
                              )
                            ),
                            //--POTVRDJENE---//
                            Container(
                                child: FutureBuilder(
                                    future: confirmedBuyer(),
                                    builder: (context, snapshot) {
                                      if(snapshot.data != null) {
                                        return GridView.builder(
                                            itemCount: snapshot.data.length,
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2, //BROJ ELEMENATA U VRSTI
                                              mainAxisSpacing: size * 0.03,
                                              crossAxisSpacing: size * 0.03,
                                            ),
                                            itemBuilder: (context, index) =>
                                                GestureDetector(
                                                    onTap:(){
                                                      popUpPorudzbinaKupacConfirmed(snapshot.data[index][1].toInt(),
                                                          snapshot.data[index][2].toInt(), snapshot.data[index][5],
                                                          snapshot.data[index][6], snapshot.data[index][3].toInt(),
                                                          snapshot.data[index][4]);
                                                    },
                                                    child: FutureBuilder(
                                                        future: getProductById(snapshot.data[index][2].toInt()),
                                                        builder: (context, snap) {
                                                          if(snap.data != null) {
                                                            return Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Container(
                                                                    margin: EdgeInsets.only(top: size * 0.01),
                                                                    //-----PROMENA VELICINE SLIKE--------
                                                                    height: size2 * 0.2,
                                                                    width: size * 0.65,
                                                                    decoration: BoxDecoration(
                                                                      color: Tema.dark
                                                                          ? darken(snap.data.color)
                                                                          : snap.data.color,
                                                                      borderRadius:
                                                                      BorderRadius.circular(14),
                                                                    ),
                                                                    child: Container(
                                                                      child: Hero(
                                                                        tag: "${snap.data.id}",
                                                                        child: ClipRRect(
                                                                            borderRadius:BorderRadius.circular(5),
                                                                            child: FutureBuilder(
                                                                                future: loadIpfsImage(snap.data.images[0]),
                                                                                builder: (context, sna) {
                                                                                  if(sna.data == null) return CircularProgressIndicator();
                                                                                  else return Image(image: sna.data);
                                                                                }
                                                                            )
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(children: [
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsets.only(right: size * 0.0),
                                                                          child: Padding(
                                                                            padding: EdgeInsets.only(left: size * 0.01),
                                                                            child: Container(
                                                                              margin: EdgeInsets.only(top: size * 0.0001),
                                                                              child: Text(
                                                                                snap.data.title,
                                                                                style: TextStyle(
                                                                                    color: Tema.dark
                                                                                        ? svetloZelena
                                                                                        : crnaGlavna,
                                                                                    fontSize: 12,
                                                                                    fontFamily:
                                                                                    "Montserrat"),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin: EdgeInsets.only(
                                                                              top: size * 0.00),
                                                                          child: Text(
                                                                            "${snap.data.priceRsd} RSD",
                                                                            style: TextStyle(
                                                                                color: Tema.dark
                                                                                    ? bela
                                                                                    : crnaGlavna,
                                                                                fontWeight:
                                                                                FontWeight.bold,
                                                                                fontSize: 12),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ]
                                                                  )
                                                                ]
                                                            );
                                                          }
                                                          else return CircularProgressIndicator();
                                                        }
                                                    )
                                                )
                                        );
                                      }
                                      else return CircularProgressIndicator();
                                    }
                                )
                            ),
                            //--OTKAZANE---//
                            Container(
                                child: FutureBuilder(
                                    future: canceledBuyer(),
                                    builder: (context, snapshot) {
                                      if(snapshot.data != null) {
                                        return GridView.builder(
                                            itemCount: snapshot.data.length,
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2, //BROJ ELEMENATA U VRSTI
                                              mainAxisSpacing: size * 0.03,
                                              crossAxisSpacing: size * 0.03,
                                            ),
                                            itemBuilder: (context, index) =>
                                                GestureDetector(
                                                    onTap:(){
                                                      popUpPorudzbinaKupacCanceled(snapshot.data[index][1].toInt(),
                                                          snapshot.data[index][2].toInt(), snapshot.data[index][5],
                                                          snapshot.data[index][6], snapshot.data[index][3].toInt(),
                                                          snapshot.data[index][4]);
                                                    },
                                                    child: FutureBuilder(
                                                        future: getProductById(snapshot.data[index][2].toInt()),
                                                        builder: (context, snap) {
                                                          if(snap.data != null) {
                                                            return Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Container(
                                                                    margin: EdgeInsets.only(top: size * 0.01),
                                                                    //-----PROMENA VELICINE SLIKE--------
                                                                    height: size2 * 0.2,
                                                                    width: size * 0.65,
                                                                    decoration: BoxDecoration(
                                                                      color: Tema.dark
                                                                          ? darken(snap.data.color)
                                                                          : snap.data.color,
                                                                      borderRadius:
                                                                      BorderRadius.circular(14),
                                                                    ),
                                                                    child: Container(
                                                                      child: Hero(
                                                                        tag:
                                                                        "${snap.data.id}",
                                                                        child: ClipRRect(
                                                                            borderRadius:BorderRadius.circular(5),
                                                                            child: FutureBuilder(
                                                                                future: loadIpfsImage(snap.data.images[0]),
                                                                                builder: (context, sna) {
                                                                                  if(sna.data == null) return CircularProgressIndicator();
                                                                                  else return Image(image: sna.data);
                                                                                }
                                                                            )
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(children: [
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsets.only(right: size * 0.0),
                                                                          child: Padding(
                                                                            padding: EdgeInsets.only(left: size * 0.01),
                                                                            child: Container(
                                                                              margin: EdgeInsets.only(top: size * 0.0001),
                                                                              child: Text(
                                                                                snap.data.title,
                                                                                style: TextStyle(
                                                                                    color: Tema.dark
                                                                                        ? svetloZelena
                                                                                        : crnaGlavna,
                                                                                    fontSize: 12,
                                                                                    fontFamily:
                                                                                    "Montserrat"),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin: EdgeInsets.only(
                                                                              top: size * 0.00),
                                                                          child: Text(
                                                                            "${snap.data.priceRsd} RSD",
                                                                            style: TextStyle(
                                                                                color: Tema.dark
                                                                                    ? bela
                                                                                    : crnaGlavna,
                                                                                fontWeight:
                                                                                FontWeight.bold,
                                                                                fontSize: 12),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ]
                                                                  )
                                                                ]
                                                            );
                                                          }
                                                          else return CircularProgressIndicator();
                                                        }
                                                    )
                                                )
                                        );
                                      }
                                      else return CircularProgressIndicator();
                                    }
                                )
                            ),
                            ],
                          )
                        )
                      ],
                    )
                  ),
                ),
            )
        )
      )
    );
  }

  Future<ImageProvider> _loadImage(String thumbnail) async {
    print("hash: " + thumbnail);
    String image = await ipfsImage(thumbnail);
    return Image.memory(base64Decode(image)).image;
  }

  Future<void> popUpPorudzbinaKupacPending(int userId, int productId, String address, String phone, int amount, String unit) {

    setState((){});

    Future<Product> getProductById() async {
      var productModel = Provider.of<ProductModel>(context, listen: false);
      return await productModel.getProductById(productId);
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: getUserName(userId),
          builder: (context, snapshot) {
            if(snapshot.data != null)
              return FutureBuilder(
                future: getProductById(),
                builder: (context, snap) {
                  if(snap.data != null)
                    return AlertDialog(
                        title: Text(
                          'Na čekanju ',
                          style: TextStyle(
                            color: zelena1,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Row(
                                children: [
                                  Flexible(
                                      child: Text('Prodavac: ' +  snapshot.data)),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      child: Text('Oglas: ' + snap.data.title)),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      child: Text('Adresa dostave: ' + address)),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      child: Text('Vaš broj telefona: ' + phone)),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      child:  Text('Količina: ' + amount.toString() + unit)),
                                ],
                              ),
                            ],
                          ),
                        )
                    );
                  else return CircularProgressIndicator();
                }
              );
            else return CircularProgressIndicator();
          }
        );
          }
        );
  }

  Future<void> popUpPorudzbinaKupacConfirmed(int userId, int productId, String address, String phone, int amount, String unit) {

    setState((){});
    Future<bool> isItRatable(int productId) async {

      var buyingModel = Provider.of<BuyingModel>(context, listen: false);
      var productMarksModel = Provider.of<MarksProductModel>(context, listen: false);
      var numOfBought = await buyingModel.numberOfConfirmed(productId);
      var numOfRated = await productMarksModel.numberOfMarksPerUser(productId);
      return numOfBought > numOfRated;
    }

    Future<Product> getProductById() async {
      var productModel = Provider.of<ProductModel>(context, listen: false);
      return await productModel.getProductById(productId);
    }

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return FutureBuilder(
              future: getUserName(userId),
              builder: (context, snapshot) {
                if(snapshot.data != null)
                  return FutureBuilder(
                    future: getProductById(),
                    builder: (context, snap) {
                      if(snap.data != null)
                        return AlertDialog(
                          title: Text(
                            'Potvrdjeno ',
                            style: TextStyle(
                              color: zelena1,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text('Prodavac: ' +  snapshot.data)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child:  Text('Oglas: ' + snap.data.title)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text('Adresa dostave: ' + address)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text('Vaš broj telefona: ' + phone)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Količina: ' + amount.toString() + unit),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        actions: <Widget>[
                          FutureBuilder(
                              future: isItRatable(productId),
                              builder: (context, snapshot) {
                                if(snapshot.data == true)
                                {
                                  return
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: zelena1,
                                        onPrimary: Colors.white,
                                      ),
                                      child: Text(
                                        'Oceni ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: ()  {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) => RatingPage(
                                                    username: userId,
                                                    ID: productId)
                                            )
                                        );
                                      },
                                    );
                                }
                                else return Container(width: 0, height: 0,);
                              }
                          )
                        ],
                      ); else return CircularProgressIndicator();
                    }
                  );else return CircularProgressIndicator();
              }
          );
        }
    );
  }

  Future<void> popUpPorudzbinaKupacCanceled(int userId, int productId, String address, String phone, int amount, String unit) {
    setState((){});

    Future<Product> getProductById() async {
      var productModel = Provider.of<ProductModel>(context, listen: false);
      return await productModel.getProductById(productId);
    }

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return FutureBuilder(
              future: getUserName(userId),
              builder: (context, snapshot) {
                if(snapshot.data != null)
                  return FutureBuilder(
                    future: getProductById(),
                    builder: (context, snap) {
                      if(snap.data != null)
                        return AlertDialog(
                          title: Text(
                            'Otkazano ',
                            style: TextStyle(
                              color: zelena1,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Flexible(
                                        child: Text('Prodavac: ' +  snapshot.data)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        child: Text('Oglas: ' + snap.data.title)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        child: Text('Adresa dostave: ' + address)),
                                  ],
                                ),  Row(
                                  children: [
                                    Flexible(
                                        child:  Text('Vaš broj telefona: ' + phone)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        child: Text('Količina: ' + amount.toString() + unit)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      else return CircularProgressIndicator();
                    }
                  );
                else return CircularProgressIndicator();
              }
          );
        }
    );
  }

  Future<String> getUserName(int userId) async {
    var userModel = Provider.of<UserModel>(context, listen: false);

    return userModel.getFirstnameLastname(userId);
  }



}
