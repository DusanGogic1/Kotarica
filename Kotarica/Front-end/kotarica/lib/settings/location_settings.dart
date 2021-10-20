import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kotarica/util/form/UtilTextFormField.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/settings/settings_page1.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/constants/strings.dart';
import 'package:kotarica/constants/network.dart';
import 'package:kotarica/util/Validators.dart';

class LocationSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditLocationPage(),
    );
  }
}

class EditLocationPage extends StatefulWidget {
  @override
  _EditLocationPageState createState() => _EditLocationPageState();
}

class _EditLocationPageState extends State<EditLocationPage> {
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

  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context, listen: false);

    Scaffold sc = Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: siva2,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => settings_page(),
              ),
            );
          },
        ),
        title: Text("Promeni lokaciju", style: TextStyle(color: siva2)),
      ),
      body: Container(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => settings_page(),
                          ),
                        );
                      },
                      child: Text("PONIŠTI",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.black)),
                    ),
                    SizedBox(width: 30,),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      onPressed: () async {
                        if(!_formKey.currentState.validate()) {
                          return;
                        }

                        showLoadingDialog(context);

                        await userModel.updateUserInfo(
                          currentUserName: userName,
                          firstName: firstName,
                          lastName: lastName,
                          email: email,
                          phoneNumber: phoneNumber,
                          personalAddress: _personalAddressController.text,
                          city: _selectedCity,
                          zipCode: _zipCodeController.text,
                          ipfsImageHash: imageHash,
                        );

                        Navigator.of(context, rootNavigator: true).pop();

                        await showInformationAlert(context, 'Promena podataka je uspešna.');
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
    );
    return sc;
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
}
