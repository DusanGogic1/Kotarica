import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kotarica/ads/MyAds/mainView.dart';
import 'package:kotarica/ads/kupljeniOglasi/kupljeni.dart';
import 'package:kotarica/ads/prodatiOglasi/prodati.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/marks/MyMarksNew.dart';
import 'package:kotarica/marks/you_rated.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/registration/Welcome.dart';
import 'package:kotarica/settings/settings_page1.dart';
import 'package:kotarica/user/UserInfo.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Tema.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Future<String> _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String _name =
        prefs.getString("firstname") + " " + prefs.getString("lastname");
    print(_name);
    return _name;
  }

  Future<ImageProvider> _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String image = await ipfsImage(prefs.getString("image"));
    return Image.memory(base64Decode(image)).image;
  }


  Brightness getBrightness() {
    setState(() {
    });
    return Tema.dark ? Brightness.dark : Brightness.light;

  }


  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context, listen: false);
    var productModel = Provider.of<ProductModel>(context, listen: false);
    var size = MediaQuery.of(context).size.width;
    setState(() {
    });
    return Container(
      color: Tema.dark ? darkPozadina: Colors.grey.shade200,
      child: SingleChildScrollView(
        child: productModel.getTotalCountReady() &&
                productModel.getProductsReady()
            ? Column(children: [
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: size * 0.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            child: FutureBuilder(
                                future: _loadImage(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return CircleAvatar(
                                        backgroundImage: snapshot.data,
                                        radius: 50);
                                  } else
                                    return CircularProgressIndicator();
                                })),
                        SizedBox(
                          height: size * 0.05,
                        ),
                        /*----- Lista MENI -----*/
                        Container(
                            child: FutureBuilder(
                                future: _loadName(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(snapshot.data,
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w800,
                                          color:  Tema.dark ? svetloZelena : zelena1,
                                        ));
                                  } else
                                    return CircularProgressIndicator();
                                })),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size * 0.05,
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserInfo(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.person,
                    color:  Tema.dark ? svetloZelena : zelena1,
                    size: 35.0,
                  ),
                  title: Text("Profil",
                      style: TextStyle(
                          color:  Tema.dark ? svetloZelena : zelena1,
                          fontFamily: "Montserrat",
                          fontSize: 15.0)),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => mainView(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.assignment_outlined,
                    color:  Tema.dark ? svetloZelena : zelena1,
                    size: 35.0,
                  ),
                  title: Text(
                    //mainView
                    "Moji oglasi",
                    style: TextStyle(
                        color:  Tema.dark ? svetloZelena : zelena1,
                        fontFamily: "Montserrat",
                        fontSize: 15.0),
                  ),
                ),
              //kupljeno
              ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => kupljeni(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.add_shopping_cart,
                    color:  Tema.dark ? svetloZelena : zelena1,
                    size: 35.0,
                  ),
                  title: Text(
                    //mainView
                    "Kupljeno",
                    style: TextStyle(
                        color:  Tema.dark ? svetloZelena : zelena1,
                        fontFamily: "Montserrat",
                        fontSize: 15.0),
                  ),
                ),
                //prodato
                ListTile(
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => prodati(),
                    ),
                  );
                },
                leading: Icon(
                  Icons.collections_bookmark_rounded,
                  color:  Tema.dark ? svetloZelena : zelena1,
                  size: 35.0,
                ),
                title: Text(
                  //mainView
                  "Prodato",
                  style: TextStyle(
                    color:  Tema.dark ? svetloZelena : zelena1,
                    fontFamily: "Montserrat",
                    fontSize: 15.0),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OcenePageNew(),
                        //my_marks(username: "pera"),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.assessment,
                    color:  Tema.dark ? svetloZelena : zelena1,
                    size: 35.0,
                  ),
                  title: Text(
                    "Moje Ocene",
                    style: TextStyle(
                        color:  Tema.dark ? svetloZelena : zelena1,
                        fontFamily: "Montserrat",
                        fontSize: 15.0),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => YouRated(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.rate_review_rounded,
                    color:  Tema.dark ? svetloZelena : zelena1,
                    size: 35.0,
                  ),
                  title: Text(
                    "Ocenili ste",
                    style: TextStyle(
                        color:  Tema.dark ? svetloZelena : zelena1,
                        fontFamily: "Montserrat",
                        fontSize: 15.0),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              settings_page() //(username: "pera"),
                          ),
                    );
                  },
                  leading: Icon(
                    Icons.settings,
                    color:  Tema.dark ? svetloZelena : zelena1,
                    size: 35.0,
                  ),
                  title: Text(
                    "Podesavanja",
                    style: TextStyle(
                        color:  Tema.dark ? svetloZelena : zelena1,
                        fontFamily: "Montserrat",
                        fontSize: 15.0),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    bool success = await userModel.logout();
                    if (success) {
                      ProductModel.cart.clear();
                      productModel = null;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Welcome()),
                          (Route<dynamic> route) => false);
                    }
                  },
                  leading: Icon(
                    Icons.logout,
                    color:  Tema.dark ? svetloZelena : zelena1,
                    size: 35.0,
                  ),
                  title: Text(
                    "Odjavi se",
                    style: TextStyle(
                        color:  Tema.dark ? svetloZelena : zelena1,
                        fontFamily: "Montserrat",
                        fontSize: 15.0),
                  ),
                ),
              ])
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
