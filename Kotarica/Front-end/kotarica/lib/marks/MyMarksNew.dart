import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/models/MarksUserModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Ocena.dart';

class OcenePageNew extends StatefulWidget {
  static const routeName = '/Ocene';

  OcenePageNew({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _OcenePageState createState() => _OcenePageState();
}

class _OcenePageState extends State<OcenePageNew> {
  int lajkovi;

  @override
  _OcenePageState() {
    currentTabIndex = 0;
  }
  String ime;
  Future<String> _loadData(String dataNeeded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = prefs.getString(dataNeeded);
    return data;
  }
  Future<void> _GetUsername() async {
   String  username;
   username= await _loadData("username");
   setState(() => ime = username);
  }

  void initState() {
    super.initState();
    _GetUsername();
  }
  Future<List> _loadLikes() async {
    var userMarksModel = Provider.of<MarksUserModel>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return userMarksModel.dajLajkove(prefs.getInt("id"));
  }

  Future<List> _loadDislikes() async {
    var userMarksModel = Provider.of<MarksUserModel>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return userMarksModel.dajDislajkove(prefs.getInt("id"));
  }

  int currentTabIndex = 0; // 0 - total, 1 - my marks, 2 - other's marks

  Container positiveMark = Container(color: Colors.red, width: 200);
  ///TAB CONTROLER
  DefaultTabController getDefaultTabController(
          BuildContext context) =>
      DefaultTabController(
          length: 2,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height/1.1,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Scaffold(
                  body: Column(
                children: <Widget>[
                  SizedBox(
                    height: 74,
                    child: AppBar(
                      backgroundColor: Tema.dark ? darkPozadina : Colors.grey.shade200,
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
                                    style: Tema.dark?StyleZaLike2:StyleZaLike1,
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
                                    style: Tema.dark?StyleZaLike2:StyleZaLike1,
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
                          color: Tema.dark ?Color.fromRGBO(30,69,62, 1) :Color(0xffd5f5e7),
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
                                          padding: EdgeInsets.only(bottom:5),
                                          child: Container(
                                            child: FutureBuilder(
                                              future: Provider.of<UserModel>(context, listen: false).
                                                GetOwnerUsername(snapshot.data[index][0].toInt()),
                                              builder: (context, snap) {
                                                if(snap.data != null){
                                                  return Ocena.ocena(snap.data, snapshot.data[index][3],snapshot.data[index][4],
                                                  snapshot.data[index][5], snapshot.data[index][2]);
                                                }
                                                else return CircularProgressIndicator();
                                              }
                                            ),
                                          ),
                                        ),
                                    );
                                  }
                                  else
                                    return CircularProgressIndicator();
                                }
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),

                        // second tab bar viiew widget ---> NEGATIVNE
                        Container(
                          color: Tema.dark ?Color.fromRGBO(92,16,16, 1) :Color(0xffd5f5e7),
                           child: Center(
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
                                                padding: EdgeInsets.only(bottom:5),
                                                child: FutureBuilder(
                                                    future: Provider.of<UserModel>(context, listen: false).
                                                    GetOwnerUsername(snapshot.data[index][0].toInt()),
                                                    builder: (context, snap) {
                                                      if(snap.data != null){
                                                        return Ocena.ocena(snap.data, snapshot.data[index][3],snapshot.data[index][4],
                                                            snapshot.data[index][5], snapshot.data[index][2]);
                                                      }
                                                      else return CircularProgressIndicator();
                                                    }
                                                ),
                                              ),
                                        );
                                      }
                                      else
                                        return CircularProgressIndicator();
                                    }
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              )
                             ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ),
          )
      );
  Brightness getBrightness() {
    return Tema.dark ? Brightness.dark : Brightness.light;
  }
  @override
  Widget build(BuildContext context) {
    String username=(ime!=null ? ime : "");
    print("Ulogovan korisnik: " + username);
    return Theme(
        data: ThemeData(
        brightness: getBrightness(),
        ),
      child: Scaffold(
        backgroundColor: Tema.dark ? darkPozadina : Colors.grey.shade200,
        appBar: AppBar(
          foregroundColor: siva2,
          title: Text(
            'MOJE OCENE:',
            style: Tema.dark ? titleStyleDarkk: titleStyleWhite,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:  Tema.dark ? <Color>[
                      zelena1,
                     crvenaGlavna
                    ]
                        :<Color>[
                  lightGreen,
                  Color.fromRGBO(255, 112, 87, 1)
                ]
                )
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height/1.25,
                padding: EdgeInsets.all(10.0),
              ),
              Column(
                children: [
                  Container(
                    child: Center(
                        child: getDefaultTabController(context)),  //getTabController(context))
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //pretvaramo listu ocena u WIDGET -->DA BI UBACILI ->LAJKOVI
  Widget getLajk(List<Ocena> Lajk) {
    List<Widget> list = [];
    for (var i = 0; i < Lajk.length; i++) {
      list.add(new Container(
          child: Ocena.ocena(Lajk[i].ime, Lajk[i].odgovor1, Lajk[i].odgovor2,
              Lajk[i].odgovor3, Lajk[i].like)));
    }
    return new Column(children: list);
  }
  //pretvaramo listu ocena u WIDGET -->DA BI UBACILI ->DISLAJKOVI
  Widget getDislajk(List<Ocena> Dislajk) {
    List<Widget> list = [];
    for (var i = 0; i < Dislajk.length; i++) {
      list.add(new Container(
          child: Ocena.ocena(Dislajk[i].ime, Dislajk[i].odgovor1, Dislajk[i].odgovor2,
              Dislajk[i].odgovor3, Dislajk[i].like)));
    }
    return new Column(children: list);
  }
}
