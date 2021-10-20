import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/models/MarksProductModel.dart';
import 'package:kotarica/models/MarksUserModel.dart';
import 'package:kotarica/models/NotificationsModel.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/registration/RegistrationPageOne.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/util/Validators.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
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

class _State extends State<Welcome> {
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
        child: Container(
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top:size*0.01,left:size*0.1,right: size*0.05),
              child: Image(
                image: AssetImage('images/welcome.png'),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),


            /* ---- FORMA ZA LOGIN ----- */
            Container(
              padding: EdgeInsets.only(left: size*0.07, right: size*0.07),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    /* ---- KORISNICKO IME ---- */
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp('[ ]')),
                      ],
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
                    SizedBox(
                      height: 20.0,
                    ),
                    /*---- PRIVATNI KLJUČ -----*/
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp('[ ]')),
                      ],
                      textInputAction: TextInputAction.next,
                      controller: _privateKeyController,
                      validator: validatePrivateKey,
                      decoration: InputDecoration(
                          labelText: 'PRIVATNI KLJUČ',
                          labelStyle:  TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: zelena1,
                              fontSize: 20.0
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
                        alignment: Alignment(1.0, 1.0),
                        padding: EdgeInsets.only(top: size*0.02, left:size*0.2),
                        child: InkWell(
                          child: Text(
                            'Zaboravljen privatni ključ',
                            style: TextStyle(
                                color: zelena1,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                decoration: TextDecoration.underline),
                          ),
                        )),*/
                    SizedBox(
                      height: 30.0,
                    ),
                    /* ---- DUGME PRIJAVI SE ---- */
                    Container(
                      height: size*0.1,
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

                              if(_privateKeyController.text.isNotEmpty && _formKey.currentState.validate()) {
                                await _performLogin(_usernameController.text,
                                    _privateKeyController.text);
                              }
                            },
                            child: Text("PRIJAVITE SE",
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // //dugme nastavi kao gost
                    // Container(
                    //   height: size*0.1,
                    //   //width: size*0.7,
                    //   child: Material(
                    //     borderRadius: BorderRadius.circular(20.0),
                    //     color: svetloZuta,
                    //     elevation: 7.0,
                    //     child: SizedBox(
                    //       width: double.maxFinite,
                    //       child: ElevatedButton(
                    //         style: ButtonStyle(
                    //           shape: MaterialStateProperty.all<OutlinedBorder>(
                    //             RoundedRectangleBorder(
                    //               borderRadius:
                    //               BorderRadius.all(Radius.circular(20.0)),
                    //             ),
                    //           ),
                    //           backgroundColor:
                    //           MaterialStateProperty.resolveWith<Color>(
                    //                   (Set<MaterialState> states) {
                    //                 return crvenaGlavna;
                    //               }),
                    //         ),
                    //         onPressed: () async {
                    //         },
                    //         child: Text("NASTAVI KAO GOST",
                    //             style: TextStyle(
                    //                 fontFamily: "Montserrat",
                    //                 color: Colors.white)),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                                  builder: (context) => RegistrationPageOne()),
                            );
                          },
                          child: Text('Registracija',
                              style: TextStyle(
                                  color: zelena1,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline)),
                        )
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
    var userModel = Provider.of<UserModel>(context, listen: false);
    var productModel = Provider.of<ProductModel>(context, listen: false);
    var marksProductModel = Provider.of<MarksProductModel>(context, listen: false);
    var marksUserModel = Provider.of<MarksUserModel>(context, listen: false);
    var notificationsModel = Provider.of<NotificationsModel>(context, listen: false);
    var size = MediaQuery.of(context).size.width;
    showLoadingDialog(context);
    await userModel.initiateSetup(_privateKeyController.text);

    String token = await userModel.login(username);
    if (token != null) {
      /* INICJALIZACIJA OSTALIH MODELA AKO JE LOGOVANJE PROSLO */
      for (dynamic model in getModelsList(context)) {
          await model.initiateSetup(_privateKeyController.text);
      }
      /* ... */

      var prefs = await SharedPreferences.getInstance();

      await userModel.savePrivateKey(_privateKeyController.text);
      notificationsModel.setUserId(prefs.getInt("id"));

      Navigator.of(context, rootNavigator: true).pop();

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
      //Navigator.push(
          //context,
          //MaterialPageRoute(
              //builder: (context) => HomeScreen()));//HomePage.fromBase64(token)));
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      _wrongPKUsername();
    }
    // Navigator.of(context).pop();
    //MaterialPageRoute( builder: (context) => HomeScreen());
  }
}
