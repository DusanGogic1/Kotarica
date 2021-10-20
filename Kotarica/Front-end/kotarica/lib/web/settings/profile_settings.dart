import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kotarica/constants/Tema.dart';
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

class ProfileSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditPage(),
    );
  }
}

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool _emailNotUnique = false;
  bool _phoneNumberNotUnique = false;

  // static const String _cities = StringConstants.cities;
  // List<dynamic> _citiesList = json.decode(_cities);
  // List<DropdownMenuItem<String>> _citiesDropdownMenuItems;
  // String _selectedCity;

  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _phoneNumberController = TextEditingController();
  // var _personalAddressController = TextEditingController();
  // var _zipCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _imagePath;
  File _file;
  String _imageHash;

  @override
  void initState() {
    super.initState();
    // _citiesDropdownMenuItems = buildDropdownMenuItems(_citiesList);
    _setupFields();
  }

  Future<void> _setupFields() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString("city");

    _firstNameController.text = prefs.getString("firstname");
    _lastNameController.text = prefs.getString("lastname");
    _emailController.text = prefs.getString("email");
    _phoneNumberController.text = prefs.getString("phone");
    // _personalAddressController.text = prefs.getString("personalAddress");
    // if (_citiesList.contains(city)) {
    //   _selectedCity = city;
    // } else {
    //   _selectedCity = _citiesList[0];
    // }
    // _zipCodeController.text = prefs.getString("zipCode");
    _imageHash = prefs.getString("image");
  }

  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context, listen: false);

    Scaffold sc = Scaffold(
      appBar: AppBar(
        backgroundColor: Tema.dark ? zelenaDark: bela,
        foregroundColor: bela,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Tema.dark? bela : siva2,
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
        title: Text("Izmeni profil", style: TextStyle(color: Tema.dark ? bela : siva2)),
      ),
      body:
      Container(
        color: Tema.dark? Colors.blueGrey[600]: bela,
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: sharedPrefsWidgetBuilder(builder: (context, prefs) {
          String userName = prefs.getString("username");
          // String imageHash = prefs.getString("image");
          // String firstName = prefs.getString("firstname");
          // String lastName = prefs.getString("lastname");
          // String email = prefs.getString("email");
          // String phone = prefs.getString("phone");
          String personalAddress = prefs.getString("personalAddress");
          String city = prefs.getString("city");
          String zipCode = prefs.getString("zipCode");


          return Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      ipfsImageWidgetBuilder(
                          imageHash: _imageHash,
                          builder: (context, imageProvider) {
                            return Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.1),
                                        offset: Offset(0, 10))
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: (_imagePath != null
                                        ? Image.file(File(_imagePath)).image
                                        : imageProvider
                                    ),
                                  )),
                            );
                          }),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color:
                                Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: zelena1,
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                await _pickImage();
                                FocusScope.of(context).unfocus();
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          )),
                      (_file == null ? null
                          : Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color:
                                Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: crvenaGlavna,
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _file = null;
                                  _imagePath = null;
                                });
                                FocusScope.of(context).unfocus();
                              },
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            )
                        ),
                      )
                      ),
                    ].where((Object element) => element != null).toList(),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                UtilTextFormField("Ime", _firstNameController),
                UtilTextFormField("Prezime", _lastNameController),
                UtilTextFormField("E-mail", _emailController, validator: validateEmail, errorText: _emailNotUnique ? "E-mail adresa već postoji" : null),
                UtilTextFormField("Broj telefona", _phoneNumberController, validator: validatePhoneNumber, errorText: _phoneNumberNotUnique ? "Broj telefona već postoji" : null),
                // _buildTextFormField("Adresa", _personalAddressController),
                // // Grad
                // Container(
                //   padding: const EdgeInsets.only(bottom: 35.0),
                //   child: DropdownButtonFormField(
                //     icon: Icon(
                //       // Add this
                //       Icons.arrow_drop_down, // Add this
                //       color: Colors.grey, // Add this
                //     ),
                //     decoration: InputDecoration(
                //       // contentPadding: EdgeInsets.all(size * 0.05),
                //       border: UnderlineInputBorder(
                //         borderSide: BorderSide(
                //           color: Colors.grey,
                //         ),
                //       ),
                //       // prefixIcon: Icon(
                //       //   Icons.home,
                //       //   color: siva2,
                //       // ),
                //       focusedBorder: OutlineInputBorder(
                //         //borderRadius: BorderRadius.all(Radius.circular(20.0)),
                //           borderSide: BorderSide(
                //             color: Colors.blue[900],
                //           )),
                //       enabledBorder: OutlineInputBorder(
                //         //borderRadius: BorderRadius.all(Radius.circular(20.0)),
                //         borderSide: BorderSide(
                //           color: Colors.grey,
                //         ),
                //       ),
                //       errorBorder: OutlineInputBorder(
                //         //borderRadius: BorderRadius.all(Radius.circular(20.0)),
                //           borderSide: BorderSide(color: Colors.red)),
                //       labelText: "Grad",
                //       labelStyle: TextStyle(fontWeight: FontWeight.bold),
                //       floatingLabelBehavior: FloatingLabelBehavior.always,
                //     ),
                //     value: _selectedCity,
                //     items: _citiesDropdownMenuItems,
                //     onChanged: (value) {
                //       setState(() {
                //         _selectedCity = value;
                //       });
                //     },
                //   ),
                // ),
                // UtilTextFormField("Poštanski broj", _zipCodeController),

                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineButton(
                      //  padding: EdgeInsets.symmetric(horizontal: 30),
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
                    // ignore: deprecated_member_use
                    SizedBox(width: 40,),
                    RaisedButton(
                      onPressed: () async {
                        if(!_formKey.currentState.validate()) {
                          return;
                        }

                        setState(() {
                          _emailNotUnique = false;
                          _phoneNumberNotUnique = false;
                        });
                        bool success = false;
                        showLoadingDialog(context);

                        if(_file != null) {
                          String hash = await _uploadImageFile();
                          setState(() {
                            _imageHash = hash;
                            _file = null;
                            _imagePath = null;
                          });
                        }

                        try {
                          await userModel.updateUserInfo(
                            currentUserName: userName,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            email: _emailController.text,
                            phoneNumber: _phoneNumberController.text,
                            personalAddress: personalAddress,
                            city: city,
                            zipCode: zipCode,
                            ipfsImageHash: _imageHash,
                          );

                          success = true;
                        } on EmailNotUniqueException {
                          setState(() {
                            _emailNotUnique = true;
                          });
                        } on PhoneNumberNotUniqueException {
                          setState(() {
                            _phoneNumberNotUnique = true;
                          });
                        }

                        Navigator.of(context, rootNavigator: true).pop();
                        if(!success) {
                          return;
                        }

                        await showInformationAlert(context, 'Promena podataka je uspešna.');
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
          );
        }),
      ),
    );
    return sc;
  }

  // List<DropdownMenuItem<String>> buildDropdownMenuItems(
  //     List<dynamic> citiesList) {
  //   List<DropdownMenuItem<String>> items = List();
  //   for (String city in citiesList) {
  //     items.add(
  //       DropdownMenuItem(
  //         child: Text(
  //           city,
  //           style: TextStyle(
  //             fontFamily: 'Montserrat',
  //             fontWeight: FontWeight.bold,
  //             color: siva2,
  //           ),
  //         ),
  //         value: city,
  //       ),
  //     );
  //   }
  //
  //   return items;
  // }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    var pickedImage =
    await picker.getImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedImage == null) {
      return;
    }

    File pickedImage1 = await ImageCropper.cropImage(
        sourcePath: pickedImage.path,
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        aspectRatioPresets: [CropAspectRatioPreset.square]);
    if (pickedImage1 == null) {
      return;
    }

    setState(() {
      _imagePath = pickedImage1.path;
      _file = File(pickedImage1.path);
    });
  }

  Future<String> _uploadImageFile() async {
    assert(_file != null);
    String base64Image = base64Encode(_file.readAsBytesSync());
    String fileName = _file.path.split("/").last;

    final http.Client _client = http.Client();
    var response = await _client.post(NetworkConstants.nodeEndpointUpload, body: {
      "image": base64Image,
      "name": fileName,
    });

    assert (response.statusCode == 200);
    var decoded = json.decode(response.body);
    String hash = decoded['hash'];
    // print("IMAGE HASH IMAGE HASH IMAGE HASH IMAGE HASH IMAGE HASH IMAGE HASH IMAGE HASH IMAGE HASH IMAGE HASH IMAGE HASH IMAGE HASH: $hash");
    return hash;
  }
}
