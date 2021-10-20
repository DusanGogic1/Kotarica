/*
*   STRANA ZA DODAVANJE NOVOG OGLASA (part 2)
*
* */

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kotarica/ads/AddAdvertPageOne.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/strings.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAdvertPageTwo extends StatefulWidget {
  final String _title;
  final String _category;
  final String _subcategory;

  AddAdvertPageTwo(this._title, this._category, this._subcategory);

  @override
  _State createState() =>
      _State(title: _title, category: _category, subcategory: _subcategory);
}

class _State extends State<AddAdvertPageTwo> {
  // controllers
  TextEditingController _advertDescription =
      new TextEditingController(text: "");
  TextEditingController _priceController = new TextEditingController(text: "");
  TextEditingController _ethController = new TextEditingController(text: "");
  String _izabranoNudimTrazim;
  String _chooseCurrency;
  String _izabranaMernaJedinica;

  final String title;
  final String category;
  final String subcategory;

  _State({this.title, this.category, this.subcategory});

  @override
  void initState() {
    super.initState();

    //nudimTrazim
    _dropDownMenuItemsNudimTrazim =
        buildDropdownMenuItemsNudimTrazim(nudimTrazimLista);

    // valuta
    _dropdownMenuItemsRsdEth = buildDropdownMenuItesRsdEth(rsdEthList);

    //merna jedinica
    _dropDownMenuItemsMernaJedinica=buildDropdownMenuItemsMernaJedinica(mernaJedinicaLista);
  }

  //SLIKE
  List<Asset> images = <Asset>[];
  String _error = 'No Error Dectected';

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 6,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      _error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  /* Izbor valute */
  static const String rsdEth = '["RSD", "ETH"]';
  List<dynamic> rsdEthList = json.decode(rsdEth);
  List<DropdownMenuItem<String>> _dropdownMenuItemsRsdEth;

  List<DropdownMenuItem<String>> buildDropdownMenuItesRsdEth(
      List<dynamic> rsdEthList) {
    List<DropdownMenuItem<String>> items = [];
    for (String currency in rsdEthList) {
      items.add(
        DropdownMenuItem(
          child: Center(
            child: Text(
              currency,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Tema.dark ? bela : plavaTekst,
              ),
                textAlign: TextAlign.center
            ),
          ),
          value: currency,
        ),
      );
    }

    return items;
  }

  /*NUDIM TRAZIM*/
  static const String nudimTrazim = '["Nudim","Tražim"]';
  List<dynamic> nudimTrazimLista = json.decode(nudimTrazim);
  List<DropdownMenuItem<String>> _dropDownMenuItemsNudimTrazim;

  List<DropdownMenuItem<String>> buildDropdownMenuItemsNudimTrazim(
      List<dynamic> nudimTrazimLista) {
    List<DropdownMenuItem<String>> items = [];
    for (String nt in nudimTrazimLista) {
      items.add(
        DropdownMenuItem(
          child: Center(
            child: Text(
              nt,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Tema.dark ? bela : plavaTekst,
              ),
                textAlign: TextAlign.center
            ),
          ),
          value: nt,
        ),
      );
    }
    return items;
  }
  /*MERNA JEDINCIA*/
  static const String mernaJedinica = '["kg","l","g","tegle"]';
  List<dynamic> mernaJedinicaLista = json.decode(mernaJedinica);
  List<DropdownMenuItem<String>> _dropDownMenuItemsMernaJedinica;

  List<DropdownMenuItem<String>> buildDropdownMenuItemsMernaJedinica(
      List<dynamic> mernaJedinicaLista) {
    List<DropdownMenuItem<String>> items = [];
    for (String nt in mernaJedinicaLista) {
      items.add(
        DropdownMenuItem(
          child: Center(
            child: Text(
              nt,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Tema.dark ? bela : plavaTekst,
              ),
                textAlign: TextAlign.center
            ),
          ),
          value: nt,
        ),
      );
    }
    return items;
  }



  // main widget build
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Tema.dark ? darkPozadina : Colors.white,
      appBar: new  AppBar(
        backgroundColor:Tema.dark?zelena1: zelena1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {

            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => AddAdvertPageOne()));

          },
        ),
      ),
      //resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            // color: Color.fromRGBO(230, 230, 250, 1),
            padding: EdgeInsets.only(
                top: 10.0, right: 20.0, left: 20.0, bottom: 10.0),
            child: Stack(children: [
              //NASLOV DODAVANJE OGLASA
              Center(
                child: Text(
                  'Dodavanje oglasa',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                      color: Tema.dark ? svetloZelena : zelena1),
                ),
              ),
              //ZELENI KONTEJNER
              Container(
                height: size * 1.9,
                margin: EdgeInsets.only(top: size * 0.18),
                padding: EdgeInsets.only(
                    top: size * 0.1,
                    right: size * 0.05,
                    left: size * 0.05,
                    bottom: size * 0.05),
                decoration: Tema.dark
                    ? StyleZaGlavniContainer2
                    : StyleZaGlavniContainer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //INPUT FIELD
                    bulidText(),
                    buildTextField("Napišite opis oglasa"),
                    SizedBox(
                      height: 10.0,
                    ),
                    //SLIKE
                    /* ------ DUGME ZA DODAVANJE SLIKA---------- */
                    ElevatedButton(
                      onPressed: loadAssets,
                      style: ElevatedButton.styleFrom(
                        primary: bela,
                        onPrimary: plavaTekst,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text('Izaberi slike',
                          style: TextStyle(fontFamily: "Montserrat")),
                    ),
                    /* ------------ PRIKAZ DODATIH SLIKA -------- */
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(images.length, (index) {
                          Asset asset = images[index];
                          return AssetThumb(
                            asset: asset,
                            width: 300,
                            height: 300,
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 5),
                    /*------RED ZA CENU------ */
                    Column(
                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //prva kolona
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Cena proizvoda",
                                  style: Tema.dark ? StyleZaCenu : StyleZaCenu2,
                                ),
                              ],
                            ),
                            SizedBox(width:20),
                            /*------TextField za cenu------ */
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                //alignment: Alignment.centerLeft,
                                height: size * 0.1,
                                width: size * 0.3,
                                color: bela,
                                child: TextField(
                                  textInputAction: TextInputAction.next,
                                  controller: _priceController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9\.]')),
                                  ],
                                  style: TextStyle(
                                      color:
                                          Tema.dark ? crnaGlavna : plavaTekst,
                                      fontFamily: "Montserrat"),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: plavaTekst,
                                        size: 20.0,
                                      ),
                                      hintText: "Cena",
                                      hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontFamily: "Ubuntu"),
                                      // contentPadding:
                                      //     EdgeInsets.only(top: 0.2)
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        /* -------- Valuta -------- */
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Valuta",
                              style: Tema.dark ? StyleZaCenu : StyleZaCenu2,
                            ),
                            /*------ DROPDOWN RSD/ETH ------*/
                            SizedBox(width:20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                height: size * 0.1,
                                width: size * 0.3,
                                color:bela,
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  dropdownColor: Tema.dark? darkPozadina:bela,
                                  //elevation: 5,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: plavaTekst,
                                  ),
                                  iconSize: 25.0,
                                  value: _chooseCurrency,
                                  items: _dropdownMenuItemsRsdEth,
                                  onChanged: (value) {
                                    setState(() {
                                      _chooseCurrency = value;
                                    });
                                  },
                                ),
                              ),
                            )],
                        ),
                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Merna jedinica",
                              style: Tema.dark ? StyleZaCenu : StyleZaCenu2,
                            ),
                            /*------ DROPDOWN Merna jedinica ------*/
                            SizedBox(width:20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                height: size * 0.1,
                                width: size * 0.3,
                                color:bela,
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  dropdownColor: Tema.dark? darkPozadina:bela,
                                  //elevation: 5,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: plavaTekst,

                                  ),
                                  iconSize: 25.0,
                                  value: _izabranaMernaJedinica,
                                  items: _dropDownMenuItemsMernaJedinica,
                                  onChanged: (value) {
                                    setState(() {
                                      _izabranaMernaJedinica = value;
                                    });
                                  },
                                ),
                              ),
                            )],
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    //drop down nudim trazim
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nudim/tražim",
                          style: Tema.dark ? StyleZaCenu : StyleZaCenu2,
                        ),
                        /*------ DROPDOWN RSD/ETH ------*/
                        SizedBox(width:20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            height: size * 0.1,
                            width: size * 0.3,
                            color:bela,
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              dropdownColor: Tema.dark? darkPozadina:bela,
                              //elevation: 5,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: plavaTekst,
                              ),
                              iconSize: 25.0,
                              value: _izabranoNudimTrazim,
                              style: new TextStyle(
                                color: Tema.dark?Colors.black:bela),
                              items: _dropDownMenuItemsNudimTrazim,
                              onChanged: (value) {
                                setState(() {
                                  _izabranoNudimTrazim = value;
                                });
                              },
                            ),
                          ),
                        )],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    buildButtonContainer(title, category, subcategory),
                  ],
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  // field za opis oglasa
  Widget buildTextField(String hintText) {
    return TextField(
      style: TextStyle(
        color: Tema.dark?bela:Colors.black
      ),
      textInputAction: TextInputAction.next,
      controller: _advertDescription,
      //textAlign: TextAlign.center,
      maxLines: 4,
      decoration: InputDecoration(
          fillColor: Tema.dark? siva: bela,
          // hintText: hintText,
          hintStyle: TextStyle(
            color: Tema.dark? bela: siva,
            fontFamily: "Ubuntu", //"OpenSansItalic",
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder:OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(20.0),
          ),
          prefixIcon: Icon(
            Icons.arrow_right_outlined,
            color: Tema.dark ? svetloZelena : siva,
            size: 60.0,
          )),
    );
  }

  // button za dodavanje oglasa
  Widget buildButtonContainer(
      String title, String category, String subcategory) {
    return GestureDetector(
      onTap: () async {
        if (_advertDescription.text == "" || _priceController.text == "")
          _emptyField();
        else if (_izabranoNudimTrazim == null)
          _typeNotChoosen();
        else if (_chooseCurrency == null)
          _currencyNotChoosen();
        else if (double.parse(_priceController.text) == 0)
          _zeroPrice();
        else {
          double ethPrice;
          double rsdPrice;
          if (_chooseCurrency == "RSD") {
            rsdPrice = double.parse(_priceController.text);
            ethPrice = rsdPrice * StringConstants.valueOfEth;
          } else {
            ethPrice = double.parse(_priceController.text);
            rsdPrice = ethPrice / StringConstants.valueOfEth;
          }

          /* Dodavanje oglasa */
          Provider.of<ProductModel>(context, listen: false).postProduct(
              title,
              category,
              subcategory,
              _advertDescription.text,
              rsdPrice.toInt(),
              ethPrice,
              images,
              _izabranaMernaJedinica,
              _izabranoNudimTrazim,
              DateTime.now());

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()),
              (Route<dynamic> route) => false).then((value) {
            _advertDescription.clear();
            _priceController.clear();
            _izabranoNudimTrazim = null;
            _chooseCurrency = null;
          });
        }
      },
      child: Container(
        height: 50.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23.0),
          gradient: LinearGradient(
              colors: Tema.dark
                  ? <Color>[zelena1, crvenaGlavna]
                  : <Color>[lightGreen, Color.fromRGBO(255, 112, 87, 1)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft),
          boxShadow: [
            BoxShadow(
              color:Tema.dark?zelenaDark.withOpacity(0.2): Colors.grey.withOpacity(0.5),
               spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            "DODAJ OGLAS",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }

  // tekst
  Widget bulidText() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.01,
          bottom: MediaQuery.of(context).size.width * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Opis oglasa",
              style: TextStyle(
                  color: Tema.dark ? svetloZelena : plavaTekst,
                  fontSize: 20.0,
                  fontFamily: "Montserrat"))
        ],
      ),
    );
  }

  // Popup za prazno polje
  Future<void> _emptyField() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Tema.dark? darkPozadina: bela,
          title: Text(
            'Neuspesno dodavanje oglasa',
            style: TextStyle(
              color:  Tema.dark? svetloZelena: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Sva polja moraju biti uneta',
                    style:TextStyle(color: Tema.dark? bela: Colors.black)),
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
                'Pokusaj opet',
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

  // Popup za neizabran tip
  Future<void> _typeNotChoosen() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Tema.dark? darkPozadina: bela,
          title: Text(
            'Neuspesno dodavanje oglasa',
            style: TextStyle(
              color:  Tema.dark? svetloZelena: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tip oglasa mora biti izabran',
                    style:TextStyle(color: Tema.dark? bela: Colors.black)),

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
                'Pokusaj opet',
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

  // Popup za neizabranu valutu
  Future<void> _currencyNotChoosen() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Tema.dark? darkPozadina: bela,
          title: Text(
            'Neuspesno dodavanje oglasa',
            style: TextStyle(
              color:  Tema.dark? svetloZelena: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Valuta cene oglasa mora biti izabrana',
                    style:TextStyle(color: Tema.dark? bela: Colors.black)),

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
                'Pokusaj opet',
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

  // Popup za unetu nulu
  Future<void> _zeroPrice() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Tema.dark? darkPozadina: bela,
          title: Text(
            'Neuspesno dodavanje oglasa',
            style: TextStyle(
              color:  Tema.dark? svetloZelena: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Cena oglasa ne može biti nula',
                    style:TextStyle(color: Tema.dark? bela: Colors.black)),

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
                'Pokusaj opet',
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
