/*
*   STRANA ZA DODAVANJE NOVOG OGLASA (part 2)
*
* */

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/strings.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/ads/AddAdvertPageOneWeb.dart';
import 'package:kotarica/web/home/HomeScreen.dart';
//import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';


class AddAdvertPageTwoWeb extends StatefulWidget {
  final String _title;
  final String _category;
  final String _subcategory;

  AddAdvertPageTwoWeb(this._title, this._category, this._subcategory);

  @override
  _State createState() =>
      _State(title: _title, category: _category, subcategory: _subcategory);
}

class _State extends State<AddAdvertPageTwoWeb> {
  // controllers
  TextEditingController _advertDescription =
  new TextEditingController(text: "");
  TextEditingController _priceController = new TextEditingController(text: "");
  TextEditingController _ethController = new TextEditingController(text: "");
  String _izabranoNudimTrazim;
  String _chooseCurrency;
  String _izabranaMernaJedinica;
  List<Uint8List> data = <Uint8List>[];

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
  List<Image> images = <Image>[];
  String _error = 'No Error Dectected';

  Future<void> loadAssets() async {
    String error = 'No Error Detected';

    data = await ImagePickerWeb.getMultiImages(outputType: ImageType.bytes);
    List<Image> fromPicker = new List<Image>();
    for(int i = 0; i < data.length;i++)
    {
        fromPicker.add(Image.memory(data[i]));
    }
    setState(() {
      images = fromPicker;
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
                  color: Tema.dark ? Colors.grey[600] : plavaTekst,
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
                  color: Tema.dark ? Colors.grey[600] : plavaTekst,
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
                  color: Tema.dark ? Colors.grey[600] : plavaTekst,
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
    var sizeH = MediaQuery.of(context).size.height;
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddAdvertPageOneWeb()
              ),
            );
          },
        ),
        backgroundColor: zelena1,
      ),
      //resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            color: Tema.dark?darkPozadina:bela,

            //color: Color.fromRGBO(230, 230, 250, 1),
            padding: EdgeInsets.only(
                top: 10.0, right: 20.0, left: 20.0),
            child: Stack(children: [
              //NASLOV DODAVANJE OGLASA
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
              //ZELENI KONTEJNER
              SingleChildScrollView(
                child: Center(
                  child: Container(
                    height:720,
                    width: size*0.5,
                    margin: EdgeInsets.only(top: size * 0.05),
                    padding: EdgeInsets.only(
                        top: size * 0.009,
                        right: size * 0.05,
                        left: size * 0.05,
                      ),
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
flex:1,
                          child: GridView.count(
                            crossAxisCount: 3,
                            crossAxisSpacing: 3.0,
                            mainAxisSpacing: 3.0,
                            childAspectRatio: 1.7,
                            children: List.generate(images.length, (index) {
                              return Image(
                                image: images[index].image,
                                width: 300,
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: 5),
                        /*------RED ZA CENU------ */
                        Expanded(
                          flex:2,
                          child: Column(
                            children: [
                              //prva kolona
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Cena proizvoda",
                                    style: Tema.dark ? StyleZaCenu : StyleZaCenu2,
                                  ),
                                  //),
                                  SizedBox(width:20),
                                  /*------TextField za cenu------ */
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      //alignment: Alignment.centerLeft,
                                      height: size * 0.035,
                                      width: size * 0.25,
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
                                    "Valuta cene",
                                    style: Tema.dark ? StyleZaCenu : StyleZaCenu2,
                                  ),
                                  // ),
                                  /*------Text: Obavezno------ */
                                  // Text(
                                  //   "*obavezno",
                                  //   style: TextStyle(
                                  //     color: Tema.dark ? svetlaBoja : plavaTekst,
                                  //     fontFamily: "Montserrat",
                                  //     fontSize: 12.0,
                                  //   ),
                                  // ),
                                  //),
                                  // SizedBox(height: 10),
                                  /*------ DROPDOWN RSD/ETH ------*/
                                  SizedBox(width:20),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      height: size * 0.035,
                                      width: size * 0.25,
                                      color:bela,
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        //   decoration: InputDecoration.collapsed(hintText: 'RSD/ETH'),
                                        // hint: Center(
                                        //   child: Text(
                                        //     "RSD/ETH",
                                        //     style: TextStyle(
                                        //       fontFamily: 'Montserrat',
                                        //       fontWeight: FontWeight.bold,
                                        //       fontSize: 14,
                                        //       color: Tema.dark ? svetlaBoja : plavaTekst,
                                        //     ),
                                        //   ),
                                        // ),
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
                                  // ),
                                  /*------Text: Obavezno------ */
                                  // Text(
                                  //   "*obavezno",
                                  //   style: TextStyle(
                                  //     color: Tema.dark ? svetlaBoja : plavaTekst,
                                  //     fontFamily: "Montserrat",
                                  //     fontSize: 12.0,
                                  //   ),
                                  // ),
                                  //),
                                  /*------ DROPDOWN Merna jedinica ------*/
                                  SizedBox(width:20),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      height: size * 0.035,
                                      width: size * 0.25,
                                      color:bela,
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        // decoration: InputDecoration.collapsed(hintText: 'Merna \njedinica'),
                                        // hint: Center(
                                        //   child: Text(
                                        //     "RSD/ETH",
                                        //     style: TextStyle(
                                        //       fontFamily: 'Montserrat',
                                        //       fontWeight: FontWeight.bold,
                                        //       fontSize: 14,
                                        //       color: Tema.dark ? svetlaBoja : plavaTekst,
                                        //     ),
                                        //   ),
                                        // ),
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
                             SizedBox (
                                  height: 10.0,
                              ),
                              /*------DROPDOWN NUDIM/TRAZIM ------*/
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Nudim/tražim",
                                    style: Tema.dark ? StyleZaCenu : StyleZaCenu2,
                                  ),
                                  // ),
                                  /*------Text: Obavezno------ */
                                  // Text(
                                  //   "*obavezno",
                                  //   style: TextStyle(
                                  //     color: Tema.dark ? svetlaBoja : plavaTekst,
                                  //     fontFamily: "Montserrat",
                                  //     fontSize: 12.0,
                                  //   ),
                                  // ),
                                  //),
                                  // SizedBox(height: 10),
                                  SizedBox(width:20),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      height: size * 0.035,
                                      width: size * 0.25,
                                      color:bela,
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        // hint: Text(
                                        //   "Izaberi...",
                                        //   style: TextStyle(
                                        //     fontFamily: 'Ubuntu',
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Tema.dark ? svetlaBoja : plavaTekst,
                                        //   ),
                                        // ),
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
                            ],
                          ),
                        ),

                        buildButtonContainer(title, category, subcategory),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
     backgroundColor:  Tema.dark?darkPozadina:bela,
    );
  }

  // field za opis oglasa
  Widget buildTextField(String hintText) {
    return TextField(
      textInputAction: TextInputAction.next,
      controller: _advertDescription,
      //textAlign: TextAlign.center,
      maxLines: 4,
      decoration: InputDecoration(
          fillColor: bela,
          // hintText: hintText,
          hintStyle: TextStyle(
            color: siva,
            fontFamily: "Ubuntu", //"OpenSansItalic",
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(20.0),
          ),
          prefixIcon: Icon(
            Icons.arrow_right_outlined,
            color: siva,
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
          }  else {
            ethPrice = double.parse(_priceController.text);
            rsdPrice = ethPrice / StringConstants.valueOfEth;
          }

          rsdPrice = trim(rsdPrice);
          ethPrice = trim(ethPrice);

          /* Dodavanje oglasa */
          Provider.of<ProductModelWeb>(context, listen: false).postProduct(
              title,
              category,
              subcategory,
              _advertDescription.text,
              rsdPrice.toInt(),
              ethPrice,
              data,
              _izabranaMernaJedinica,
              _izabranoNudimTrazim,
              DateTime.now());


          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreenWeb()),
                  (Route<dynamic> route) => false).then((value) {
            _advertDescription.clear();
            _priceController.clear();
            _izabranoNudimTrazim = null;
            _chooseCurrency = null;
          });


          Fluttertoast.showToast(
              msg: "Oglas uspesno dodat",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      child: Container(
        height:MediaQuery.of(context).size.height*0.05,
        width: MediaQuery.of(context).size.width*0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23.0),
          border: Border.all(color: Colors.black),
          color: zelena1,
          // gradient: LinearGradient(
          //     colors: [lightGreen, Color.fromRGBO(255, 112, 87, 1)],
          //     begin: Alignment.centerRight,
          //     end: Alignment.centerLeft),
        ),
        child: Center(
          child: Text(
            "DODAJ OGLAS",
            style: TextStyle(
              fontFamily: "Montserrat",
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width*0.015,
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
        top:MediaQuery.of(context).size.width*0.009,
          left: MediaQuery.of(context).size.width * 0.01,
          bottom: MediaQuery.of(context).size.width * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Opis oglasa",
              style: TextStyle(
                  color: siva2, fontSize: MediaQuery.of(context).size.width*0.015, fontFamily: "Montserrat"))
        ],
      ),
    );
  }


  double trim(double n) {
    String removedDecimals = removeDecimalZeroFormat(n);
    removedDecimals = roundDecimal(double.parse(removedDecimals));

    return double.parse(removedDecimals);
  }

  /* Skrati nule sa kraja broja (vraca string) */
  String removeDecimalZeroFormat(double n) {
    return n.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
  }

  /* Zaokruzi broj (vraca string) */
  String roundDecimal(double n) {
    return n.toStringAsFixed(6);
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
                Text('Sva polja moraju biti uneta'),
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
                Text('Tip oglasa mora biti izabran'),
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
