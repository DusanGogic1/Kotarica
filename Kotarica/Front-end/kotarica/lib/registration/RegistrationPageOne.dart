import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kotarica/constants/network.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/util/Validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../constants/strings.dart';
import '../constants/style.dart';
import '../models/UserModel.dart';
import 'Welcome.dart';

String hashCode = "QmZws7HW1TZVP54LfoKRLWVDtfrk2nUz3MYCJKU67HtkG2";

class RegistrationPageOne extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<RegistrationPageOne> {
  final _formKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> _formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>(),];

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    return file;
  }


  String username;
  // String password;
  // String confirmpassword;
  String email;
  String phone;
  String image;

  //var image = null;
  File file;
  //File file;

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

  void _uploadImage() async {

    file=await getImageFileFromAssets("images/profilna.jpg");

    final _picker = ImagePicker();
    var _pickedImage =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 100);
    if (_pickedImage == null) {
      return;
    }
    File _pickedImage1 = await ImageCropper.cropImage(
        sourcePath: _pickedImage.path,
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        aspectRatioPresets: [CropAspectRatioPreset.square]);
    if (_pickedImage1 == null) {
      return;
    }
    setState(() {
      image = _pickedImage1.path;
      file = File(_pickedImage1.path);

      _upload();
    });
  }

  void _upload() async {
    if (file == null) return;
    String base64Image = base64Encode(file.readAsBytesSync());
    String fileName = file.path.split("/").last;

    final http.Client _client = http.Client();
    var response =
        await _client.post(NetworkConstants.nodeEndpointUpload, body: {
      "image": base64Image,
      "name": fileName,
    });

    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      hashCode = decoded['hash'];
      print(hashCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var isFirstScreen = false;
    return Form(
      key: _formKey,
      child: Container(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: Column(children: <Widget>[
                /* --- SLIKA ----- */
                    Container(
                      padding: EdgeInsets.only(
                        left: size * 0.02, right: size * 0.02, top: size * 0.08),
                      child: Center(
                        child: Container(
                          width: 190,
                          height: 190,
                          child: GestureDetector(
                              onTap: _uploadImage,
                              child: Container(
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: file != null
                                              ? Image.file(File(image)).image
                                              : new AssetImage("images/profilna.jpg")
                                      )
                                  )
                              ),
                            )
                          )
                        )
                      ),
                    SizedBox(
                      height: size * 0.1,
                    ),
                    /* ---- KORISNICKO IME ----*/

                    Column(
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
                       //   onStepContinue: continued,
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
                                      : onStepCancel, // <-- important part

                                  color: Colors.white,
                                  child: Text('NAZAD',
                                      style: TextStyle(color: zelena1)),
                                ),
                              ],
                            );
                          },
                          steps: <Step>[
                            Step(
                              isActive: true,
                              title: new Text("Nalog"),
                              content: Form(
                                key: _formKeys[0],
                                child: Column(
                                  children: [
                                    SizedBox(height: 3),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: size * 0.02,
                                        right: size * 0.02,
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
                                            : usernameController.value =
                                                TextEditingController.fromValue(
                                                        TextEditingValue(
                                                            text: username))
                                                    .value,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.all(size * 0.05),
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
                                              borderSide:
                                                  BorderSide(color: Colors.red)),
                                          labelText: 'Korisničko ime',
                                          labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: zelena1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size * 0.04),
                                    /* ------ PRIVATNI KLJUČ -----*/
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: size * 0.02,
                                        right: size * 0.02,
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
                                          contentPadding:
                                              EdgeInsets.all(size * 0.05),
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
                                              borderSide:
                                                  BorderSide(color: Colors.red)),
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
                                    SizedBox(height: size * 0.04),
                                    /* ----- POTVRDA PRIVATNOG KLJUČA ----*/
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: size * 0.02,
                                        right: size * 0.02,
                                      ),
                                      child: TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(
                                              RegExp('[ ]')),
                                        ],
                                        textInputAction: TextInputAction.next,
                                        controller: _confirmPrivateKeyController,
                                        obscureText: true,
                                        autofocus: false,
                                        validator: (value) =>
                                            validatePrivateKey(value) ??
                                            validateConfirmPrivateKey(value,
                                                _privateKeyController.text),
                                        maxLength: 64,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.all(size * 0.05),
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
                                              borderSide:
                                                  BorderSide(color: Colors.red)),
                                          labelText: 'Potvrda privatnog ključa',
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
                              // isActive: _currentStep >= 0,
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
                                    SizedBox(height: 3),

                                    /* ---- EMAIL -----*/
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: size * 0.02,
                                        right: size * 0.02,
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
                                                TextEditingController.fromValue(
                                                        TextEditingValue(
                                                            text: email))
                                                    .value,
                                        autofocus: false,
                                        validator: validateEmail,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.all(size * 0.05),
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
                                              borderSide:
                                                  BorderSide(color: Colors.red)),
                                          labelText: 'Email adresa',
                                          labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: zelena1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size * 0.04),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: size * 0.02,
                                        right: size * 0.02,
                                      ),
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: phone == null
                                            ? phoneController
                                            : phoneController.value =
                                                TextEditingController.fromValue(
                                                        TextEditingValue(
                                                            text: phone))
                                                    .value,
                                        autofocus: false,
                                        validator: validatePhoneNumber,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly,
                                          FilteringTextInputFormatter.deny(
                                              RegExp('[ ]')),
                                        ],
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.all(size * 0.05),
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
                                              borderSide:
                                                  BorderSide(color: Colors.red)),
                                          labelText: 'Broj telefona',
                                          labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: zelena1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size * 0.04),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: size * 0.02,
                                        right: size * 0.02,
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
                                          contentPadding:
                                              EdgeInsets.all(size * 0.05),
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
                                              borderSide:
                                                  BorderSide(color: Colors.red)),
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
                                          contentPadding:
                                              EdgeInsets.all(size * 0.05),
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
                                              borderSide:
                                                  BorderSide(color: Colors.red)),
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
                              isActive: _currentStep >= 0,
                              state: _currentStep == 0
                                  ? StepState.indexed
                                  : _currentStep == 1 ?StepState.editing: StepState.complete,
                            ),
                            Step(
                              title: new Text("Adresa"),
                              content: Form(
                                key: _formKeys[2],
                                child: Column(
                                  children: [
                                    SizedBox(height: 3),
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
                                              borderSide:
                                                  BorderSide(color: Colors.red)),
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
                                              borderSide:
                                                  BorderSide(color: Colors.red)),
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
                                          FilteringTextInputFormatter.deny(
                                              RegExp('[ ]')),
                                        ],
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.all(size * 0.05),
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
                                              borderSide:
                                                  BorderSide(color: Colors.red)),
                                          labelText: 'Poštanski broj',
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
                              state: _currentStep == 0 || _currentStep==1
                                  ? StepState.indexed
                                  : _currentStep == 2 ?StepState.editing: StepState.complete,

                            ),
                            //novo
                            Step(
                              title: new Text("Registruj se"),
                              content: Column(
                                children: [
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
                                                  if (_privateKeyController.text.isNotEmpty && _formKey.currentState.validate()) {
                                                    // if (passwordController.text.compareTo(confirmPasswordController.text) != 0) //razlikuju se sifre
                                                    //   _diffrentpasword();
                                                    // else {
                                                    //   _PopUpPrivateKey(
                                                    //       usernameController.text,
                                                    //       passwordController.text,
                                                    //       firstnameController.text,
                                                    //       lastNameController.text,
                                                    //       addressController.text,
                                                    //       phoneController.text,
                                                    //       emailController.text,
                                                    //       _selectedItem,
                                                    //       zipCodeController.text,
                                                    //       hashCode);
                                                    // }
                                                    var userModel = Provider.of<UserModel>(
                                                        context,
                                                        listen: false);
                                                    var size =
                                                        MediaQuery.of(context).size.width;
                                                    showLoadingDialog(context);

                                                    await userModel.initiateSetup(
                                                        _confirmPrivateKeyController.text);

                                                    print(_confirmPrivateKeyController.text);
                                                    var answer = await userModel.register(
                                                        usernameController.text,
                                                        firstnameController.text,
                                                        lastNameController.text,
                                                        addressController.text,
                                                        phoneController.text,
                                                        emailController.text,
                                                        _selectedItem,
                                                        zipCodeController.text,
                                                        hashCode);
                                                    print(_privateKeyController.text);
                                                    await userModel
                                                        .resetPrivateKey(); // privateKey = ""
                                                    if (answer == 0) //uspesna registracija
                                                      _successfulregistration();
                                                    else if (answer == 1) //zauzet username
                                                      _reservedUsername();
                                                    else if (answer == 2) //zauzet email
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
                              // isActive: true,
                              // state: _currentStep == 0 || _currentStep==1 || _currentStep==2
                              //     ? StepState.indexed
                              //     : _currentStep == 3 ?StepState.editing: StepState.complete,

                            )
                            // NOVO

                          ],
                        )),
                    // Container(
                    //   padding:
                    //       EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                    //   child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Center(
                    //           child: SizedBox(
                    //             height: size * 0.1,
                    //             width: double.maxFinite,
                    //             child: ElevatedButton(
                    //               style: ButtonStyle(
                    //                 shape: MaterialStateProperty.all<
                    //                     OutlinedBorder>(
                    //                   RoundedRectangleBorder(
                    //                     borderRadius: BorderRadius.all(
                    //                         Radius.circular(20.0)),
                    //                   ),
                    //                 ),
                    //                 backgroundColor:
                    //                     MaterialStateProperty.resolveWith<
                    //                         Color>((Set<MaterialState> states) {
                    //                   return zelena1;
                    //                 }),
                    //               ),
                    //               onPressed: () async {
                    //                 if (_formKey.currentState.validate()) {
                    //                   // if (passwordController.text.compareTo(confirmPasswordController.text) != 0) //razlikuju se sifre
                    //                   //   _diffrentpasword();
                    //                   // else {
                    //                   //   _PopUpPrivateKey(
                    //                   //       usernameController.text,
                    //                   //       passwordController.text,
                    //                   //       firstnameController.text,
                    //                   //       lastNameController.text,
                    //                   //       addressController.text,
                    //                   //       phoneController.text,
                    //                   //       emailController.text,
                    //                   //       _selectedItem,
                    //                   //       zipCodeController.text,
                    //                   //       hashCode);
                    //                   // }
                    //                   var userModel = Provider.of<UserModel>(
                    //                       context,
                    //                       listen: false);
                    //                   var size =
                    //                       MediaQuery.of(context).size.width;
                    //
                    //                   await userModel.initiateSetup(
                    //                       _confirmPrivateKeyController.text);
                    //
                    //                   print(_confirmPrivateKeyController.text);
                    //                   var answer = await userModel.register(
                    //                       usernameController.text,
                    //                       firstnameController.text,
                    //                       lastNameController.text,
                    //                       addressController.text,
                    //                       phoneController.text,
                    //                       emailController.text,
                    //                       _selectedItem,
                    //                       zipCodeController.text,
                    //                       hashCode);
                    //                   print(_privateKeyController.text);
                    //                   await userModel
                    //                       .resetPrivateKey(); // privateKey = ""
                    //                   if (answer == 0) //uspesna registracija
                    //                     _successfulregistration();
                    //                   else if (answer == 1) //zauzet username
                    //                     _reservedUsername();
                    //                   else if (answer == 2) //zauzet email
                    //                     _reservedemail();
                    //                   else if (answer ==
                    //                       3) // zauzet broj telefona
                    //                     _reservedPhoneNumber();
                    //                   else if (answer ==
                    //                       4) // zauzeta ethereum adresa
                    //                     _reservedEthereumAddress();
                    //                 }
                    //               },
                    //               child: Text(
                    //                 "REGISTRUJ SE",
                    //                 style: TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   fontFamily: 'Montserrat',
                    //                   color: Colors.white,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         )
                    //       ]),
                    // )
                  ],
                ),
              ]))
            ],
          ),
        ),
      ),
    );
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
    var userModel = Provider.of<UserModel>(context, listen: false);

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
                        builder: (BuildContext context) => Welcome()),
                    (Route<dynamic> route) => false);
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
  //   print(image);
  //
  //   var userModel = Provider.of<UserModel>(context, listen: false);
  //   var size = MediaQuery.of(context).size.width;
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //
  //         content: SingleChildScrollView(
  //           child: ListBody(children: <Widget>[
  //             Text(
  //               "Unesite privatni ključ",
  //               style: TextStyle(
  //                   color: zelena1, fontWeight: FontWeight.bold, fontSize: 25),
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
  //
  //               await userModel.initiateSetup(_privateKeyController.text);
  //
  //               print(_privateKeyController.text);
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
  //               print(_privateKeyController.text);
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
  //                //Navigator.of(context).pop();
  //              // MaterialPageRoute( builder: (context) => HomeScreen());
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
  // switchStepsType() {
  //   setState(() => stepperType == StepperType.vertical
  //       ? stepperType = StepperType.horizontal
  //       : stepperType = StepperType.vertical);
  // }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }
  continued2() {
    setState(() {
      print(_formKeys[_currentStep].currentState);
      if (_currentStep < 3){
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
class MyData {
  String username = '';
  String privateKey = '';
  String confirmPrivateKey = '';
  String phone = '';
  String email = '';
  String age = '';
}

