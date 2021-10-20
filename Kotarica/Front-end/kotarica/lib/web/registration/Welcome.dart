import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/models/NotificationsModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/util/Validators.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:kotarica/web/WebModels/MarksUserModelWeb.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:kotarica/web/home/HomeScreen.dart';
import 'package:kotarica/web/registration/RegistrationPageOneWeb.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeWeb extends StatefulWidget {
/*  final String username;
  final String password;

  Welcome({
    @required this.username,
    @required this.password,
  }); */

  @override
  _State createState() => _State(
    /*username: username,
        password: password,*/
  );
}

class _State extends State<WelcomeWeb> {
  // String username;
  // String password;

  final _usernameController = TextEditingController();
  final _privateKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // _State({this.username, this.password});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          alignment: Alignment.topCenter,
          width: size * 0.65,
          //height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(left:size*0.15,right: size*0.05),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(left:size*0.15,right: size*0.05),
                child: Image(
                  width: size * 0.4,
                  //height: size * 0.4,
                  image: AssetImage('images/welcome.png'),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),


            /* ---- FORMA ZA LOGIN ----- */
            Container(
             // width: size * 0.5,
              //height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(left: size*0.07, right: size*0.07),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    /* ---- KORISNICKO IME ---- */
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _usernameController,
                      validator: validateUsername,
                      decoration: InputDecoration(
                          labelText: 'KORISNIČKO IME',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: zelena1,
                              fontSize: 20.0
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: zelena1 ))),
                    ),
                   // SizedBox(
                      //height: 20.0,
                    //),
                    /*---- PRIVATNI KLJUČ -----*/
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _privateKeyController,
                      validator: validatePrivateKey,
                      decoration: InputDecoration(
                          labelText: 'PRIVATNI KLJUČ',
                          labelStyle:  TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: zelena1,
                              fontSize: 18.0
                          ),
                          errorMaxLines: 2,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue))),
                      obscureText: true,
                      maxLength: 64,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    /*----ZABORAVLJEN PRIVATNI KLJUČ-----
                    Container(
                        //height: MediaQuery.of(context).size.height * 0.01,
                        alignment: Alignment(1.0, 1.0),
                        padding: EdgeInsets.only(left:size*0.2),
                        child: InkWell(
                          child: Text(
                            'Zaboravljen privatni ključ',
                            style: TextStyle(
                               // fontSize: size*0.01,
                                color: zelena1,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                decoration: TextDecoration.underline),
                          ),
                        )),*/
                    SizedBox(
                      height: 20.0,
                    ),
                    /* ---- DUGME PRIJAVI SE ---- */
                    Container(
                      //height: size*0.1,
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: svetloZuta,
                        elevation: 7.0,
                        child: SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                              backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    return zelena1;
                                  }),
                            ),
                            onPressed: () async {
                              // _PopUpPrivateKey(usernameController.text, passwordController.text); //--> POP UP ZA PRIVATE KEY

                              if(_privateKeyController.text.isNotEmpty &&  _formKey.currentState.validate()) {
                                await _performLogin(_usernameController.text,
                                    _privateKeyController.text);
                              }
                            },
                            child: Text("PRIJAVITE SE",
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.white,
                                    //fontSize: 10
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //dugme nastavi kao gost
                    /*Container(
                      height: size*0.1,
                      //width: size*0.7,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: svetloZuta,
                        elevation: 7.0,
                        child: SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                              backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    return crvenaGlavna;
                                  }),
                            ),
                            onPressed: () async {
                            },
                            child: Text("NASTAVI KAO GOST",
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ),*/
                    SizedBox(
                      height: 20,
                    ),

                    /* ---- DEO ZA REGISTRACIJU----*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Novi na Kotarici ?",
                          style: TextStyle(
                            color: zelena1,
                            fontFamily: "Montserrat",
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationPageOneWeb()),
                            );
                          },
                          child: Text('Registracija',
                              style: TextStyle(
                                  color: zelena1,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline)),
                        ),
                        SizedBox(height:10),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
      backgroundColor: bela,
    );
  }

  //Funkcija za alert
  Future<void> _wrongPKUsername() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Neuspešno prijavljivanje',
            style: TextStyle(
              color: Colors.red[900],
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Pogrešan privatni ključ ili korisničko ime'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red[900],
                onPrimary: Colors.white,
              ),
              child: Text(
                'Pokušaj ponovo',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogin(String username, String privateKey) async {
    var userModel = Provider.of<UserModelWeb>(context, listen: false);
     var productModel = Provider.of<ProductModelWeb>(context, listen: false);
    // var marksProductModel = Provider.of<MarksProductModel>(context, listen: false);
     var marksUserModel = Provider.of<MarksUserModelWeb>(context, listen: false);
    var notificationsModel = Provider.of<NotificationsModel>(context, listen: false);

    var size = MediaQuery.of(context).size.width;

    showLoadingDialog(context);

    await userModel.initiateSetup(_privateKeyController.text);

    String token = await userModel.login(username);
    if (token != null) {

      /* INICJALIZACIJA OSTALIH MODELA AKO JE LOGOVANJE PROSLO */
      for (dynamic model in getModelsListWeb(context)) {
          await model.initiateSetup(_privateKeyController.text);
      }

      var prefs = await SharedPreferences.getInstance();

      await userModel.savePrivateKey(_privateKeyController.text);
      notificationsModel.setUserId(prefs.getInt("id"));

      Navigator.of(context, rootNavigator: true).pop();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreenWeb()),
              (Route<dynamic> route) => false);
      //Navigator.pushAndRemoveUntil(context,
          //MaterialPageRoute(builder: (_) => HomeScreenWeb()), (Dynamic<route> route) => false);
      //Navigator.push(
          //context,
          //MaterialPageRoute(
              //builder: (context) => HomeScreenWeb()));//HomePage.fromBase64(token)));
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      _wrongPKUsername();
    }
    // Navigator.of(context).pop();
    //MaterialPageRoute( builder: (context) => HomeScreen());
  }


}
