import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';
import 'package:kotarica/constants/strings.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/marks/Ocena.dart';
import 'package:kotarica/notification/NotificationClasses.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/util/Validators.dart';
import 'package:kotarica/util/form/UtilTextFormField.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:kotarica/web/WebModels/BuyingModelWeb.dart';
import 'package:kotarica/web/WebModels/MarksProductModelWeb.dart';
import 'package:kotarica/web/WebModels/MarksUserModelWeb.dart';
import 'package:kotarica/models/NotificationsModel.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:kotarica/web/ads/MyAds/mainViewWeb.dart';
import 'package:kotarica/web/ads/SavedAds/savedAdsPage.dart';
import 'package:kotarica/web/chat/ChatMain.dart';
import 'package:kotarica/web/home/HomeScreen.dart';
import 'package:kotarica/web/notification/notificationPage.dart';
import 'package:kotarica/web/registration/Welcome.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NavBarItem.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

List<bool> selected = [
  true,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];

class _NavBarState extends State<NavBar> {

  void select(int n) {
    for (int i = 0; i < 9; i++) {
      if (i != n) {
        selected[i] = false;
      } else {
        selected[i] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var Sheight = MediaQuery.of(context).size.height;
    var Swidth = MediaQuery.of(context).size.width;
    return Container(
      height: 650.0,
      width: Swidth * 1.4,
      child: Column(
        children:[
            SizedBox(height:5),
          NavBarItem(
            name: "Početna",
            icon: Feather.home,
            active: selected[0],
            touched: () {
              setState(() {
                if (selected[0] != true) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreenWeb()));
                  select(0);
                }
              });
            },
          ),
          NavBarItem(
            name: "Moj profil",
            icon: Icons.person,
            active: selected[1],
            touched: () {
              setState(() {
                _mojProfil();
              });
            },
          ),
          NavBarItem(
            name: "Moji oglasi",
            icon: Icons.assignment_rounded,
            active: selected[2],
            touched: () {
              setState(() {
                if (selected[2] != true) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => mainViewWeb()));
                  select(2);
                }
              });
            },
          ),

          //dodata 2
          NavBarItem(
            name: "Kupljeno",
            icon: Icons.add_shopping_cart_outlined,
            active: selected[3],
            touched: () {
              setState(() {
                //select(3);
                kupljeno();
                //_mojeOcene2();
              });
            },
          ),
          NavBarItem(
            name: "Prodato",
            icon: Icons.shopping_cart_rounded,
            active: selected[3],
            touched: () {
              setState(() {
                //select(3);
                prodato();

               // _mojeOcene2();
              });
            },
          ),
          NavBarItem(
            name: "Ocenili ste",
            icon: Icons.assignment,
            active: selected[4],
            touched: () {
              setState(() {
                //select(4);
                _oceniliSte2();
              });
            },
          ),
          NavBarItem(
            name: "Moje ocene",
            icon: Icons.assessment,
            active: selected[4],
            touched: () {
              setState(() {
                //select(4);
                _mojeOcene2();
              });
            },
          ),
          NavBarItem(
            name: "Poruke",
            icon: Icons.message,
            active: selected[5],
            touched: () {
              setState(() {
                if (selected[5] != true) {
                  //Navigator.push(context,
                  // MaterialPageRoute(builder: (context) => ChatRoom()));
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => MainPageChatWeb()),
                      (route) => false);
                  select(5);
                }
              });
            },
          ),
          NavBarItem(
            name: "Obaveštenja",
            icon: Icons.notifications_active_rounded,
            active: selected[6],
            touched: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => NotificationPageWeb()));
                showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Container(
                        child: AlertDialog(
                          backgroundColor: bela,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          title: Center(
                            child: Text(
                              'OBAVEŠTENJA ',
                              style: TextStyle(
                                fontSize: 25.0,
                                color: crnaGlavna,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: NotificationPageWeb(),
                          actions: <Widget>[
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              color: zelena1,
                              onPressed: () {
                                Navigator.of(context).pop();

                              },
                              child: Text(
                                "Nazad".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: bela,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });



            },
          ),
          NavBarItem(
            name: "Lista želja",
            icon: Icons.bookmark,
            active: selected[7],
            touched: () {
              setState(() {
                if (selected[7] != true) {
                  //Navigator.pushAndRemoveUntil(context,
                  //MaterialPageRoute(builder: (_) => SavedAdsPageWeb()), (route) => false);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SavedAdsPageWeb()));
                  select(7);
                }
              });
            },
          ),
          NavBarItem(
            name: "Podešavanja",
            icon: Feather.settings,
            active: selected[8],
            touched: () {
              setState(() {
                //select(8);
                _podesavanja2();
              });
            },
          ),
        ],
      ),
    );
  }

//lukina stara funkcija
  Future<void> _Notifikacije() async {
    var size = MediaQuery.of(context).size.width;
    var notificationsModel =
        Provider.of<NotificationsModel>(context, listen: false);
    var notificationsStream = notificationsModel.notificationsStream;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            backgroundColor: bela,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Center(
              child: Text(
                'OBAVEŠTENJA ',
                style: TextStyle(
                  fontSize: 25.0,
                  color: crnaGlavna,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Container(
              width: size * 0.45,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: ListBody(
                  children: <Widget>[
                    //=======LIKE I DISLIKE===========
                    Container(
                      height: 300, // MediaQuery.of(context).size.height,
                      width: 300, //MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Container(
                              width: size * 0.65,
                              margin: EdgeInsets.only(left: size * 0.025),
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size * 0.04),
                                    /*GRID SE KORISTI ZA OBAVESTENJA*/
                                    child: StreamBuilder(
                                        stream: notificationsStream,
                                        builder: (context,
                                            AsyncSnapshot<
                                                    List<NotificationBase>>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            var list = snapshot.data;
                                            list.sort((a, b) {
                                              int cmpBlockNum = a.blockNum
                                                  .compareTo(b.blockNum);
                                              if (cmpBlockNum == 0) {
                                                return a.logIndex
                                                    .compareTo(b.logIndex);
                                              }
                                              return cmpBlockNum;
                                            });
                                            return Align(
                                              alignment: Alignment.topCenter,
                                              child: GridView.builder(
                                                physics: ScrollPhysics(),
                                                shrinkWrap: true,
                                                //BROJ OBAVESTENJA ZA PRIKAZIVANJE
                                                itemCount: list.length + 2,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisSpacing: 1,
                                                  mainAxisSpacing: 1,
                                                  crossAxisCount: 1,
                                                  childAspectRatio:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              9),
                                                ),
                                                reverse: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  if (index == 1) {
                                                    return TextButton(
                                                      onPressed: () async {
                                                        await notificationsModel
                                                            .likesContract
                                                            .sendTransaction(
                                                          function:
                                                              notificationsModel
                                                                  .likesContract
                                                                  .function(
                                                                      "addLike"),
                                                          params: [
                                                            (await SharedPreferences
                                                                    .getInstance())
                                                                .getString(
                                                                    "username"),
                                                            "bbbb",
                                                            "Da",
                                                            "Da",
                                                            "Da"
                                                          ],
                                                        );
                                                        print("bruh");
                                                      },
                                                      child: Text(
                                                          "Like user 'bbbb'"),
                                                    );
                                                  } else if (index == 0) {
                                                    return TextButton(
                                                      onPressed: () async {
                                                        await notificationsModel
                                                            .likesContract
                                                            .sendTransaction(
                                                          function:
                                                              notificationsModel
                                                                  .likesContract
                                                                  .function(
                                                                      "addDislike"),
                                                          params: [
                                                            (await SharedPreferences
                                                                    .getInstance())
                                                                .getString(
                                                                    "username"),
                                                            "bbbb",
                                                            "Da",
                                                            "Da",
                                                            "Da"
                                                          ],
                                                        );
                                                        print("bruh");
                                                      },
                                                      child: Text(
                                                          "Dislike user 'bbbb'"),
                                                    );
                                                  }
                                                  return list[index - 2]
                                                      .getWidget(context, size);
                                                },
                                              ),
                                            );
                                          } else {
                                            return Center(
                                                child: Text(
                                                    "Trenutno nemate obaveštenja.",
                                                    style: TextStyle(
                                                        color: Tema.dark
                                                            ? bela
                                                            : crnaGlavna)));
                                          }
                                        }),
                                  )),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: zelena1,
                onPressed: () {
                  Navigator.of(context).pop();

                },
                child: Text(
                  "Nazad".toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: bela,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> _loadData(String dataNeeded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = prefs.getString(dataNeeded);
    return data;
  }

  Future<String> _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String _name =
        prefs.getString("firstname") + " " + prefs.getString("lastname");
    print(_name);
    return _name;
  }

  Future<void> _mojProfil() async {
    var size = MediaQuery.of(context).size.width;
    var buyingModel = Provider.of<BuyingModelWeb>(context, listen: false);
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            backgroundColor: Tema.dark?darkPozadina:bela,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Center(
              child: Text(
                'MOJ PROFIL',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Tema.dark?bela:crnaGlavna,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  sharedPrefsWidgetBuilder(builder: (context, prefs) {
                    var imageHash = prefs.getString("image");

                    return Center(
                      child: Container(
                        width: 160,
                        height: 160,
                        child: ipfsImageWidgetBuilder(
                          imageHash: imageHash,
                          builder: (context, imageProvider) => CircleAvatar(
                            backgroundImage: imageProvider,
                          ),
                          loadingBuilder: (context, snapshot) =>
                              CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.account_circle_outlined,color: Tema.dark?bela:crnaGlavna),
                          SizedBox(width: 3),
                          Text(
                            "Ime i prezime ",
                            style: TextStyle(
                                color: Tema.dark?bela:crnaGlavna,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: size * 0.032),
                        width: size * 0.2,
                        height: size * 0.02,
                        decoration: BoxDecoration(
                          color: zelena1,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: FutureBuilder(
                                future: _loadName(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                      snapshot.data,
                                      style: Tema.dark
                                          ? StyleZaInformacijeTextDark
                                          : StyleZaInformacijeTextLight,
                                    );
                                  } else
                                    return CircularProgressIndicator();
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.mail_outline_outlined,color: Tema.dark?bela:crnaGlavna),
                          SizedBox(width: 3),
                          Text(
                            "E-mail ",
                            style: TextStyle(
                                color: Tema.dark?bela:crnaGlavna,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: size * 0.032),
                        width: size * 0.2,
                        height: size * 0.02,
                        decoration: BoxDecoration(
                          color: zelena1,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              ////DODATO ZA WRAP TEXT -->DA NE BI DOSLO DO OVERFLOW-A
                              child: FutureBuilder(
                                future: _loadData("email"),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                      snapshot.data,
                                      style: Tema.dark
                                          ? StyleZaInformacijeTextDark
                                          : StyleZaInformacijeTextLight,
                                    );
                                  } else
                                    return CircularProgressIndicator();
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.phone,color: Tema.dark?bela:crnaGlavna),
                          SizedBox(width: 3),
                          Text(
                            "Broj telefona ",
                            style: TextStyle(
                                color: Tema.dark?bela:crnaGlavna,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: size * 0.007),
                        width: size * 0.2,
                        height: size * 0.02,
                        decoration: BoxDecoration(
                          color: zelena1,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: FutureBuilder(
                                future: _loadData("phone"),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                      snapshot.data,
                                      style: Tema.dark
                                          ? StyleZaInformacijeTextDark
                                          : StyleZaInformacijeTextLight,
                                    );
                                  } else
                                    return CircularProgressIndicator();
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.house_outlined,color: Tema.dark?bela:crnaGlavna),
                          SizedBox(width: 3),
                          Text(
                            "Adresa ",
                            style: TextStyle(
                                color: Tema.dark?bela:crnaGlavna,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: size * 0.028),
                        width: size * 0.2,
                        height: size * 0.02,
                        decoration: BoxDecoration(
                          color: zelena1,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder(
                              future: _loadData("personalAddress"),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                    snapshot.data,
                                    style: Tema.dark
                                        ? StyleZaInformacijeTextDark
                                        : StyleZaInformacijeTextLight,
                                  );
                                } else
                                  return CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.location_city,color: Tema.dark?bela:crnaGlavna),
                          SizedBox(width: 3),
                          Text(
                            "Grad",
                            style: TextStyle(
                                color: Tema.dark?bela:crnaGlavna,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: size * 0.038),
                        width: size * 0.2,
                        height: size * 0.02,
                        decoration: BoxDecoration(
                          color: zelena1,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder(
                              future: _loadData("city"),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                    snapshot.data,
                                    style: Tema.dark
                                        ? StyleZaInformacijeTextDark
                                        : StyleZaInformacijeTextLight,
                                  );
                                } else
                                  return CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_outlined,color: Tema.dark?bela:crnaGlavna),
                          SizedBox(width: 3),
                          Text(
                            "Poštanski broj",
                            style: TextStyle(
                                color: Tema.dark?bela:crnaGlavna,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: size * 0.002),
                        width: size * 0.2,
                        height: size * 0.02,
                        decoration: BoxDecoration(
                          color: zelena1,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder(
                              future: _loadData("zipCode"),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                    snapshot.data,
                                    style: Tema.dark
                                        ? StyleZaInformacijeTextDark
                                        : StyleZaInformacijeTextLight,
                                  );
                                } else
                                  return CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.account_balance_wallet_outlined
                          ,color: Tema.dark?bela:crnaGlavna,),
                          SizedBox(width: 3),
                          Text(
                            "Stanje na računu ",
                            style: TextStyle(
                                color: Tema.dark?bela:crnaGlavna,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: size * 0.032),
                        width: size * 0.2,
                        height: size * 0.02,
                        decoration: BoxDecoration(
                          color: zelena1,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: FutureBuilder(
                                future: buyingModel.getBalance(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                      snapshot.data.toStringAsFixed(6) + " ETH",
                                      style: Tema.dark
                                          ? StyleZaInformacijeTextDark
                                          : StyleZaInformacijeTextLight,
                                    );
                                  } else
                                    return CircularProgressIndicator();
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                minWidth: 150,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: darken(narandzasta,.1),
                onPressed: () {
                  _izmenaProfila();
                },
                child: Text(
                  "Izmeni profil".toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: bela,
                  ),
                ),
              ),
              FlatButton(
                minWidth: 150,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: zelena1,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Nazad".toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: bela,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

//lukina stara funkcija
  Future<void> _mojeOcene() async {
    var size = MediaQuery.of(context).size.width;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            backgroundColor: zelenaGlavna,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Center(
              child: Text(
                'MOJE OCENE',
                style: TextStyle(
                  fontSize: 25.0,
                  color: crnaGlavna,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  //=======LIKE I DISLIKE===========
                  Row(
                    children: [
                      Container(
                        width: size * 0.05,
                        height: size * 0.02,
                        decoration: BoxDecoration(
                          color: bela,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.hand_thumbsup_fill,
                              size: size * 0.03,
                              color: Colors.green[800],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size * 0.01,
                      ),
                      Container(
                        width: size * 0.05,
                        height: size * 0.05,
                        decoration: BoxDecoration(
                          color: bela,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.hand_thumbsdown_fill,
                              size: size * 0.03,
                              color: Colors.red[600],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    width: size * 0.15,
                    height: size * 0.05,
                    decoration: BoxDecoration(
                      color: bela,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Jos uvek nemate ocenu"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: bela,
                onPressed: () {
                  // Navigator.of(context).pop();
                  //MaterialPageRoute( builder: (context) => HomeScreen());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreenWeb(),
                    ),
                  );
                },
                child: Text(
                  "Nazad".toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: crnaGlavna,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _mojeOcene2() async {
    var size = MediaQuery.of(context).size.width;
    var marksUserModel = Provider.of<MarksUserModelWeb>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            backgroundColor: zelena1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Center(
              child: Text(
                'MOJE OCENE',
                style: TextStyle(
                  fontSize: 25.0,
                  color: svetloZelena2,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 1.25,
                    padding: EdgeInsets.all(10.0),
                    // decoration: BoxDecoration(
                    //   color: Color(0xffd5f5e7),
                    // ),
                  ),
                  Column(
                    children: [
                      // Container(
                      //   width: size,
                      //   child: Center(child: markContainer),
                      // ),
                      Container(
                        child: Center(
                            child: getDefaultTabController(
                                context)), //getTabController(context))
                      ),
                      /*Container(
                    child: Center(child: getTabBarView(context)),
                  ),*/
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: bela,
                onPressed: () {
                  //select(0);
                  Navigator.of(context).pop();
                  //MaterialPageRoute( builder: (context) => HomeScreen());
                  //Navigator.push(
                  //context,
                  //MaterialPageRoute(
                  // builder: (context) => HomeScreenWeb(),
                  //),
                  //);
                },
                child: Text(
                  "Nazad".toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: crnaGlavna,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //lajkovi i dislajkovi
  Future<List> _loadLikes() async {
    var userMarksModel = Provider.of<MarksUserModelWeb>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return userMarksModel.dajLajkove(prefs.getInt("id"));
  }

  Future<List> _loadDislikes() async {
    var userMarksModel = Provider.of<MarksUserModelWeb>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return userMarksModel.dajDislajkove(prefs.getInt("id"));
  }

  //tab za ocene

  Container positiveMark = Container(color: Colors.red, width: 200);

  ///TAB CONTROLER
  DefaultTabController getDefaultTabController(BuildContext context) =>
      DefaultTabController(
          length: 2,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 0.9,
              width: MediaQuery.of(context).size.width * 0.4,
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
                            icon: Icon(
                              CupertinoIcons.hand_thumbsup_fill,
                              color: Colors.green[500],
                              size: 25.0,
                            ),
                            child: FutureBuilder(
                              future: _loadLikes(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                    snapshot.data.length.toString(),
                                    style:
                                        Tema.dark ? StyleZaLike2 : StyleZaLike1,
                                  );
                                } else
                                  return CircularProgressIndicator();
                              },
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              CupertinoIcons.hand_thumbsdown_fill,
                              color: Colors.red[500],
                              size: 25.0,
                            ),
                            child: FutureBuilder(
                              future: _loadDislikes(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                    snapshot.data.length.toString(),
                                    style:
                                        Tema.dark ? StyleZaLike2 : StyleZaLike1,
                                  );
                                } else
                                  return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // create widgets for each tab bar here -->POZITIVNE
                  Expanded(
                    child: TabBarView(
                      children: [
                        // first tab bar view widget
                        Container(
                          //         backgroundColor: Tema.dark ? darkPozadina : Colors.grey.shade200,
                          color: Tema.dark
                              ? Color.fromRGBO(30, 69, 62, 1)
                              : Color(0xffd5f5e7),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              FutureBuilder(
                                  future: _loadLikes(),
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) =>
                                            Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: FutureBuilder(
                                                future:
                                                    Provider.of<UserModelWeb>(
                                                            context,
                                                            listen: false)
                                                        .GetOwnerUsername(
                                                            snapshot.data[index]
                                                                    [0]
                                                                .toInt()),
                                                builder: (context, snap) {
                                                  if (snap.data != null) {
                                                    return Ocena.ocena(
                                                        snap.data,
                                                        snapshot.data[index][3],
                                                        snapshot.data[index][4],
                                                        snapshot.data[index][5],
                                                        snapshot.data[index]
                                                            [2]);
                                                  } else
                                                    return CircularProgressIndicator();
                                                }),
                                          ),
                                        ),
                                      );
                                    } else
                                      return CircularProgressIndicator();
                                  }),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),

                        // second tab bar viiew widget ---> NEGATIVNE
                        Container(
                          //         backgroundColor: Tema.dark ? darkPozadina : Colors.grey.shade200,
                          color: Tema.dark
                              ? Color.fromRGBO(30, 69, 62, 1)
                              : Color(0xffd5f5e7),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              FutureBuilder(
                                  future: _loadDislikes(),
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) =>
                                            Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: FutureBuilder(
                                              future: Provider.of<UserModelWeb>(
                                                      context,
                                                      listen: false)
                                                  .GetOwnerUsername(snapshot
                                                      .data[index][0]
                                                      .toInt()),
                                              builder: (context, snap) {
                                                if (snap.data != null) {
                                                  return Ocena.ocena(
                                                      snap.data,
                                                      snapshot.data[index][3],
                                                      snapshot.data[index][4],
                                                      snapshot.data[index][5],
                                                      snapshot.data[index][2]);
                                                } else
                                                  return CircularProgressIndicator();
                                              }),
                                        ),
                                      );
                                    } else
                                      return CircularProgressIndicator();
                                  }),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ),
          ));

  //izmena profila
  Future<void> _izmenaProfila() async {
    var size = MediaQuery.of(context).size.width;
    var _firstNameController = TextEditingController();
    var _lastNameController = TextEditingController();
    var _emailController = TextEditingController();
    var _phoneNumberController = TextEditingController();
    bool _emailNotUnique = false;
    bool _phoneNumberNotUnique = false;
    final _formKey = GlobalKey<FormState>();
    var _imagePath;
    String _imageHash;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString("city");

    _firstNameController.text = prefs.getString("firstname");
    _lastNameController.text = prefs.getString("lastname");
    _emailController.text = prefs.getString("email");
    _phoneNumberController.text = prefs.getString("phone");
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            backgroundColor: Tema.dark ? Colors.grey[600] : bela,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text("Izmeni profil",
                style: TextStyle(color: Tema.dark ? bela : siva2)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  UtilTextFormField("Ime", _firstNameController),
                  UtilTextFormField("Prezime", _lastNameController),
                  UtilTextFormField("E-mail", _emailController,
                      validator: validateEmail,
                      errorText:
                          _emailNotUnique ? "E-mail adresa već postoji" : null),
                  UtilTextFormField("Broj telefona", _phoneNumberController,
                      validator: validatePhoneNumber,
                      errorText: _phoneNumberNotUnique
                          ? "Broj telefona već postoji"
                          : null),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlineButton(
                        //  padding: EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("PONIŠTI",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.black)),
                      ),
                      // ignore: deprecated_member_use
                      SizedBox(
                        width: 40,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          // if(!_formKey.currentState.validate()) {
                          //   return;
                          // }
                          //
                          // setState(() {
                          //   _emailNotUnique = false;
                          //   _phoneNumberNotUnique = false;
                          // });
                          // bool success = false;
                          // showLoadingDialog(context);
                          //
                          // if(_file != null) {
                          //   String hash = await _uploadImageFile();
                          //   setState(() {
                          //     _imageHash = hash;
                          //     _file = null;
                          //     _imagePath = null;
                          //   });
                          // }
                          //
                          // try {
                          //   await userModel.updateUserInfo(
                          //     currentUserName: userName,
                          //     firstName: _firstNameController.text,
                          //     lastName: _lastNameController.text,
                          //     email: _emailController.text,
                          //     phoneNumber: _phoneNumberController.text,
                          //     personalAddress: personalAddress,
                          //     city: city,
                          //     zipCode: zipCode,
                          //     ipfsImageHash: _imageHash,
                          //   );
                          //
                          //   success = true;
                          // } on EmailNotUniqueException {
                          //   setState(() {
                          //     _emailNotUnique = true;
                          //   });
                          // } on PhoneNumberNotUniqueException {
                          //   setState(() {
                          //     _phoneNumberNotUnique = true;
                          //   });
                          // }
                          //
                          // Navigator.of(context, rootNavigator: true).pop();
                          // if(!success) {
                          //   return;
                          // }
                          //
                          // await showInformationAlert(context, 'Promena podataka je uspešna.');
                        },
                        color: zelena1,
                        // padding: EdgeInsets.symmetric(horizontal: 50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "SAČUVAJ",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            // actions: <Widget>[
            //   FlatButton(
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(18)),
            //     color: bela,
            //     onPressed: () {
            //       // Navigator.of(context).pop();
            //       //MaterialPageRoute( builder: (context) => HomeScreen());
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => HomeScreenWeb(),
            //         ),
            //       );
            //     },
            //     child: Text(
            //       "Nazad".toUpperCase(),
            //       style: TextStyle(
            //         fontSize: 12,
            //         fontWeight: FontWeight.bold,
            //         color: crnaGlavna,
            //       ),
            //     ),
            //   ),
            // ],
          ),
        );
      },
    );
  }

  Future<void> _showChangePrivateKeyDialog(
      BuildContext context, UserModelWeb userModel) async {
    var privateKeyController = TextEditingController();
    var confirmPrivateKeyController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return showDialog(

        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Tema.dark?Colors.grey[600]:bela,
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                    child: ListBody(children: [
                  UtilTextFormField("Novi privatni ključ", privateKeyController,
                      isPasswordTextField: true,
                      maxLength: 64,
                      validator: validatePrivateKey),
                  UtilTextFormField(
                      "Potvrda privatnog ključa", confirmPrivateKeyController,
                      isPasswordTextField: true,
                      maxLength: 64,
                      validator: (value) =>
                          validatePrivateKey(value) ??
                          validateConfirmPrivateKey(
                              privateKeyController.text, value)),
                ])),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: zelena1,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () async {
                    if (!formKey.currentState.validate()) {
                      return;
                    }
                    showLoadingDialog(context);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    String currentUsername = prefs.getString("username");
                    String newPrivateKey = confirmPrivateKeyController.text;
                    print("DADDA");
                    print(newPrivateKey);
                    try {
                      await userModel.changeUserOwner(
                        context: context,
                        currentUsername: currentUsername,
                        newPrivateKey: newPrivateKey,
                      );
                    } on OwnerNotUniqueException2 {
                      Navigator.of(context, rootNavigator: true).pop();
                      await showInformationAlert(context,
                          "Korisnik sa datim privatnim ključem već postoji");
                      return;
                    }

                    Navigator.of(context, rootNavigator: true).pop();
                    await showInformationAlert(
                        context, "Izmena privatnog ključa je uspešna");
                    Navigator.of(context).pop();
                  },
                  child: Text("PROMENI PRIVATNI KLJUČ"),
                )
              ],
            ));
  }

//ocenili ste 2

  Future<void> _oceniliSte2() async {
    var size = MediaQuery.of(context).size.width;
    var size2 = MediaQuery.of(context).size.height;
    var userModelWeb = Provider.of<UserModelWeb>(context, listen: false);
    var marksUserModelWeb =
        Provider.of<MarksUserModelWeb>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Tema.dark?zelenaDark: zelena1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Center(
            child: Text(
              'OCENILI STE',
              style: TextStyle(
                fontSize: 25.0,
                color: svetloZelena2,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: size * 0.005,
                      right: size * 0.005,
                      bottom: size * 0.005),
                  //padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    FutureBuilder(
                        future: marksUserModelWeb.giveMeMyReviews(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null)
                            return Container(
                              height: size2, // Change as per your requirement
                              width: 450.0, //
                              child: ListView.builder(
                                  shrinkWrap:
                                      true, //ovo mora da se postavi da bi radilo
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: snapshot.data[index][2]
                                              ? StyleZaBoxKomentarWeb
                                              : StyleZaBoxKomentar_2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                      snapshot.data[index][2]
                                                          ? CupertinoIcons
                                                              .hand_thumbsup_fill
                                                          : CupertinoIcons
                                                              .hand_thumbsdown_fill,
                                                      color: snapshot
                                                              .data[index][2]
                                                          ? Colors.green[500]
                                                          : Colors.red[500]),
                                                  SizedBox(width: 10),
                                                  FutureBuilder(
                                                      future: userModelWeb
                                                          .GetOwnerUsername(
                                                              snapshot
                                                                  .data[index]
                                                                      [1]
                                                                  .toInt()),
                                                      builder: (context, snap) {
                                                        if (snap.data != null)
                                                          return Text(snap.data,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Monserrat",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    plavaTekst,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data[index][3],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data[index][4],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data[index][5],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.0,
                                                        fontFamily: "Ubuntu"),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                            );
                          else
                            return CircularProgressIndicator();
                        })
                  ]),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              color: bela,
              onPressed: () {
                Navigator.of(context).pop();
                //MaterialPageRoute( builder: (context) => HomeScreen());
                //Navigator.push(
                //context,
                //MaterialPageRoute(
                // builder: (context) => HomeScreenWeb(),
                //),
                //);
              },
              child: Text(
                "Nazad".toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: crnaGlavna,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

///////// LOKACIJA CHANGE ////

  static const String _cities = StringConstants.cities;
  List<dynamic> _citiesList = json.decode(_cities);
  List<DropdownMenuItem<String>> _citiesDropdownMenuItems;
  String _selectedCity;

  var _personalAddressController = TextEditingController();
  var _zipCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _GetUsername();
    //--ZA da//ne
    _dropDownMenuItemsDaNe = buildDropdownMenuItemsDaNe(DaNeLista);
    _izabranoMsg1 = DaNeLista[0];
    _izabranoMsg2 = DaNeLista[0];
    _izabranoMsg3 = DaNeLista[0];
    _citiesDropdownMenuItems = buildDropdownMenuItems(_citiesList);
    _setupFields();
  }

  Future<void> _setupFields() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString("city");

    _personalAddressController.text = prefs.getString("personalAddress");
    if (_citiesList.contains(city)) {
      _selectedCity = city;
    } else {
      _selectedCity = _citiesList[0];
    }
    _zipCodeController.text = prefs.getString("zipCode");
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(
      List<dynamic> citiesList) {
    List<DropdownMenuItem<String>> items = List();
    for (String city in citiesList) {
      items.add(
        DropdownMenuItem(
          child: Text(
            city,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: siva2,
            ),
          ),
          value: city,
        ),
      );
    }

    return items;
  }

//////
  Future<void> _locationChange() async {
    var size = MediaQuery.of(context).size.width;
    var size2 = MediaQuery.of(context).size.height;

    var userModel = Provider.of<UserModelWeb>(context, listen: false);
    var marksUserModelWeb =
        Provider.of<MarksUserModelWeb>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Tema.dark?Colors.grey[600]:bela,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Center(
            child: Text(
              'Promeni lokaciju',
              style: TextStyle(
                fontSize: 25.0,
                color: Tema.dark?svetloZelena:zelena1,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
            Container(
              height: size2 * 0.5, // Change as per your requirement
              width: size * 0.4,
              padding: EdgeInsets.only(left: 16, top: 25, right: 16),
              child: sharedPrefsWidgetBuilder(builder: (context, prefs) {
                String userName = prefs.getString("username");
                String imageHash = prefs.getString("image");
                String firstName = prefs.getString("firstname");
                String lastName = prefs.getString("lastname");
                String email = prefs.getString("email");
                String phoneNumber = prefs.getString("phone");
                // String personalAddress = prefs.getString("personalAddress");
                // String city = prefs.getString("city");
                // String zipCode = prefs.getString("zipCode");

                //print("CITYCITYCITYCITYCITYCITYCITYCITYCITYCITYCITYCITYCITYCITYCITYCITYCITYCITYCITYCITYCITYCITY: $city");

                return Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      UtilTextFormField("Adresa", _personalAddressController),
                      // Grad
                      Container(
                        color: Tema.dark?Colors.grey[600]:bela,
                        padding: const EdgeInsets.only(bottom: 35.0),
                        child: DropdownButtonFormField(
                          icon: Icon(
                            // Add this
                            Icons.arrow_drop_down, // Add this
                            color: Colors.grey, // Add this
                          ),
                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.all(size * 0.05),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            // prefixIcon: Icon(
                            //   Icons.home,
                            //   color: siva2,
                            // ),
                            focusedBorder: OutlineInputBorder(
                                //borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                              color: Colors.blue[900],
                            )),
                            enabledBorder: OutlineInputBorder(
                              //borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                                //borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(color: Colors.red)),
                            labelText: "Grad",
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          value: _selectedCity,
                          items: _citiesDropdownMenuItems,
                          onChanged: (value) {
                            setState(() {
                              _selectedCity = value;
                            });
                          },
                        ),
                      ),
                      UtilTextFormField("Poštanski broj", _zipCodeController),

                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlineButton(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              Navigator.pop(context);
                              // context,
                              // MaterialPageRoute(
                              //   builder: (context) => settings_pageWeb(),
                              // ),
                            },
                            child: Text("PONIŠTI",
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.black)),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          // ignore: deprecated_member_use
                          RaisedButton(
                            onPressed: () async {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }

                              showLoadingDialog(context);

                              await userModel.updateUserInfo(
                                currentUserName: userName,
                                firstName: firstName,
                                lastName: lastName,
                                email: email,
                                phoneNumber: phoneNumber,
                                personalAddress:
                                    _personalAddressController.text,
                                city: _selectedCity,
                                zipCode: _zipCodeController.text,
                                ipfsImageHash: imageHash,
                              );

                              Navigator.of(context, rootNavigator: true).pop();

                              await showInformationAlert(
                                  context, 'Promena podataka je uspešna.');
                            },
                            color: zelena1,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "SAČUVAJ",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              }),
            ),
          ])),
          // actions: <Widget>[
          //   FlatButton(
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(18)),
          //     color: bela,
          //     onPressed: () {
          //       //Navigator.of(context).pop();
          //       //MaterialPageRoute( builder: (context) => HomeScreen());
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => HomeScreenWeb(),
          //         ),
          //       );
          //     },
          //     child: Text(
          //       "Nazad".toUpperCase(),
          //       style: TextStyle(
          //         fontSize: 12,
          //         fontWeight: FontWeight.bold,
          //         color: crnaGlavna,
          //       ),
          //     ),
          //   ),
          // ],
        );
      },
    );
  }

  ///////

  Future<void> _oceniliSte() async {
    var size = MediaQuery.of(context).size.width;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            backgroundColor: zelenaGlavna,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Center(
              child: Text(
                'OCENILI STE',
                style: TextStyle(
                  fontSize: 25.0,
                  color: crnaGlavna,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  //=======LIKE I DISLIKE===========
                  Column(
                    children: [
                      SizedBox(
                        width: size * 0.02,
                      ),
                      Container(
                        width: size * 0.20,
                        height: size * 0.1,
                        decoration: BoxDecoration(
                          color: bela,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.hand_thumbsup_fill,
                                  size: size * 0.03,
                                  color: Colors.green[800],
                                ),
                                Text(
                                  "MIKA MIKIC",
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Opis iz oglasa tacan?  DA",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Komunikacija protekla dobro?  DA",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Ispostovan dogovor?  DA",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size * 0.02,
                      ),
                      SizedBox(
                        height: size * 0.02,
                      ),
                      SizedBox(
                        width: size * 0.02,
                      ),
                      Container(
                        width: size * 0.20,
                        height: size * 0.1,
                        decoration: BoxDecoration(
                          color: bela,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.hand_thumbsup_fill,
                                  size: size * 0.03,
                                  color: Colors.green[800],
                                ),
                                Text(
                                  "PERA PERIC",
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Opis iz oglasa tacan?  DA",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Komunikacija protekla dobro?  DA",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Ispostovan dogovor?  DA",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size * 0.02,
                      ),
                      SizedBox(
                        height: size * 0.02,
                      ),
                      SizedBox(
                        width: size * 0.02,
                      ),
                      Container(
                        width: size * 0.20,
                        height: size * 0.1,
                        decoration: BoxDecoration(
                          color: bela,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.hand_thumbsdown_fill,
                                  size: size * 0.03,
                                  color: Colors.red[600],
                                ),
                                Text(
                                  "LUKA LUKOVIC",
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Opis iz oglasa tacan?  NE",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Komunikacija protekla dobro?  NE",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Ispostovan dogovor?  NE",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size * 0.02,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: bela,
                onPressed: () {
                  //Navigator.of(context).pop();
                  //MaterialPageRoute( builder: (context) => HomeScreen());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreenWeb(),
                    ),
                  );
                },
                child: Text(
                  "Nazad".toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: crnaGlavna,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }

  Future<bool> _showPrivateKeyPrompt(BuildContext context) async {
    var privateKeyController = TextEditingController();
    bool privateKeyIsCorrect = false;
    var formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Tema.dark?darkPozadina:bela,
        content: Container(
          color: Tema.dark?darkPozadina:bela,

          child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: ListBody(children: [
                  Text("Unesite privatni ključ",style: TextStyle(
                    color: Tema.dark?bela:crnaGlavna,

                  ),),
                  UtilTextFormField(null, privateKeyController,
                      isPasswordTextField: true,
                      validator: validatePrivateKey,
                      bottomPadding: 0,
                      maxLength: 64),
                ]),
              )),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: zelena1,
              onPrimary: Colors.white,
            ),
            child: Text("OK"),
            onPressed: () async {
              if (!formKey.currentState.validate()) {
                return;
              }
              SharedPreferences prefs = await SharedPreferences.getInstance();
              privateKeyIsCorrect =
                  prefs.getString("privatekey") == privateKeyController.text;

              // await FlutterKeychain.get(key: "privatekey") ==
              //     privateKeyController.text;|

              if (privateKeyIsCorrect) {
                Navigator.of(context).pop();
              } else {
                await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Text("Pogrešan privatni ključ"),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: zelena1,
                                onPrimary: Colors.white,
                              ),
                              child: Text("OK"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ));
              }
            },
          ),
        ],
      ),
    );

    return privateKeyIsCorrect;
  }

  //Funkcija za alert -- brisanje naloga
  Future<void> _brisanjeNaloga() async {
    var userModel = Provider.of<UserModelWeb>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Tema.dark?darkPozadina:bela,
          title: Text(
            'Brisanje naloga',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Da li ste sigurni da želite da obrišete svoj nalog?',
                style: TextStyle(color:Tema.dark?bela:crnaGlavna),),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: zelena1,
                onPrimary: Colors.white,
              ),
              child: Text(
                'Obriši ',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                bool success=await userModel.deleteUser();
                if(success) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => WelcomeWeb()),
                          (Route<dynamic> route) => false);
                }

                /*

                onTap: () async {
                      bool success = await userModel.logout();
                      if (success) {
                        productModel = null;
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Welcome()),
                            (Route<dynamic> route) => false);
                      }
                    },

                 */
                /* bool success=await userModel.deleteUser();
               if(success) {
                 Navigator.of(context).pushAndRemoveUntil(
                     MaterialPageRoute(builder: (context) => Welcome()),
                         (Route<dynamic> route) => false);
               }*/
                //
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: zelena1,
                onPrimary: Colors.white,
              ),
              child: Text(
                'Odustani ',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Brightness _getBrightness() {
    return Tema.dark ? Brightness.dark : Brightness.light;
  }

  //nova podesavanja

  Future<void> _podesavanja2() async {
    var size = MediaQuery.of(context).size.width;
    var userModel = Provider.of<UserModelWeb>(context, listen: false);
    bool val = Tema.dark;
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            child: Theme(
              data: ThemeData(
                brightness: _getBrightness(),
              ),
              child: AlertDialog(
                title: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          //Navigator.push(
                          //context,
                          //MaterialPageRoute(
                          // builder: (context) => HomeScreenWeb(),
                          //),
                          // );
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.black)),
                    Text(
                      "Podešavanja",
                      style: TextStyle(
                        color: Tema.dark ? Colors.white : Colors.black,
                        fontFamily: "Ubuntu",
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                content: Container(
                  width: size * 0.45,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              sharedPrefsWidgetBuilder(
                                  builder: (context, prefs) {
                                var firstName = prefs.getString("firstname");
                                var lastName = prefs.getString("lastname");
                                // var imageHash = prefs.getString("image");

                                return Card(
                                  elevation: 8.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  color: zelena1,
                                  /*----- MENI ZA PROFIL ----*/
                                  child: ListTile(
                                    onTap: () {
                                      _izmenaProfila();
                                      // Navigator.push(
                                      // context,
                                      // MaterialPageRoute(
                                      // builder: (context) => _izmenaProfila(),
                                      // ),
                                      // );
                                    },
                                    title: Text(
                                      //"dada",
                                      "$firstName $lastName",
                                      style: TextStyle(
                                        color: belaGlavna,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      // child: ipfsImageWidgetBuilder(
                                      //   imageHash: imageHash,
                                      //   builder: (context, imageProvider) =>
                                      //       CircleAvatar(
                                      //         backgroundImage: imageProvider,
                                      //       ),
                                      //   loadingBuilder: (context, snapshot) =>
                                      //       CircularProgressIndicator(),
                                      // ),
                                    ),
                                    trailing: Icon(
                                      Icons.edit,
                                      color: bela,
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(height: 10.0),
                              /* ------ TRI PODESAVANJA ------ */
                              Card(
                                //color: svetloPlava3,
                                elevation: 4.0,
                                margin: const EdgeInsets.fromLTRB(
                                    32.0, 8.0, 32.0, 16.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(
                                        Icons.lock_outline,
                                        color: zelena1,
                                      ),
                                      title: Text(
                                        "Promeni privatni ključ",
                                        style: TextStyle(
                                          color: Tema.dark
                                              ? Colors.white
                                              : Colors.black,
                                          fontFamily: "Ubuntu",
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.keyboard_arrow_right,
                                        color: zelena1,
                                      ),
                                      onTap: () async {
                                        bool success =
                                            await _showPrivateKeyPrompt(
                                                context);
                                        if (success) {
                                          await _showChangePrivateKeyDialog(
                                              context, userModel);
                                        }
                                      },
                                    ),
                                    // _buildDivider(),
                                    // ListTile(
                                    //   leading: Icon(
                                    //     FontAwesomeIcons.language,
                                    //     color: zelena1,
                                    //   ),
                                    //   title: Text(
                                    //     "Promeni jezik",
                                    //     style: TextStyle(
                                    //       color: Tema.dark
                                    //           ? Colors.white
                                    //           : Colors.black,
                                    //       fontFamily: "Ubuntu",
                                    //     ),
                                    //   ),
                                    //   trailing: Icon(
                                    //     Icons.keyboard_arrow_right,
                                    //     color: zelena1,
                                    //   ),
                                    //   onTap: () {
                                    //     //open change language
                                    //   },
                                    // ),
                                    _buildDivider(),
                                    ListTile(
                                      leading: Icon(
                                        Icons.location_on,
                                        color: zelena1,
                                      ),
                                      title: Text(
                                        "Promeni lokaciju",
                                        style: TextStyle(
                                          color: Tema.dark
                                              ? Colors.white
                                              : Colors.black,
                                          fontFamily: "Ubuntu",
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.keyboard_arrow_right,
                                        color: zelena1,
                                      ),
                                      onTap: () {
                                        _locationChange();
                                        //Navigator.push(
                                        //context,
                                        //MaterialPageRoute(
                                        //builder: (context) =>
                                        //LocationSettingsPage()),
                                        //);
                                      },
                                    ),
                                    _buildDivider(),
                                    ListTile(
                                      leading: Icon(
                                        Icons.delete,
                                        color: zelena1,
                                      ),
                                      title: Text(
                                        "Obriši nalog",
                                        style: TextStyle(
                                          color: Tema.dark
                                              ? Colors.white
                                              : Colors.black,
                                          fontFamily: "Ubuntu",
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.keyboard_arrow_right,
                                        color: zelena1,
                                      ),
                                      onTap: () {
                                           _brisanjeNaloga();
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           LocationSettingsPage()),
                                        //);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Container(
                                width: size * 0.9,
                                child: Text(
                                  "Obaveštenja",
                                  style: TextStyle(
                                    color:
                                        Tema.dark ? Colors.white : Colors.black,
                                    fontFamily: "Ubuntu",
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SwitchListTile(
                                activeColor: Tema.dark ? Colors.white : siva2,
                                contentPadding: const EdgeInsets.all(0),
                                value: true,
                                title: Text(
                                  "Primaj obaveštenja",
                                  style: TextStyle(
                                    color:
                                        Tema.dark ? Colors.white : plavaTekst,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                                onChanged: (val) {},
                              ),
                              const SizedBox(height: 30.0),
                              // Container(
                              //   width: size * 0.9,
                              //   child: Text(
                              //     "Promena teme",
                              //     style: TextStyle(
                              //       color:
                              //           Tema.dark ? Colors.white : Colors.black,
                              //       fontFamily: "Ubuntu",
                              //       fontSize: 20,
                              //     ),
                              //   ),
                              // ),
                              // SwitchListTile(
                              //   activeColor: Tema.dark ? Colors.white : siva2,
                              //   contentPadding: const EdgeInsets.all(0),
                              //   value: val,
                              //   title: Text(
                              //     "Tamni režim",
                              //     style: TextStyle(
                              //       color:
                              //           Tema.dark ? Colors.white : plavaTekst,
                              //       fontFamily: "Montserrat",
                              //     ),
                              //   ),
                              //   onChanged: (val) {
                              //     /////
                              //     Tema.dark = !Tema.dark;
                              //     val = Tema.dark;
                              //     print(val);
                              //   },
                              // ),
                              const SizedBox(height: 60.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<void> _pretraga() async {
    var size = MediaQuery.of(context).size.width;
    UserModelWeb userModel = Provider.of<UserModelWeb>(context, listen: false);

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container();
        });
  }
  Future<List> pendingBuyer() async {
    var buyingModel = Provider.of<BuyingModelWeb>(context, listen: false);
    return await buyingModel.getAllPendingBuyer();
  }

  Future<List> confirmedBuyer() async {
    var buyingModel = Provider.of<BuyingModelWeb>(context, listen: false);
    return await buyingModel.getAllConfirmedBuyer();
  }

  Future<List> canceledBuyer() async {
    var buyingModel = Provider.of<BuyingModelWeb>(context, listen: false);
    return await buyingModel.getAllCanceledBuyer();
  }

  Future<Product> getProductById(int id) async {
    var productModel = Provider.of<ProductModelWeb>(context, listen: false);
    print("id proizvoda: " + id.toString());
    return await productModel.getProductById(id);
  }


    Future<void> kupljeno() async {
    var userModel = Provider.of<UserModelWeb>(context, listen: false);

    var size = MediaQuery.of(context).size.width;
    var size2 = MediaQuery.of(context).size.height;

    return showDialog<void>(
    context: context,

    barrierDismissible: false,
    builder: (BuildContext context) {
    return AlertDialog(
      backgroundColor: Tema.dark?darkPozadina:bela,
        insetPadding: EdgeInsets.symmetric(horizontal: 150),
        title: Row(
      children: [
        Container(
          margin:EdgeInsets.only(top:5,left:5),
          child:  FlatButton(
            height: 20,
            minWidth: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(130)),
            color: Tema.dark?darkPozadina:bela,
            onPressed: () {
              //select(0);
              Navigator.of(context).pop();
            },
            child:
            Icon(Icons.arrow_back,color: zelena1,size: 30,),
          ),
        ),
        Text(
        'Kupili ste',
        style: TextStyle(
        color: Tema.dark?svetloZelena:zelena1,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.bold,
        ),
        ),
      ],
    ),
    content: Container(
        color: Tema.dark ? siva : bela,
        child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: DefaultTabController(
            length: 3,
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.35,
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
                                      style: TextStyle(color: Tema.dark?svetloZelena:zelena1),
                                    )),
                                Tab(
                                    child: Text(
                                      "Potvrdjene",
                        style: TextStyle(color: Tema.dark?svetloZelena:zelena1),
                                    )),
                                Tab(
                                    child: Text(
                                      "Otkazane",
      style: TextStyle(color: Tema.dark?svetloZelena:zelena1),
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
                            color: Tema.dark?darkPozadina:bela,
                                    child: FutureBuilder(
                                        future: pendingBuyer(),
                                        builder: (context, snapshot) {
                                          if(snapshot.data != null) {
                                            return GridView.builder(
                                                itemCount: snapshot.data.length,
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4, //BROJ ELEMENATA U VRSTI
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
                                    color: Tema.dark?darkPozadina:bela,

                                    child: FutureBuilder(
                                        future: confirmedBuyer(),
                                        builder: (context, snapshot) {
                                          if(snapshot.data != null) {
                                            return GridView.builder(
                                                itemCount: snapshot.data.length,
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4, //BROJ ELEMENATA U VRSTI
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
                                    color: Tema.dark?darkPozadina:bela,

                                    child: FutureBuilder(
                                        future: canceledBuyer(),
                                        builder: (context, snapshot) {
                                          if(snapshot.data != null) {
                                            return GridView.builder(
                                                itemCount: snapshot.data.length,
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4, //BROJ ELEMENATA U VRSTI
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
    )
    );
    }
    );
  }



  Future<void> popUpPorudzbinaKupacConfirmed(int userId, int productId, String address, String phone, int amount, String unit) {

    setState((){});
    Future<bool> isItRatable(int productId) async {

      var buyingModel = Provider.of<BuyingModelWeb>(context, listen: false);
      var productMarksModel = Provider.of<MarksProductModelWeb>(context, listen: false);
      var numOfBought = await buyingModel.numberOfConfirmed(productId);
      var numOfRated = await productMarksModel.numberOfMarksPerUser(productId);
      return numOfBought > numOfRated;
    }

    Future<Product> getProductById() async {
      var productModel = Provider.of<ProductModelWeb>(context, listen: false);
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
                              SizedBox(height:6),
                              FlatButton(
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(15)),
                                color: zelena1,
                                onPressed: () {
                                  Navigator.of(context).pop();

                                },
                                child: Text(
                                  "POTVRDI".toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
                                            'Oceni '.toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: ()  {
                                            //int username,int ID
                                            _oceni();
                                            // Navigator.push(context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) => RatingPage(
                                            //             username: userId,
                                            //             ID: productId)
                                            //     )
                                            // );
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
  Future<void> popUpPorudzbinaKupacPending(int userId, int productId, String address, String phone, int amount, String unit) {

    setState((){});

    Future<Product> getProductById() async {
      var productModel = Provider.of<ProductModelWeb>(context, listen: false);
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
                                    SizedBox(height:6),
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)),
                                      color: zelena1,
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                      },
                                      child: Text(
                                        "POTVRDI".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: bela,
                                        ),
                                      ),
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


  Future<void> popUpPorudzbinaKupacCanceled(int userId, int productId, String address, String phone, int amount, String unit) {
    setState((){});

    Future<Product> getProductById() async {
      var productModel = Provider.of<ProductModelWeb>(context, listen: false);
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
                                  SizedBox(height:6),
                                  FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)),
                                    color: zelena1,
                                    onPressed: () {
                                      Navigator.of(context).pop();

                                    },
                                    child: Text(
                                      "POTVRDI".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: bela,
                                      ),
                                    ),
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
    var userModel = Provider.of<UserModelWeb>(context, listen: false);

    return userModel.getFirstnameLastname(userId);
  }

  //PRODATIIi
  Future<List> pendingSeller() async {
    var buyingModel = Provider.of<BuyingModelWeb>(context, listen: false);
    return buyingModel.getAllPendingSeller();
  }

  Future<List> confirmedSeller() async {
    var buyingModel = Provider.of<BuyingModelWeb>(context, listen: false);
    return buyingModel.getAllConfirmedSeller();
  }

  Future<List> canceledSeller() async {
    var buyingModel = Provider.of<BuyingModelWeb>(context, listen: false);
    return buyingModel.getAllCanceledSeller();
  }



  Future<void> prodato() async {
    var userModel = Provider.of<UserModelWeb>(context, listen: false);

    var size = MediaQuery.of(context).size.width;
    var size2 = MediaQuery.of(context).size.height;

    return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: Tema.dark?darkPozadina:bela,
          insetPadding: EdgeInsets.symmetric(horizontal: 150),
          title: Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 5, left: 5),
                child: FlatButton(
                  height: 20,
                  minWidth: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(130)),
                  color: Tema.dark?darkPozadina:bela,
                  onPressed: () {
                    //select(0);
                    Navigator.of(context).pop();
                  },
                  child:
                  Icon(Icons.arrow_back, color: Tema.dark?svetloZelena: zelena1, size: 30,),
                ),
              ),
              Text(
                'Prodali ste',
                style: TextStyle(
                  color: Tema.dark?svetloZelena:zelena1,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content:  Container(
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
                                                style: TextStyle( color: Tema.dark?svetloZelena:zelena1,),
                                              )),
                                          Tab(
                                              child: Text(
                                                "Potvrdjene",
                                                style: TextStyle( color: Tema.dark?svetloZelena:zelena1,),
                                              )),
                                          Tab(
                                              child: Text(
                                                "Otkazane",
                                                style: TextStyle( color: Tema.dark?svetloZelena:zelena1,),
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
                                              color: Tema.dark?darkPozadina:bela,
                                              child: FutureBuilder(
                                                  future: pendingSeller(),
                                                  builder: (context, snapshot) {
                                                    if(snapshot.data != null) {
                                                      return GridView.builder(
                                                          itemCount: snapshot.data.length,
                                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 4, //BROJ ELEMENATA U VRSTI
                                                            mainAxisSpacing: size * 0.03,
                                                            crossAxisSpacing: size * 0.03,
                                                          ),
                                                          itemBuilder: (context, index) =>
                                                              GestureDetector(
                                                                  onTap:(){
                                                                    print(snapshot.data);
                                                                    popUpPorudzbinaProdavac(snapshot.data[index][1].toInt(),
                                                                        snapshot.data[index][2].toInt(), snapshot.data[index][5],
                                                                        snapshot.data[index][6], snapshot.data[index][3].toInt(),
                                                                        snapshot.data[index][4], snapshot.data[index][8].toInt(),
                                                                        snapshot.data[index][7]);
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
                                          //--POTVRDJENE---//
                                          Container(
                                              color: Tema.dark?darkPozadina:bela,

                                              child: FutureBuilder(
                                                  future: confirmedSeller(),
                                                  builder: (context, snapshot) {
                                                    if(snapshot.data != null) {
                                                      return GridView.builder(
                                                          itemCount: snapshot.data.length,
                                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 4, //BROJ ELEMENATA U VRSTI
                                                            mainAxisSpacing: size * 0.03,
                                                            crossAxisSpacing: size * 0.03,
                                                          ),
                                                          itemBuilder: (context, index) =>
                                                              GestureDetector(
                                                                  onTap:(){
                                                                    popUpPorudzbinaPotvrdjeno(snapshot.data[index][1].toInt(),
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
                                          //--OTKAZANE---//
                                          Container(
                                              color: Tema.dark?darkPozadina:bela,
                                              child: FutureBuilder(
                                                  future: canceledSeller(),
                                                  builder: (context, snapshot) {
                                                    if(snapshot.data != null) {
                                                      return GridView.builder(
                                                          itemCount: snapshot.data.length,
                                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 4, //BROJ ELEMENATA U VRSTI
                                                            mainAxisSpacing: size * 0.03,
                                                            crossAxisSpacing: size * 0.03,
                                                          ),
                                                          itemBuilder: (context, index) =>
                                                              GestureDetector(
                                                                  onTap:(){
                                                                    popUpPorudzbinaCanceled(snapshot.data[index][1].toInt(),
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
          )
      );
    }
    );

  }
  //pop up za prodatoo
  Future<void> popUpPorudzbinaProdavac(int userId, int productId, String address, String phone, int amount, String unit, int transactionId, String paidIn) {
    var productModel = Provider.of<ProductModelWeb>(context, listen: false);

    Future<Product> getProductById() async {
      var productModel = Provider.of<ProductModelWeb>(context, listen: false);
      return await productModel.getProductById(productId);
    }
    var buyingModel = Provider.of<BuyingModelWeb>(context, listen: false);

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
                                    Flexible(child: Text('Korisnik:' +   snapshot.data)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(child: Text('Oglas:' + snap.data.title)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(child: Text('Adresa:'  + address)),
                                  ],
                                ),  Row(
                                  children: [
                                    Flexible(child: Text('Broj telefona:' + phone)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(child: Text('Količina:' + amount.toString() + unit)),
                                  ],
                                ),

                              ],
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: zelena1,
                                onPrimary: Colors.white,
                              ),
                              child: Text(
                                'Prihvati',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                setState((){});
                                Navigator.of(context).pop();
                                await buyingModel.addToConfirmed(transactionId);
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: zelena1,
                                onPrimary: Colors.white,
                              ),
                              child: Text(
                                'Odbij',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                setState((){});
                                Navigator.of(context).pop();
                                var userModel = Provider.of<UserModelWeb>(context, listen: false);
                                var username = await userModel.GetOwnerUsername(userId);
                                await buyingModel.addToCancelled(transactionId);
                                print("asd: " + paidIn);
                                if(paidIn == "ETH")
                                {
                                  var priceEth = ProductModelWeb.totalProducts[productId].priceEth;
                                  var address = UserModelWeb();
                                  await address.setPrivateKey();
                                  var address1 = await address.GetOwnerInfo(username);
                                  await buyingModel.sendEther2(amount, priceEth, address1);
                                  print("refunded");
                                }
                              },
                            ),
                          ],
                        );
                      else return CircularProgressIndicator();
                    }
                );
              else return CircularProgressIndicator();
            }
        );
      },
    );
  }

  Future<void> popUpPorudzbinaPotvrdjeno(int userId, int productId, String address, String phone, int amount, String unit) {
    setState((){});

    Future<Product> getProductById() async {
      var productModel = Provider.of<ProductModelWeb>(context, listen: false);
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
                                      Flexible(child: Text('Korisnik: ' +  snapshot.data)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Flexible(child: Text('Oglas: ' + snap.data.title)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Flexible(child: Text('Adresa dostave: ' + address)),
                                    ],
                                  ),  Row(
                                    children: [
                                      Flexible(child: Text('Broj telefona: ' + phone)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Flexible(child: Text('Količina: ' + amount.toString() + unit)),
                                    ],
                                  ),
                                  SizedBox(height:6),
                                  FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)),
                                    color: zelena1,
                                    onPressed: () {
                                      Navigator.of(context).pop();

                                    },
                                    child: Text(
                                      "POTVRDI".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: bela,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ); else return CircularProgressIndicator();
                      }
                  ); else return CircularProgressIndicator();
              }
          );
        }
    );
  }

  Future<void> popUpPorudzbinaCanceled(int userId, int productId, String address, String phone, int amount, String unit) {
    setState((){});

    Future<Product> getProductById() async {
      var productModel = Provider.of<ProductModelWeb>(context, listen: false);
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
                                      Flexible(child: Text('Korisnik: ' +  snapshot.data)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Flexible(child: Text('Oglas: ' + snap.data.title)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Flexible(child: Text('Adresa dostave: ' + address)),
                                    ],
                                  ),  Row(
                                    children: [
                                      Flexible(child: Text('Broj telefona: ' + phone)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Flexible(child: Text('Količina: ' + amount.toString() + unit)),
                                    ],
                                  ),
                                  SizedBox(height:6),
                                  FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)),
                                    color: zelena1,
                                    onPressed: () {
                                      Navigator.of(context).pop();

                                    },
                                    child: Text(
                                      "POTVRDI".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: bela,
                                      ),
                                    ),
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
  int ime;
  Future<int> _loadInts(String dataNeeded) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int data = prefs.getInt(dataNeeded);
    return data;
  }
  Future<void> _GetUsername() async {
    int  username;
    username = await _loadInts("id");
    setState(() => ime = username);
  }
  List<DropdownMenuItem<String>> _dropDownMenuItemsDaNe;
  String _izabranoMsg1;
  String _izabranoMsg2;
  String _izabranoMsg3;
  final String DaNe = '["Da","Ne"]';
  List<dynamic> DaNeLista = json.decode('["Da","Ne"]');


  //funkcija za DA NE
  //funkcija za Nudim/trazim
  List<DropdownMenuItem<String>> buildDropdownMenuItemsDaNe(
      List<dynamic> DaNeLista) {
    // ignore: deprecated_member_use
    List<DropdownMenuItem<String>> items = List();
    for (String dane in DaNeLista) {
      items.add(
        DropdownMenuItem(
          child: Center(
            child: Text(
              dane,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Tema.dark ? bela :crnaGlavna,
                fontSize: 15,
              ),
            ),
          ),
          value: dane,
        ),
      );
    }
    return items;
  }

  double _iconRating=0;

  Future<void> _oceni() async {
    var userModel = Provider.of<UserModelWeb>(context, listen: false);
    var marksUserModel = Provider.of<MarksUserModelWeb>(context, listen: false);
    var marksProductModel = Provider.of<MarksProductModelWeb>(context, listen: false);

    var size = MediaQuery.of(context).size.width;
    var size2 = MediaQuery.of(context).size.height;

      //--ZA da//ne
      _dropDownMenuItemsDaNe = buildDropdownMenuItemsDaNe(DaNeLista);
      _izabranoMsg1 = DaNeLista[0];
      _izabranoMsg2 = DaNeLista[0];
      _izabranoMsg3 = DaNeLista[0];


    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 150),

          title: Text(
            'Ocenjivanje naloga',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: bulidContainer(size2),
                ),
                //
              ],
            ),
          ),
          actions: <Widget>[
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
                  fontSize: 14,
                ),
              ),
              onPressed: () async {
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

              int username=ime;
                if(like == 0) //dislajkujemo
                    {
                  await marksUserModel.addDislike(ime, username, _izabranoMsg1,_izabranoMsg2, _izabranoMsg3);
                }
                else //lajkujemo
                    {
                  await marksUserModel.addLike(ime, username, _izabranoMsg1,_izabranoMsg2, _izabranoMsg3);
                }
//  double _ocena,
//       int _id,
                await marksProductModel.addMarks(_iconRating, username);
                _FinishRating();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: zelena1,
                onPrimary: Colors.white,
              ),
              child: Text(
                'Ponisti ',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 14,

                ),
              ),
              onPressed: () async {
              Navigator.pop(context);
              },
            ),

          ],
        );

      },
    );
  }
  //ocene
  Container bulidContainer(double size) {
    return Container(
      padding: EdgeInsets.only(
          top: size * 0.02, left: size * 0.01, right: size * 0.01),
      child: Container(
       // padding: EdgeInsets.all(size * 0.05),
        height: size*0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:Tema.dark ? crvenaGlavna :  Color.fromRGBO(250, 129, 107, 1),
          //  color:  Colors.lightGreen[200]//Color(0xFF95E08E),
        ),
        child: Column(
          children: [

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
                RatingBar.builder(
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                    _iconRating = rating;
                  },

                  // color: GFColors.DARK,
                  // borderColor: GFColors.DARK,
                  // filledIcon: Icon(
                  //   Icons.star,
                  //   size: GFSize.LARGE,
                  //   color: GFColors.DANGER,
                  // ),
                  // size: GFSize.LARGE,
                  // value: _iconRating,
                  // onChanged: (value) {
                  //   setState(() {
                  //     _iconRating = value;
                  //   });
                  // },
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
                        color:Tema.dark ? darkPozadina : Colors.white,
                        //padding: EdgeInsets.all(2),
                        width: 95,
                        child: Center(
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            dropdownColor: Tema.dark ? crvenaGlavna : Colors.white,
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
                        color:Tema.dark ? darkPozadina : Colors.white,
                        //padding: EdgeInsets.all(2),
                        width: 95,
                        child: Center(
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            dropdownColor: Colors.white,
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
                        color:Tema.dark ? darkPozadina : Colors.white,
                        //padding: EdgeInsets.all(2),
                        width: 95,
                        child: Center(
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            dropdownColor: Colors.white,
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
          //     Text(''),
          //   ],
          // ),
          actions: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: zelena1,
                  onPrimary: Colors.white,
                ),
                child: Text(
                  'Povratak na početnu stranu',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomeScreenWeb()),
                          (Route<dynamic> route) => false);
                  // Navigator.push(
                  //context,
                  // MaterialPageRoute(
                  // builder: (context) => HomeScreen(),
                  //),
                  //);
                },
              ),
            ),
          ],
        );
      },
    );
  }

}






/*
CARD

Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: zelena1,
              /*----- MENI ZA PROFIL ----*/
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileSettingsPage(),
                    ),
                  );
                },
                title: Center(
                  child: Text(
                    "CAO",
                    style: TextStyle(
                      color: belaGlavna,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
 */
