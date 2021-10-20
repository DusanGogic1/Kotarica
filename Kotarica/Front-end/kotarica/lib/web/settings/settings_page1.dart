import 'package:flutter/material.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/models/MarksProductModel.dart';
import 'package:kotarica/models/MarksUserModel.dart';
import 'package:kotarica/models/NotificationsModel.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/settings/location_settings.dart';
import 'package:kotarica/settings/profile_settings.dart';
import 'package:kotarica/util/Validators.dart';
import 'package:kotarica/util/form/UtilTextFormField.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:kotarica/web/registration/Welcome.dart';
import 'package:kotarica/web/settings/location_settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/credentials.dart';

/* GLAVNA STRANA ZA PODESAVANJE */

// ignore: camel_case_types
class settings_pageWeb extends StatefulWidget {
  @override
  _SettingsOnePageState createState() => _SettingsOnePageState();
}

class _SettingsOnePageState extends State<settings_pageWeb> {
  Brightness _getBrightness() {
    return Tema.dark ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    UserModelWeb userModel = Provider.of<UserModelWeb>(context, listen: false);

    return Theme(
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
        backgroundColor: Tema.dark ? null : Colors.grey.shade200,
        //PROMENA TEME
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
          ),
          elevation: 0,
          brightness: _getBrightness(),
          iconTheme:
          IconThemeData(color: Tema.dark ? Colors.white : Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            'Podešavanja',
            style: TextStyle(color: Tema.dark ? Colors.white : Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.moon),
              onPressed: () {
                setState(() {
                  Tema.dark = !Tema.dark;
                });
              },
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    sharedPrefsWidgetBuilder(builder: (context, prefs) {
                      var firstName = prefs.getString("firstname");
                      var lastName = prefs.getString("lastname");
                      var imageHash = prefs.getString("image");

                      return Card(
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
                          title: Text(
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
                            child: ipfsImageWidgetBuilder(
                              imageHash: imageHash,
                              builder: (context, imageProvider) => CircleAvatar(
                                backgroundImage: imageProvider,
                              ),
                              loadingBuilder: (context, snapshot) =>
                                  CircularProgressIndicator(),
                            ),
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
                      margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
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
                                color: Tema.dark ? Colors.white : Colors.black,
                                fontFamily: "Ubuntu",
                              ),
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: zelena1,
                            ),
                            onTap: () async {
                              bool success =
                              await _showPrivateKeyPrompt(context);
                              if (success) {
                                await _showChangePrivateKeyDialog(
                                    context, userModel);
                              }
                            },
                          ),
                          _buildDivider(),
                          ListTile(
                            leading: Icon(
                              FontAwesomeIcons.language,
                              color: zelena1,
                            ),
                            title: Text(
                              "Promeni jezik",
                              style: TextStyle(
                                color: Tema.dark ? Colors.white : Colors.black,
                                fontFamily: "Ubuntu",
                              ),
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: zelena1,
                            ),
                            onTap: () {
                              //open change language
                            },
                          ),
                          _buildDivider(),
                          ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: zelena1,
                            ),
                            title: Text(
                              "Promeni lokaciju",
                              style: TextStyle(
                                color: Tema.dark ? Colors.white : Colors.black,
                                fontFamily: "Ubuntu",
                              ),
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: zelena1,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LocationSettingsPageWeb()),
                              );
                            },
                          ),
                          _buildDivider(),
                          ListTile(
                            leading: Icon(
                              Icons.delete,
                              color: zelena1,
                            ),
                            title: Text(
                              "Obrisi nalog",
                              style: TextStyle(
                                color: Tema.dark ? Colors.white : Colors.black,
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
                    const SizedBox(height: 20.0),
                    Container(
                      width: size * 0.9,
                      child: Text(
                        "Obaveštenja",
                        style: TextStyle(
                          color: Tema.dark ? Colors.white : Colors.black,
                          fontFamily: "Ubuntu",fontSize: 20,
                        ),
                      ),
                    ),
                    SwitchListTile(
                      activeColor: Tema.dark ? Colors.white : siva2,
                      contentPadding: const EdgeInsets.all(0),
                      value: true,
                      title: Text("Primaj obaveštenja",
                        style: TextStyle(
                          color: Tema.dark ? Colors.white : plavaTekst,
                          fontFamily: "Montserrat",
                        ),
                      ),
                      onChanged: (val) {},
                    ),
                    SwitchListTile(
                      activeColor: Tema.dark ? Colors.white : siva2,
                      contentPadding: const EdgeInsets.all(0),
                      value: false,
                      title: Text("Obavesti me o novostima",
                        style: TextStyle(
                          color: Tema.dark ? Colors.white : plavaTekst,
                          fontFamily: "Montserrat",
                        ),),
                      onChanged: (val) {},
                    ),
                    SwitchListTile(
                      activeColor: Tema.dark ? Colors.white : siva2,
                      contentPadding: const EdgeInsets.all(0),
                      value: true,
                      title: Text("Obavesti me o novim ažuriranjima",
                        style: TextStyle(
                          color: Tema.dark ? Colors.white : plavaTekst,
                          fontFamily: "Montserrat",
                        ),),
                      onChanged: (val) {},
                    ),
                    const SizedBox(height: 60.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
        content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: ListBody(children: [
                Text("Unesite privatni ključ"),
                UtilTextFormField(null, privateKeyController,
                    isPasswordTextField: true,
                    validator: validatePrivateKey,
                    bottomPadding: 0,
                    maxLength: 64),
              ]),
            )),
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
              //ISPRAVII!!!!!!!
              privateKeyIsCorrect =
                  await FlutterKeychain.get(key: "privatekey") ==
                      privateKeyController.text;

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

  Future<void> _showChangePrivateKeyDialog(
      BuildContext context, UserModelWeb userModel) async {
    var privateKeyController = TextEditingController();
    var confirmPrivateKeyController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
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

                /*try {
                  await userModel.changeUserOwner(
                    context: context,
                    currentUsername: currentUsername,
                    newPrivateKey: confirmPrivateKeyController.text,
                  );
                } on OwnerNotUniqueException {
                  Navigator.of(context, rootNavigator: true).pop();
                  await showInformationAlert(context,
                      "Korisnik sa datim privatnim ključem već postoji");
                  return;
                }*/

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



  //Funkcija za alert -- brisanje naloga
  Future<void> _brisanjeNaloga() async {
    var userModel = Provider.of<UserModelWeb>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
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
                Text('Da li ste sigurni da želite da obrišete svoj nalog?'),
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
                /*bool success=await userModel.deleteUser();
                if(success) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => WelcomeWeb()),
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
}
