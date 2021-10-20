/*
  TODO: Srediti Dropdownbutton
*/

import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:kotarica/constants/strings.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/registration/Welcome.dart';

class RegistrationPageTwo extends StatefulWidget {
  final String username;
  final String _privateKey;
  final String _confirmPrivateKey;
  final String email;
  final String phone;
  final String image;

  RegistrationPageTwo({
    @required this.username,
    @required String privateKey,
    @required String confirmPrivateKey,
    @required this.email,
    @required this.phone,
    @required this.image,
  }) : _privateKey = privateKey, _confirmPrivateKey = confirmPrivateKey;

  @override
  _State createState() => _State(
        username: username,
        privateKey: _privateKey,
        confirmPrivateKey: _confirmPrivateKey,
        email: email,
        phone: phone,
        image: image,
      );
}

class _State extends State<RegistrationPageTwo> {
  final _formKey = GlobalKey<FormState>();

  String username;
  String _privateKey;
  String _confirmPrivateKey;
  String email;
  String phone;
  String image;

  final firstnameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();

  static const String cities = StringConstants.cities;
  List<dynamic> citiesList = json.decode(cities);

  _State(
      {this.username,
      String privateKey,
      String confirmPrivateKey,
      this.email,
      this.phone,
      this.image}) : _privateKey = privateKey, _confirmPrivateKey = confirmPrivateKey;

  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String _selectedItem;

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropdownMenuItems(citiesList);
    _selectedItem = citiesList[0];
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
              color: zelena1,
            ),
          ),
          value: city,
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context, listen: false);
    var size = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: Container(
        child: Scaffold(
          // backgroundColor: Colors.transparent,
          // resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    /* ----- IME -----*/
                    Container(
                      padding: EdgeInsets.only(
                          left: size * 0.02,
                          right: size * 0.02,
                          top: size * 0.15),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp('[ ]')),
                        ],
                        textInputAction: TextInputAction.next,
                        controller: firstnameController,
                        autofocus: false,
                        validator: (value) {
                          if (value.isEmpty) return "Ime mora biti uneto";
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(size * 0.05),
                          prefixIcon: Icon(
                            Icons.text_rotation_none,
                            color: zelena1,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                color: Colors.blue[900],
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                color: zelena1,
                              )),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(color: Colors.red)),
                          labelText: 'Ime',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: zelena1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size * 0.04),
                    /* ---- PREZIME ----- */
                    Container(
                      padding: EdgeInsets.only(
                        left: size * 0.02,
                        right: size * 0.02,
                      ),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp('[ ]')),
                        ],
                        textInputAction: TextInputAction.next,
                        controller: lastNameController,
                        autofocus: false,
                        validator: (value) {
                          if (value.isEmpty) return "Prezime mora biti uneto";
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(size * 0.05),
                          prefixIcon: Icon(
                            Icons.text_rotation_none,
                            color: zelena1,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                color: Colors.blue[900],
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                color: zelena1,
                              )),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(color: Colors.red)),
                          labelText: 'Prezime',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: zelena1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size * 0.04),
                    /*----- ADRESA -----*/
                    Container(
                      padding: EdgeInsets.only(
                        left: size * 0.02,
                        right: size * 0.02,
                      ),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: addressController,
                        autofocus: false,
                        validator: (value) {
                          if (value.isEmpty) return "Adresa mora biti uneta";
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(size * 0.05),
                          prefixIcon: Icon(
                            Icons.home,
                            color: zelena1,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                color: Colors.blue[900],
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                color: zelena1,
                              )),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(color: Colors.red)),
                          labelText: 'Adresa',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: zelena1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size * 0.04),
                    /* ----- GRAD ---- */
                    Container(
                      padding: EdgeInsets.only(
                        left: size * 0.02,
                        right: size * 0.02,
                      ),
                      child: DropdownButtonFormField(
                        icon: Icon(
                          // Add this
                          Icons.arrow_drop_down, // Add this
                          color: zelena1, // Add this
                        ),
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.all(size * 0.05),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: zelena1,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.home,
                            color: zelena1,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                color: Colors.blue[900],
                              )),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(
                              color: zelena1,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                        value: _selectedItem,
                        items: _dropdownMenuItems,
                        onChanged: (value) {
                          setState(() {
                            _selectedItem = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: size * 0.04),
                    /* ----- POSTANSKI BROJ-----*/
                    Container(
                      padding: EdgeInsets.only(
                        left: size * 0.02,
                        right: size * 0.02,
                      ),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: zipCodeController,
                        autofocus: false,
                        validator: (value) {
                          if (value.isEmpty)
                            return "Poštanski broj mora biti unet";
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(RegExp('[ ]')),
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(size * 0.05),
                          prefixIcon: Icon(
                            Icons.location_city,
                            color: zelena1,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                color: Colors.blue[900],
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                color: zelena1,
                              )),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(color: Colors.red)),
                          labelText: 'Postanski broj',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: zelena1,
                          ),
                        ),
                      ),
                    ),
                    //ss
                    SizedBox(height: size * 0.04),
                    /*----- REGISTRUJ SE-----*/
                    Container(
                      padding:
                          EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: SizedBox(
                                height: size * 0.1,
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                      return zelena1;
                                    }),
                                  ),
                                  onPressed: () async {
                                    // if (_formKey.currentState.validate()) {
                                    //   if (password.compareTo(confirmpassword) !=
                                    //       0) //razlikuju se sifre
                                    //     _diffrentpasword();
                                    //   else {
                                    //     _PopUpPrivateKey(
                                    //         username,
                                    //         password,
                                    //         firstnameController.text,
                                    //         lastNameController.text,
                                    //         addressController.text,
                                    //         phone,
                                    //         email,
                                    //         _selectedItem,
                                    //         zipCodeController.text,
                                    //         image);
                                    //   }
                                    // }

                                    var userModel = Provider.of<UserModel>(context, listen: false);
                                    var size = MediaQuery.of(context).size.width;

                                    await userModel.initiateSetup(_confirmPrivateKey);

                                    var answer = await userModel.register(
                                        username,
                                        firstnameController.text,
                                        lastNameController.text,
                                        addressController.text,
                                        phone,
                                        email,
                                        _selectedItem,
                                        zipCodeController.text,
                                        image);

                                    await userModel.resetPrivateKey(); // privateKey = ""
                                    if (answer == 0) //uspesna registracija
                                      _successfulregistration();
                                    else if (answer == 1) //zauzet username
                                      _reservedUsername();
                                    else if (answer == 2) //zauzet email
                                      _reservedemail();
                                    else if (answer == 3) // zauzet broj telefona
                                      _reservedPhoneNumber();

                                    // Navigator.of(context).pop();
                                    //MaterialPageRoute( builder: (context) => HomeScreen());
                                  },
                                  child: Text(
                                    "REGISTRUJ SE",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Funkcija za alert -- zauzet username
  Future<void> _reservedUsername() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Neuspena registracija',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Vec postoji korisnik sa navedenim korisnickim imenom'),
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
                'Pokusajte ponovo',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//Funkcija za alert -->zauzet email
  Future<void> _reservedemail() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Neuspena registracija',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Vec postoji korisnik sa navedenim imejlom'),
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
                'Pokusajte ponovo',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Funkcija za alert -- zauzet broj telefona
  Future<void> _reservedPhoneNumber() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Neuspena registracija',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Vec postoji korisnik sa navedenim brojem telefona'),
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
                'Pokusajte ponovo',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Funkcija za alert -->Uspesna registracija
  Future<void> _successfulregistration() async {
    var userModel = Provider.of<UserModel>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Uspesna registracija',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(' '),
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
                'Povratak na pocetak',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Welcome()));
              },
            ),
          ],
        );
      },
    );
  }

  //Funkcija za alert -->Ne poklapaju se sifre
  // Future<void> _diffrentpasword() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Neuspesna registracija',
  //           style: TextStyle(
  //             color: zelena1,
  //             fontFamily: "Montserrat",
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('Lozinke se ne poklapaju!'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               primary: zelena1,
  //               onPrimary: Colors.white,
  //             ),
  //             child: Text(
  //               'Pokusaj opet',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontFamily: "Montserrat",
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  //POP UP ZA KEY
  // Future<void> _PopUpPrivateKey(
  //     String username,
  //     String password,
  //     String firstname,
  //     String lastname,
  //     String address,
  //     String phone,
  //     String email,
  //     String selectedItem,
  //     String zipcode,
  //     String image) async {
  //   TextEditingController _privateKeyController = new TextEditingController();
  //
  //   var userModel = Provider.of<UserModel>(context, listen: false);
  //   var size = MediaQuery.of(context).size.width;
  //
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //         // title: Text(
  //         //   'Filtiranje pretrage',
  //         //   style: TextStyle(
  //         //     fontSize: 12.0,
  //         //     color: zelena1,
  //         //     fontFamily: "Montserrat",
  //         //     fontWeight: FontWeight.bold,
  //         //   ),
  //         // ),
  //         content: SingleChildScrollView(
  //           child: ListBody(children: <Widget>[
  //             Text(
  //               "Unesite privatni ključ",
  //               style: TextStyle(
  //                   color: zelena1,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 25),
  //             ),
  //             SizedBox(
  //               height: 30,
  //             ),
  //             Column(
  //               children: [
  //                 TextFormField(
  //                   enableInteractiveSelection: true,
  //                   controller: _privateKeyController,
  //                   cursorColor: Theme.of(context).cursorColor,
  //                   maxLength: 64,
  //                   decoration: InputDecoration(
  //                     prefixIcon: Icon(
  //                       Icons.vpn_key,
  //                       color: zelena1,
  //                       size: 25.0,
  //                     ),
  //                     enabledBorder: UnderlineInputBorder(
  //                       borderSide: BorderSide(color: zelena1),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ]),
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(18)),
  //             color: zelena1,
  //             onPressed: () async {
  //               await userModel.initiateSetup(_privateKeyController.text);
  //
  //               var answer = await userModel.register(
  //                   username,
  //                   password,
  //                   firstname,
  //                   lastname,
  //                   address,
  //                   phone,
  //                   email,
  //                   selectedItem,
  //                   zipcode,
  //                   image);
  //
  //               await userModel.resetPrivateKey(); // privateKey = ""
  //               if (answer == 0) //uspesna registracija
  //                 _successfulregistration();
  //               else if (answer == 1) //zauzet username
  //                 _reservedUsername();
  //               else if (answer == 2) //zauzet email
  //                 _reservedemail();
  //               else if (answer == 3) // zauzet broj telefona
  //                 _reservedPhoneNumber();
  //
  //               // Navigator.of(context).pop();
  //               //MaterialPageRoute( builder: (context) => HomeScreen());
  //             },
  //             child: Text(
  //               "Potvrdi".toUpperCase(),
  //               style: TextStyle(
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
