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
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/web/home/HomeScreen.dart';

import 'ChangeMyAdsPageTwo.dart';


// ignore: must_be_immutable
class ChangeMyAdsPageOneWeb extends StatefulWidget {
  Product product;
  void Function (Product) onProductUpdated;
  ChangeMyAdsPageOneWeb({
    @required this.product,
    this.onProductUpdated,
  });
  @override
  _State createState() => _State(product);
}

class _State extends State<ChangeMyAdsPageOneWeb> {
  // controllers
  final _titleController = TextEditingController(text: "");
  String _izabranaKategorija;
  String _izabranaPotkategorija;

  Product product;
  _State(this.product);
/* Lista kategorija */
  final List<dynamic> kategorijeLista =
  json.decode(StringConstants.kategorije); // lista kategorija
  List<DropdownMenuItem<String>> _dropDownMenuItemsKategorija;

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
  json.decode(StringConstants.vegan); // lista potkategorija

  void setSubcategoryItems(String category) {
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
    } else {
      potkategorije = [];
    }
  }

  // pri promeni kategorije izaberi potkategoriju
  void onChangeCallback(category) {
    setSubcategoryItems(category);

    setState(() {
      _izabranaKategorija = category;
      _izabranaPotkategorija = null;
    });
  }

  // funkcija za dropdownKategorije
  List<DropdownMenuItem<String>> buildDropdownMenuItemsKategorije(
      List<dynamic> kategorijeLista) {
    kategorijeLista.removeAt(0);

    List<DropdownMenuItem<String>> items = [];
    for (String kategorija in kategorijeLista) {
      items.add(
        DropdownMenuItem(
          child: Text(
            kategorija,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Tema.dark ? bela : plavaTekst,
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
              color: Tema.dark ? bela : plavaTekst,
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

    _titleController.text=widget.product.title;

    _dropDownMenuItemsKategorija =
        buildDropdownMenuItemsKategorije(kategorijeLista);
    onChangeCallback(widget.product.category);

    _titleController.text=widget.product.title;
    _izabranaKategorija=widget.product.category;
    _izabranaPotkategorija=widget.product.subcategory;
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Tema.dark ? darkPozadina : Colors.white,
      appBar: AppBar(
        backgroundColor: zelena1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreenWeb()
              ),
            );
          },
        ),
      ),
      //resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Stack(children: [

          Container(
        color:Tema.dark?darkPozadina:bela,
            padding: EdgeInsets.only(
                top: 10.0, right: 25.0, left: 25.0, bottom: 10.0),
            child: Stack(children: [
              //NASLOV DODAJ OGLAS
              Center(
                child: Container(
                  child: Text(
                    'Izmena oglasa',
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
                  height:MediaQuery.of(context).size.height*0.56,
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
                      //INPUT FIELD
                      buildTextField("Upišite naslov oglasa"),
                      SizedBox(height: 20,),

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
                      (_izabranaKategorija != "Sve kategorije") && (_izabranaKategorija != "Ostalo")?
                      DropdownButtonFormField(
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
                      ):SizedBox(height:10),
                      SizedBox(
                        height: 20.0,
                      ),

                      buildButtonContainer(),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ]),

      ),

    );

  }

  Widget buildTextField(String hintText) {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Tema.dark ? svetloZelena : crnaGlavna,
          fontFamily: "Ubuntu", //"OpenSansItalic",
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: hintText == "Naslov oglasa"
            ? Icon(
          Icons.arrow_right_outlined,
          color: Tema.dark ? svetloZelena : Colors.black,
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangeMyAdsPageTwoWeb(_titleController.text,
                      _izabranaKategorija, _izabranaPotkategorija, widget.product, (product) {
                        setState(() {
                          this.product = product;
                          widget.product = product;
                        });
                        widget.onProductUpdated?.call(product);
                      })));
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
            "DALJE",
            style: TextStyle(
              color: Tema.dark ? bela : belaGlavna,
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
