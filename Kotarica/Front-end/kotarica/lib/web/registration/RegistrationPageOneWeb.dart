import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:kotarica/util/Validators.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/network.dart';
import 'package:kotarica/constants/style.dart';
import 'package:http/http.dart' as http;
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:provider/provider.dart';

import '../../constants/strings.dart';
import 'Welcome.dart';

String hashCode = "QmZws7HW1TZVP54LfoKRLWVDtfrk2nUz3MYCJKU67HtkG2";

class RegistrationPageOneWeb extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<RegistrationPageOneWeb> {
  final _formKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  String username;

  // String password;
  // String confirmpassword;
  String email;
  String phone;
  Image image = Image.asset("images/profilna");

  Uint8List data = null;
  String error;
  String name;

  final firstnameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();
  final usernameController = TextEditingController();
  final _privateKeyController = TextEditingController();
  final _confirmPrivateKeyController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  static const String cities = StringConstants.cities;
  List<dynamic> citiesList = json.decode(cities);

  _State(
      {this.username,
      // this.password,
      // this.confirmpassword,
      this.email,
      this.phone,
      this.image});

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

  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  File file;

  void _pickImage() async {
    data = await ImagePickerWeb.getImage(outputType: ImageType.bytes);
    Image fromPicker = Image.memory(data);
    if(fromPicker!=null){
      setState(() {
        image = fromPicker;
        _upload();
      });
    }
  }

  void _upload() async {
    String base64Image = base64Encode(data);
    String fileName = "Neki naziv";

    final http.Client _client = http.Client();
    var response =
        await _client.post(NetworkConstants.nodeEndpointUpload, body: {
      "image": base64Image,
      "name": fileName,
    }, headers: {
      "Access-Control-Allow-Origin": "*"
    });

    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      hashCode = decoded['hash'];
      print(hashCode);
    } else
      print("Response: " + response.statusCode.toString());
  }
  var isFirstScreen = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Container(
        width: size * 0.5,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: Center(
                    child: Column(children: <Widget>[
                /* --- SLIKA ----- */
                      Container(
                      width: size * 0.75,
                      padding: EdgeInsets.only(
                        left: size * 0.25,
                        right: size * 0.25,
                      ),
                        child: Center(
                          child: Container(
                            width: 190,
                            height: 190,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                        image: image!=null?image.image:Image.asset("images/profilna.jpg").image,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: size * 0.01,
                      ),
                /* ---- KORISNICKO IME ----*/
                      Container(
                        width: size * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                          Theme(
                            data: ThemeData(
                                accentColor: Colors.red,
                                primarySwatch: Colors.red,
                                colorScheme:
                                    ColorScheme.light(primary: Colors.red)),
                            child: Stepper(
                              type: stepperType,
                              physics: ScrollPhysics(),
                              currentStep: _currentStep,
                              onStepTapped: (step) => tapped(step),
                              onStepContinue: () {
                                setState(() {
                                  if (_formKeys[_currentStep].currentState.validate()) {
                                    _currentStep++;
                                  }
                                });
                              },
                              onStepCancel: cancel,
                              controlsBuilder: (BuildContext context,
                                  {VoidCallback onStepContinue,
                                  VoidCallback onStepCancel}) {
                                if(_currentStep==3)
                                return SizedBox();
                                else
                                  return Row(
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: continued2,
                                      color: zelena1,
                                      child: const Text('DALJE',
                                          style: TextStyle(color: Colors.white)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    FlatButton(
                                      //    onPressed: onStepCancel,
                                      onPressed: isFirstScreen
                                          ? null
                                          : onStepCancel,
                                      // <-- important part
                                      color: Colors.white,
                                      child: Text('NAZAD',
                                          style: TextStyle(color: zelena1)),
                                    ),
                                  ],
                                );
                              },
                              steps: <Step>[
                                Step(
                                  title: new Text("Nalog"),
                                  content: Form(
                                    key: _formKeys[0],
                                    child: Column(
                                      children: [
                                        SizedBox(height: 3),
                                        Container(
                                          height: size * 0.065,
                                          width: size * 0.65,
                                          padding: EdgeInsets.only(
                                            left: size * 0.05,
                                            right: size * 0.05,
                                          ),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  RegExp('[ ]')),
                                            ],
                                            validator: validateUsername,
                                            textInputAction: TextInputAction.next,
                                            controller: username == null
                                                ? usernameController
                                                : usernameController
                                                    .value = TextEditingController
                                                        .fromValue(
                                                            TextEditingValue(
                                                                text: username))
                                                    .value,
                                            autofocus: false,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.account_circle_rounded,
                                                color: zelena1,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: Colors.blue[900],
                                                  )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: zelena1,
                                                  )),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red)),
                                              labelText: 'Korisničko ime',
                                              labelStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: zelena1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        /* ------ PRIVATNI KLJUČ -----*/
                                        Container(
                                          height: size * 0.065,
                                          width: size * 0.65,
                                          padding: EdgeInsets.only(
                                            left: size * 0.05,
                                            right: size * 0.05,
                                          ),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  RegExp('[ ]')),
                                            ],
                                            textInputAction: TextInputAction.next,
                                            controller: _privateKeyController,
                                            autofocus: false,
                                            obscureText: true,
                                            validator: validatePrivateKey,
                                            maxLength: 64,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.lock_outline,
                                                color: zelena1,
                                              ),
                                              suffixIcon: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                                                mainAxisSize: MainAxisSize.min, // added line
                                                children: <Widget>[
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.info,
                                                      color: zelena1,
                                                    ),
                                                    onPressed: _infoPK,
                                                  ),
                                                ],
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: Colors.blue[900],
                                                  )),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0)),
                                                borderSide: BorderSide(
                                                  color: zelena1,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red)),
                                              labelText: 'Privatni ključ',
                                              labelStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: zelena1,
                                              ),
                                              errorMaxLines: 2,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        /* ----- POTVRDA PRIVATNOG KLJUČA ----*/
                                        Container(
                                          height: size * 0.065,
                                          width: size * 0.65,
                                          padding: EdgeInsets.only(
                                            left: size * 0.05,
                                            right: size * 0.05,
                                          ),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  RegExp('[ ]')),
                                            ],
                                            textInputAction: TextInputAction.next,
                                            controller:
                                                _confirmPrivateKeyController,
                                            obscureText: true,
                                            autofocus: false,
                                            validator: (value) =>
                                                validatePrivateKey(value) ??
                                                validateConfirmPrivateKey(value,
                                                    _privateKeyController.text),
                                            maxLength: 64,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.lock_outline,
                                                color: zelena1,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: Colors.blue[900],
                                                  )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide:
                                                      BorderSide(color: zelena1)),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red)),
                                              labelText:
                                                  'Potvrda privatnog ključa',
                                              labelStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: zelena1,
                                              ),
                                              errorMaxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  isActive: true,
                                  state: _currentStep == 0
                                      ? StepState.editing
                                      : StepState.complete,
                                ),
                                Step(
                                  title: new Text("Lični podaci"),
                                  content: Form(
                                    key: _formKeys[1],
                                    child: Column(
                                      children: [
                                        /* ---- EMAIL -----*/
                                        SizedBox(height: 3),
                                        Container(
                                          height: size * 0.048,
                                          width: size * 0.65,
                                          padding: EdgeInsets.only(
                                            left: size * 0.05,
                                            right: size * 0.05,
                                          ),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  RegExp('[ ]')),
                                            ],
                                            textInputAction: TextInputAction.next,
                                            controller: email == null
                                                ? emailController
                                                : emailController.value =
                                                    TextEditingController
                                                            .fromValue(
                                                                TextEditingValue(
                                                                    text: email))
                                                        .value,
                                            autofocus: false,
                                            validator: validateEmail,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.mail,
                                                color: zelena1,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: Colors.blue[900],
                                                  )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: zelena1,
                                                  )),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red)),
                                              labelText: 'Email adresa',
                                              labelStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: zelena1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          height: size * 0.048,
                                          width: size * 0.65,
                                          padding: EdgeInsets.only(
                                            left: size * 0.05,
                                            right: size * 0.05,
                                          ),
                                          child: TextFormField(
                                            textInputAction: TextInputAction.next,
                                            controller: phone == null
                                                ? phoneController
                                                : phoneController.value =
                                                    TextEditingController
                                                            .fromValue(
                                                                TextEditingValue(
                                                                    text: phone))
                                                        .value,
                                            autofocus: false,
                                            validator: validatePhoneNumber,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              FilteringTextInputFormatter.deny(
                                                  RegExp('[ ]')),
                                            ],
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.call,
                                                color: zelena1,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: Colors.blue[900],
                                                  )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: zelena1,
                                                  )),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red)),
                                              labelText: 'Broj telefona',
                                              labelStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: zelena1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          height: size * 0.048,
                                          width: size * 0.65,
                                          padding: EdgeInsets.only(
                                            left: size * 0.05,
                                            right: size * 0.05,
                                          ),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  RegExp('[ ]')),
                                            ],
                                            textInputAction: TextInputAction.next,
                                            controller: firstnameController,
                                            autofocus: false,
                                            validator: (value) {
                                              if (value.isEmpty)
                                                return "Ime mora biti uneto";
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.text_rotation_none,
                                                color: zelena1,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: Colors.blue[900],
                                                  )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: zelena1,
                                                  )),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red)),
                                              labelText: 'Ime',
                                              labelStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: zelena1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        /* ---- PREZIME ----- */
                                        Container(
                                          height: size * 0.048,
                                          width: size * 0.65,
                                          padding: EdgeInsets.only(
                                            left: size * 0.05,
                                            right: size * 0.05,
                                          ),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  RegExp('[ ]')),
                                            ],
                                            textInputAction: TextInputAction.next,
                                            controller: lastNameController,
                                            autofocus: false,
                                            validator: (value) {
                                              if (value.isEmpty)
                                                return "Prezime mora biti uneto";
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.text_rotation_none,
                                                color: zelena1,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: Colors.blue[900],
                                                  )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: zelena1,
                                                  )),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red)),
                                              labelText: 'Prezime',
                                              labelStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: zelena1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  isActive: true,
                                  state: _currentStep == 0
                                      ? StepState.indexed
                                      : _currentStep == 1
                                          ? StepState.editing
                                          : StepState.complete,
                                ),
                                Step(
                                  title: new Text("Adresa"),
                                  content: Form(
                                    key: _formKeys[2],
                                    child: Column(
                                      children: [
                                        SizedBox(height: 3),
                                        Container(
                                          height: size * 0.058,
                                          padding: EdgeInsets.only(
                                            left: size * 0.05,
                                            right: size * 0.05,
                                          ),
                                          child: TextFormField(
                                            textInputAction: TextInputAction.next,
                                            controller: addressController,
                                            autofocus: false,
                                            validator: (value) {
                                              if (value.isEmpty)
                                                return "Adresa mora biti uneta";
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(size * 0.01),
                                              prefixIcon: Icon(
                                                Icons.location_on,
                                                color: zelena1,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: Colors.blue[900],
                                                  )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: zelena1,
                                                  )),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red)),
                                              labelText: 'Adresa',
                                              labelStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: zelena1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        /* ----- GRAD ---- */
                                        Container(
                                          height: size * 0.058,
                                          padding: EdgeInsets.only(
                                            left: size * 0.05,
                                            right: size * 0.05,
                                          ),
                                          child: DropdownButtonFormField(
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
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: Colors.blue[900],
                                                  )),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0)),
                                                borderSide: BorderSide(
                                                  color: zelena1,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red)),
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
                                        SizedBox(height: 10),
                                        /* ----- POSTANSKI BROJ-----*/
                                        Container(
                                          height: size * 0.048,
                                          padding: EdgeInsets.only(
                                            left: size * 0.05,
                                            right: size * 0.05,
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
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              FilteringTextInputFormatter.deny(
                                                  RegExp('[ ]')),
                                            ],
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.location_city,
                                                color: zelena1,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: Colors.blue[900],
                                                  )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                    color: zelena1,
                                                  )),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red)),
                                              labelText: 'Poštanski broj',
                                              labelStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: zelena1,
                                                //fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  isActive: true,
                                  state: _currentStep == 0 || _currentStep == 1
                                      ? StepState.indexed
                                      : _currentStep == 2
                                          ? StepState.editing
                                          : StepState.complete,
                                ),

                                //  //NOVO
                                Step(
                                  title: new Text("Registracija"),
                                  content: Container(
                                    width: size * 0.65,
                                    height: size * 0.1,
                                    padding: EdgeInsets.only(
                                      left: size * 0.15,
                                      right: size * 0.15,
                                    ),
                                    child: Container(
                                      child: Column(
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: SizedBox(
                                                //height: size * 0.1,
                                                width: double.maxFinite,
                                                child: Column(
                                                  children: [

                                                    SizedBox(height: 10),
                                                    SizedBox(
                                                      height: size*0.03,
                                                      width:size*0.15,
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                          shape: MaterialStateProperty
                                                              .all<OutlinedBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius
                                                                          .circular(
                                                                              20.0)),
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .resolveWith<
                                                                      Color>((Set<
                                                                          MaterialState>
                                                                      states) {
                                                            return zelena1;
                                                          }),
                                                        ),
                                                        onPressed: () async {
                                                          if (_privateKeyController.text.isNotEmpty && _formKey.currentState
                                                              .validate()) {
                                                            var userModel = Provider
                                                                .of<UserModelWeb>(
                                                                    context,
                                                                    listen: false);
                                                            var size =
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width;
                                                            //dodat show dialog
                                                            showLoadingDialog(context);
                                                            await userModel
                                                                .initiateSetup(
                                                                    _confirmPrivateKeyController
                                                                        .text);
                                                            print(
                                                                _confirmPrivateKeyController
                                                                    .text);
                                                            var answer = await userModel
                                                                .register(
                                                                    usernameController
                                                                        .text,
                                                                    firstnameController
                                                                        .text,
                                                                    lastNameController
                                                                        .text,
                                                                    addressController
                                                                        .text,
                                                                    phoneController
                                                                        .text,
                                                                    emailController
                                                                        .text,
                                                                    _selectedItem,
                                                                    zipCodeController
                                                                        .text,
                                                                    hashCode);
                                                            print(
                                                                _privateKeyController
                                                                    .text);
                                                            await userModel
                                                                .resetPrivateKey(); // privateKey = ""
                                                            if (answer ==
                                                                0) //uspesna registracija
                                                              _successfulregistration();
                                                            else if (answer ==
                                                                1) //zauzet username
                                                              _reservedUsername();
                                                            else if (answer ==
                                                                2) //zauzet email
                                                              _reservedemail();
                                                            else if (answer ==
                                                                3) // zauzet broj telefona
                                                              _reservedPhoneNumber();
                                                            else if (answer ==
                                                                4) // zauzeta ethereum adresa
                                                              _reservedEthereumAddress();
                                                          }
                                                        },
                                                        child: Text(
                                                          "Registruj se",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Montserrat',
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ]
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ),
                          ],
                        ),
                      ),
                    ]
                ),
                  )
              ),
          ]),
        )));
  }

  Future<void> _reservedUsername() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Neuspešna registracija',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Već postoji korisnik sa navedenim korisničkim imenom'),
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
                'Pokušajte ponovo',
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

//Funkcija za alert -->zauzet email
  Future<void> _reservedemail() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Neuspešna registracija',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Već postoji korisnik sa navedenim imejlom'),
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
                'Pokušajte ponovo',
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

  //Funkcija za alert -- zauzet broj telefona
  Future<void> _reservedPhoneNumber() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Neuspešna registracija',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Već postoji korisnik sa navedenim brojem telefona'),
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
                'Pokušajte ponovo',
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

  //Funkcija za alert -- zauzet ethereum adresa
  Future<void> _reservedEthereumAddress() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Neuspešna registracija',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Već postoji korisnik za navedeni privatni ključ'),
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
                'Pokušajte ponovo',
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

  //Funkcija za alert -->Uspesna registracija
  Future<void> _successfulregistration() async {
    var userModel = Provider.of<UserModelWeb>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Uspešna registracija',
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
                'Povratak na početak',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => WelcomeWeb()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }
  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  continued2() {
    setState(() {
     // print(_formKeys[_currentStep].currentState);
      if (_currentStep < 3) {
        if (_formKeys[_currentStep].currentState.validate()) {
          _currentStep++;
          //  print("if");
        }
      }
      // print("van if");
    });
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
  //Funkcija za alert
  Future<void> _infoPK() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Privatni ključ',
            style: TextStyle(
              color: Colors.red[900],
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Kripto novčanik je softverski program koji čuva privatne (private) i javne (public) ključeve i uzajamno '
                    'radi sa različitim '
                    'blockchain-ovima kako bi omogućio korisnicima da šalju i primaju digitalnu valutu i prate stanje.\n',
                    style:TextStyle(fontFamily: 'Ubuntu')),
                Text('Javna adresa vašeg '
                    'novčanika je adresa koju će drugi korisnici koristiti za slanje kripto valuta za vas.',
                    style:TextStyle(fontFamily: 'Ubuntu')),
                Text('Drugi  je vaš privatni ključ, koji vam daje pristup svojim sredstvima i koristi se za potpisivanje '
                    'transakcija.', style:TextStyle(fontFamily: 'Ubuntu')),
                Text('\nPrimer privatnog ključa koji treba da unesete:', style:TextStyle(fontFamily: 'Ubuntu')),
                Text('f1201ea1481550bc6698e288744ac466becdaa5806281ab04f46358c36212c61', style: TextStyle(color:crvenaGlavna, fontFamily: 'Ubuntu'),),
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
                'Nazad',
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
}
