/*
*   STRANA ZA DODAVANJE NOVOG OGLASA (part 1)
*
* */

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/strings.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/ads/AddAdvertPageTwoWeb.dart';
import 'package:kotarica/web/home/HomeScreen.dart';
import 'package:provider/provider.dart';


class AddAdvertPageOneWeb extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<AddAdvertPageOneWeb> {

// controllers
  final _titleController = TextEditingController(text: "");
  String _izabranaKategorija;
  String _izabranaPotkategorija;

  /* -------KATEGORIJE ------ */
  /* Lista kategorija */
  final List<dynamic> kategorijeLista =
      json.decode(StringConstants.kategorije2); // lista kategorija
  List<DropdownMenuItem<String>> _dropDownMenuItemsKategorija;
  //kategorijeLista.removeAt(1);
  /* -------POTKATEGORIJE ------ */
  /* Liste potkategorija */
  List<dynamic> potkategorije = [];
  List<DropdownMenuItem<String>> _dropDownMenuItemsPotkategorija;

  final List<dynamic> mlecniProizvodiList =
      json.decode(StringConstants.mlecniProizvodi); // lista potkategorija

  final List<dynamic> suhomesnatoList =
      json.decode(StringConstants.suhomesnato); // lista potkategorija

  final List<dynamic> slaniSpajzList =
      json.decode(StringConstants.slaniSpajz); // lista potkategorija

  final List<dynamic> slatkiSpajzList =
      json.decode(StringConstants.slatkiSpajz); // lista potkategorija

  final List<dynamic> picaList =
      json.decode(StringConstants.pica); // lista potkategorija

  final List<dynamic> mlinList =
      json.decode(StringConstants.mlin); // lista potkategorija

  final List<dynamic> medList =
      json.decode(StringConstants.med); // lista potkategorija

  final List<dynamic> veganList =
      json.decode(StringConstants.vegan);

  final List<dynamic> voceList =
      json.decode(StringConstants.voce);

  final List<dynamic> povrceList =
      json.decode(StringConstants.povrce);

  final List<dynamic> ostaloList =
      json.decode(StringConstants.ostalo);// lista potkategorija

  // pri promeni kategorije izaberi potkategoriju
  void onChangeCallback(category) {
    if (category == "Mlečni proizvodi") {
      potkategorije = mlecniProizvodiList;
      _dropDownMenuItemsPotkategorija =
          buildDropdownMenuItemsPotkategorije(mlecniProizvodiList);
    } else if (category == "Suhomesnato") {
      potkategorije = suhomesnatoList;
      _dropDownMenuItemsPotkategorija =
          buildDropdownMenuItemsPotkategorije(suhomesnatoList);
    } else if (category == "Slani špajz") {
      potkategorije = slaniSpajzList;
      _dropDownMenuItemsPotkategorija =
          buildDropdownMenuItemsPotkategorije(slaniSpajzList);
    } else if (category == "Slatki špajz") {
      potkategorije = slatkiSpajzList;
      _dropDownMenuItemsPotkategorija =
          buildDropdownMenuItemsPotkategorije(slatkiSpajzList);
    } else if (category == "Piće") {
      potkategorije = picaList;
      _dropDownMenuItemsPotkategorija =
          buildDropdownMenuItemsPotkategorije(picaList);
    } else if (category == "Mlin") {
      potkategorije = mlinList;
      _dropDownMenuItemsPotkategorija =
          buildDropdownMenuItemsPotkategorije(mlinList);
    } else if (category == "Med") {
      potkategorije = medList;
      _dropDownMenuItemsPotkategorija =
          buildDropdownMenuItemsPotkategorije(medList);
    } else if (category == "Vegan") {
      potkategorije = veganList;
      _dropDownMenuItemsPotkategorija =
          buildDropdownMenuItemsPotkategorije(veganList);
    } else if (category == "Voće") {
      potkategorije = voceList;
      _dropDownMenuItemsPotkategorija =
          buildDropdownMenuItemsPotkategorije(voceList);

      // _dropDownMenuItemsPotkategorija =
      //     buildDropdownMenuItemsPotkategorije(veganList);
    } else if (category == "Povrće") {
      potkategorije = povrceList;
      _dropDownMenuItemsPotkategorija =
          buildDropdownMenuItemsPotkategorije(povrceList);

      // _dropDownMenuItemsPotkategorija =
      //     buildDropdownMenuItemsPotkategorije(veganList);
    } /*else if (category == "Ostalo") {
      potkategorije = ostaloList;
      _dropDownMenuItemsPotkategorija =
          buildDropdownMenuItemsPotkategorije(ostaloList);
      // _dropDownMenuItemsPotkategorija =
      //     buildDropdownMenuItemsPotkategorije(veganList);
    } */ else {
      potkategorije = ostaloList;
      _dropDownMenuItemsPotkategorija =
          buildDropdownMenuItemsPotkategorije(ostaloList);
    }

    setState(() {
      _izabranaKategorija = category;
      if(_izabranaKategorija != "Sve kategorije" || _izabranaKategorija != "Ostalo") {
        _izabranaPotkategorija = null;
      }
    });
  }

  // funkcija za dropdownKategorije
  List<DropdownMenuItem<String>> buildDropdownMenuItemsKategorije(
      List<dynamic> kategorijeLista) {
    List<DropdownMenuItem<String>> items = [];
    for (String kategorija in kategorijeLista) {
      items.add(
        DropdownMenuItem(
          child: Text(
            kategorija,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Tema.dark?bela:plavaTekst,
            ),
          ),
          value: kategorija,
        ),
      );
    }
    return items;
  }

  // funkcija za dropdownPotkategorije
  List<DropdownMenuItem<String>> buildDropdownMenuItemsPotkategorije(
      List<dynamic> potkategorijeLista) {
    List<DropdownMenuItem<String>> items = [];
    for (String potkategorija in potkategorijeLista) {
      items.add(
        DropdownMenuItem(
          child: Text(
            potkategorija,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Tema.dark?bela:plavaTekst,
            ),
          ),
          value: potkategorija,
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    super.initState();

    _dropDownMenuItemsKategorija =
        buildDropdownMenuItemsKategorije(kategorijeLista);
  }



  @override
  Widget build(BuildContext context) {

    /*
    void onChangeCallbackSubcategories(categories, subcategories) {
      setState(() {
        Provider.of<ProductModelWeb>(context, listen: false)
            .setTotalCountReady(false);
        Provider.of<ProductModelWeb(context, listen: false).setProductsReady(false);
        Provider.of<ProductModelWeb>(context, listen: false)
            .getProducts(categories, subcategories);
      });
    }*/
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreenWeb()),
                    (Route<dynamic> route) => false);
          },
        ),
        backgroundColor: zelena1,
      ),
      //resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            color: Tema.dark?darkPozadina:bela,
             padding: EdgeInsets.only(
                 top: 10.0, right: 25.0, left: 25.0, bottom: 10.0),
            child: Stack(children: [
              //NASLOV DODAJ OGLAS
              Center(
                child: Container(
                  child: Text(
                    'Dodavanje oglasa',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                        color: zelena1),
                  ),
                ),
              ),
              //SVETLO ZELENI KONTEJNER
              Center(
                child: Container(
                  height:MediaQuery.of(context).size.height*0.51,
                  width: size*0.5,
                  margin: EdgeInsets.only(top: size * 0.07),
                  padding: EdgeInsets.only(
                      top: size * 0.03,
                      right: size * 0.05,
                      left: size * 0.05,
                      bottom: size * 0.01),
                  decoration: Tema.dark
                      ? StyleZaGlavniContainer2
                      : StyleZaGlavniContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //INPUT FIELDs
                      buildTextField("Upišite naslov oglasa"),
                      SizedBox(height:20),
                      /*------DROPDOWN KATEGORIJA------*/
                      DropdownButtonFormField(
                        hint: Text(
                          "Izaberite kategoriju",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        dropdownColor: Tema.dark? darkPozadina:svetloZelena2,
                        //elevation: 5,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: plavaTekst,
                        ),
                        iconSize: 36.0,
                        value: _izabranaKategorija,
                        items: _dropDownMenuItemsKategorija,
                        onChanged: onChangeCallback,
                      ),
                      SizedBox(height: 20,),
                      /*------DROPDOWN POTKATEGORIJA------*/
                  (_izabranaKategorija != "Sve kategorije") && (_izabranaKategorija != "Ostalo")
                  ? DropdownButtonFormField(
                        hint: Text(
                          "Izaberite potkategoriju",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                    dropdownColor: Tema.dark? darkPozadina:svetloZelena2,
                        //elevation: 5,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        iconSize: 36.0,
                        value: _izabranaPotkategorija,
                        items: _dropDownMenuItemsPotkategorija,
                        onChanged: (value) {
                          setState(() {
                            _izabranaPotkategorija = value;
                          });
                        },
                      ):
                      SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          buildButtonBack(),
                          SizedBox(width:10),
                          buildButtonContainer(),

                        ],
                      )
                      // buildButtonContainer(),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
      backgroundColor: Tema.dark?darkPozadina:bela,
    );
  }

  Widget buildTextField(String hintText) {
    return TextField(
      controller: _titleController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black,
          fontFamily: "Ubuntu", //"OpenSansItalic",
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder:OutlineInputBorder (
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: hintText == "Naslov oglasa"
            ? Icon(
                Icons.arrow_right_outlined,
                color: Colors.black,
                size: 50.0,
              )
            : Icon(Icons.arrow_right_outlined),
      ),
    );
  }

  Widget buildButtonContainer() {
    return GestureDetector(
      onTap: () {
        if (_titleController.text == "")
          _emptyField();
        else if (_izabranaKategorija == null)
          _categoryNotChoosed();
        else if (_izabranaPotkategorija == null && _izabranaKategorija!="Ostalo")
          _subCategoryNotChoosed();
        else {
          if(_izabranaPotkategorija==null)
            _izabranaPotkategorija="Ostalo";
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddAdvertPageTwoWeb(
                      _titleController.text,
                      _izabranaKategorija,
                      _izabranaPotkategorija)),
                  (Route<dynamic> route) => false).then((value) {
            _titleController.clear();
            _izabranaKategorija = null;
            _izabranaPotkategorija = null;
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        height: MediaQuery.of(context).size.height*0.05,
        width: MediaQuery.of(context).size.width*0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23.0),
            border: Border.all(color: Colors.black),
          color: zelena1,
          // gradient: LinearGradient(
          //     colors: [
          //       lightGreen,
          //       Color.fromRGBO(255, 112, 87, 1)
          //     ],
          //     begin: Alignment.centerRight,
          //     end: Alignment.centerLeft),
        ),
        child: Center(
          child: Text(
            "DALJE",
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
  Widget buildButtonBack() {
    return GestureDetector(
      onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreenWeb()));
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        height: MediaQuery.of(context).size.height*0.05,
        width: MediaQuery.of(context).size.width*0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23.0),
            border: Border.all(color: Colors.black),
          color: narandzasta,
          // gradient: LinearGradient(
          //     colors: [
          //       lightGreen,
          //       Color.fromRGBO(255, 112, 87, 1)
          //     ],
          //     begin: Alignment.centerRight,
          //     end: Alignment.centerLeft),
        ),
        child: Center(
          child: Text(
            "ODUSTANI",
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

  // Popup za prazno polje
  Future<void> _emptyField() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Neuspesno dodavanje oglasa',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Naslov oglasa mora biti unet'),
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

  // Popup za neizabranu kategoriju
  Future<void> _categoryNotChoosed() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Neuspesno dodavanje oglasa',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Kategorija mora biti izabrana'),
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

  // Popup za neizabranu potkategoriju
  Future<void> _subCategoryNotChoosed() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Neuspesno dodavanje oglasa',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Potkategorija mora biti izabrana'),
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
