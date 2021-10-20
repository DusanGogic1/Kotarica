import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';
import 'package:kotarica/constants/strings.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/ads/MyAds/DeleteChangeWeb.dart';
import 'package:kotarica/web/ads/MyAds/ProductTitleImageMyAdsWeb.dart';
import 'package:kotarica/web/ads/MyAds/colorSizeMyAdsWeb.dart';
import 'package:kotarica/web/ads/MyAds/descriptionMyAdsWeb.dart';
import 'package:kotarica/web/screens/details/components/add_to_cart.dart';
import 'package:kotarica/web/screens/details/components/color_and_size.dart';
import 'package:kotarica/web/screens/details/components/counter_with_fav_btn.dart';
import 'package:kotarica/web/screens/details/components/description.dart';
import 'package:kotarica/web/screens/details/components/product_title_with_image.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../HomeScreen.dart';
import 'itemCard.dart';

//za vrednosti u radioButtonu
enum Currency { RSD, Ether }
Currency _character = Currency.RSD;

bool _filtered = false;
bool _dontShowBottomIndexLine = true;

var _vrednost;
String _izabranaKategorija;
String _izabranaPotkategorija;

String NovaAdresa = "";
String adresa;

TextEditingController _minPriceController = new TextEditingController(text: '');
TextEditingController _maxPriceController = new TextEditingController(text: '');

/* Gradovi dropdown */
const String cities = StringConstants.cities;
List<dynamic> citiesList = json.decode(cities);
List<DropdownMenuItem<String>> _dropdownMenuItems;
String _selectedItem;

/* Tip dropdown */
const String nudimTrazim = '["Nudim","Tražim"]';
List<dynamic> nudimTrazimLista = json.decode(nudimTrazim);
List<DropdownMenuItem<String>> _dropDownMenuItemsNudimTrazim;
String _izabranoNudimTrazim;

class BodyWeb extends StatefulWidget {
  String staraIzabranaKategorija;
  String staraIzabranaPotkategorija;

  BodyWeb({this.staraIzabranaKategorija, this.staraIzabranaPotkategorija});
  @override
  _State createState() => _State(staraIzabranaKategorija, staraIzabranaPotkategorija);
}

class _State extends State<BodyWeb> {
  int _id;

  String staraIzabranaKategorija;
  String staraIzabranaPotkategorija;

  _State(this.staraIzabranaKategorija, this.staraIzabranaPotkategorija);

  //load funkcije
  Future<int> _loadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt("id");
  }

  Future<String> _loadData(String dataNeeded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = prefs.getString(dataNeeded);
    return data;
  }

  /* Kategorije dropdown */
  /* -------KATEGORIJE ------ */
  /* Lista kategorija */
  final List<dynamic> kategorijeLista =
      json.decode(StringConstants.kategorije); // lista kategorija
  List<DropdownMenuItem<String>> _dropDownMenuItemsKategorija;

  @override
  void initState() {
    super.initState();

    /* Za gradove dropdown */
    _dropdownMenuItems = buildDropdownMenuItems(citiesList);
     _selectedItem = citiesList[0]; //defaultna vrednost null

    /* Za kategorije dropdown */
    _dropDownMenuItemsKategorija =
        buildDropdownMenuItemsKategorije(kategorijeLista);
    _izabranaKategorija = kategorijeLista[0];

    /* Za tip dropdown */
    _dropDownMenuItemsNudimTrazim =
        buildDropdownMenuItemsNudimTrazim(nudimTrazimLista);
     _izabranoNudimTrazim = nudimTrazimLista[0]; //defaultna vrednost null

    potkategorije = sveKategorijeList;
    potkategorijeIcone = sveKategorijeListIcone;
  }

  /* -------POTKATEGORIJE ------ */
  /* Liste potkategorija */
  List<dynamic> potkategorije = [];
  List<dynamic> potkategorijeIcone = [];
  List<DropdownMenuItem<String>> _dropDownMenuItemsPotkategorija;

  //ikone
  List<dynamic> sveKategorijeListIcone = []; // privremeno
  List<dynamic> potkategorijeMlecneIcone = StringConstants.mlecniIcone;
  List<dynamic> potkategorijeSuhomesnato = StringConstants.suhomesnatoIkone;
  List<dynamic> potkategorijePica = StringConstants.picaIkone;
  List<dynamic> potkategorijeMlin = StringConstants.mlinIkone;
  List<dynamic> potkategorijeSlatkiSpajz = StringConstants.SlatkiSpajzIkone;
  List<dynamic> potkategorijeSlaniSpajz = StringConstants.SlaniSpajzIkone;
  List<dynamic> potkategorijeMed = StringConstants.medIkone;
  List<dynamic> potkategorijeVegan = StringConstants.veganIkone;
  List<dynamic> potkategorijeVoce = StringConstants.voceIkone;
  List<dynamic> potkategorijePovrce = StringConstants.povrceIkone;

  final List<dynamic> sveKategorijeList = []; // privremeno

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
      json.decode(StringConstants.povrce);// lista potkategorija

  // pri promeni kategorije izaberi potkategoriju
  void onChangeCallbackCategories(category) {
    if (category == "Sve kategorije") {
      potkategorije = sveKategorijeList;
      potkategorijeIcone = sveKategorijeListIcone;
    } else if (category == "Mlečni proizvodi") {
      potkategorije = mlecniProizvodiList;
      potkategorijeIcone = potkategorijeMlecneIcone;
      // _dropDownMenuItemsPotkategorija =
      //     buildDropdownMenuItemsPotkategorije(mlecniProizvodiList);
    } else if (category == "Suhomesnato") {
      potkategorije = suhomesnatoList;
      potkategorijeIcone = potkategorijeSuhomesnato;

      // _dropDownMenuItemsPotkategorija =
      //     buildDropdownMenuItemsPotkategorije(suhomesnatoList);
    } else if (category == "Slani špajz") {
      potkategorije = slaniSpajzList;
      potkategorijeIcone = potkategorijeSlaniSpajz;

      // _dropDownMenuItemsPotkategorija =
      //     buildDropdownMenuItemsPotkategorije(slaniSpajzList);
    } else if (category == "Slatki špajz") {
      potkategorije = slatkiSpajzList;
      potkategorijeIcone = potkategorijeSlatkiSpajz;

      // _dropDownMenuItemsPotkategorija =
      //     buildDropdownMenuItemsPotkategorije(slatkiSpajzList);
    } else if (category == "Piće") {
      potkategorije = picaList;
      potkategorijeIcone = potkategorijePica;

      // _dropDownMenuItemsPotkategorija =
      //     buildDropdownMenuItemsPotkategorije(picaList);
    } else if (category == "Mlin") {
      potkategorije = mlinList;
      potkategorijeIcone = potkategorijeMlin;
      // _dropDownMenuItemsPotkategorija =
      //     buildDropdownMenuItemsPotkategorije(mlinList);
    } else if (category == "Med") {
      potkategorije = medList;
      potkategorijeIcone = potkategorijeMed;

      // _dropDownMenuItemsPotkategorija =
      //     buildDropdownMenuItemsPotkategorije(medList);
    } else if (category == "Vegan") {
      potkategorije = veganList;
      potkategorijeIcone = potkategorijeVegan;

      // _dropDownMenuItemsPotkategorija =
      //     buildDropdownMenuItemsPotkategorije(veganList);
    }  else if (category == "Voće") {
      potkategorije = voceList;
      potkategorijeIcone = potkategorijeVoce;

      // _dropDownMenuItemsPotkategorija =
      //     buildDropdownMenuItemsPotkategorije(veganList);
    } else if (category == "Povrće") {
      potkategorije = povrceList;
      potkategorijeIcone = potkategorijePovrce;

      // _dropDownMenuItemsPotkategorija =
      //     buildDropdownMenuItemsPotkategorije(veganList);
    } else {
      potkategorije = [];
      potkategorijeIcone = [];
    }

    setState(() {
      _dontShowBottomIndexLine = true;
      _izabranaKategorija = category;
      _izabranaPotkategorija = null;

      Provider.of<ProductModelWeb>(context, listen: false)
          .setTotalCountReady(false);
      Provider.of<ProductModelWeb>(context, listen: false)
          .setProductsReady(false);
      Provider.of<ProductModelWeb>(context, listen: false)
          .getProducts(_izabranaKategorija);
    });
  }

  void onChangeCallbackSubcategories(categories, subcategories) {
    setState(() {
      Provider.of<ProductModelWeb>(context, listen: false)
          .setTotalCountReady(false);
      Provider.of<ProductModelWeb>(context, listen: false)
          .setProductsReady(false);
      Provider.of<ProductModelWeb>(context, listen: false)
          .getProducts(categories, subcategories);
    });
  }

  // FUNKCIJA ZA GRADOVE
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
                color: Tema.dark ? bela : zelena1),
          ),
          value: city,
        ),
      );
    }

    return items;
  }

  // Funkcija za Nudim/trazim
  List<DropdownMenuItem<String>> buildDropdownMenuItemsNudimTrazim(
      List<dynamic> nudimTrazimLista) {
    // ignore: deprecated_member_use
    List<DropdownMenuItem<String>> items = List();
    for (String nt in nudimTrazimLista) {
      items.add(
        DropdownMenuItem(
          child: Text(
            nt,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Tema.dark ? bela : zelena1),
          ),
          value: nt,
        ),
      );
    }

    return items;
  }

  // funkcija za dropdownKategorije
  List<DropdownMenuItem<String>> buildDropdownMenuItemsKategorije(
      List<dynamic> kategorijeLista) {
    // ignore: deprecated_member_use
    List<DropdownMenuItem<String>> items = List();
    for (String category in kategorijeLista) {
      items.add(
        DropdownMenuItem(
          child: Text(
            category,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Tema.dark ? bela : zelena1),
          ),
          value: category,
        ),
      );
    }

    return items;
  }

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    var productModel = Provider.of<ProductModelWeb>(context);
    var size = MediaQuery.of(context).size.width;

    return Positioned(
      left: MediaQuery.of(context).size.width * 0.14,
      child: productModel.getTotalCountReady() &&
              productModel.getProductsReady()
          ? Container(
        color: Tema.dark?darkPozadina:bela,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.68,
              //margin: EdgeInsets.only(left: size * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                    child: /*------DROPDOWN KATEGORIJA------*/
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  top: size * 0.01, left: size * 0.03),
                              child: DropdownButton(
                                hint: Text(
                                  "Izaberite kategoriju",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                                dropdownColor: Tema.dark ? siva2 : bela,
                                elevation: 5,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: crvenaGlavna,
                                ),
                                iconSize: 33.0,
                                value: _izabranaKategorija,
                                style: TextStyle(
                                    color: Tema.dark ? bela : plavaTekst),
                                items: _dropDownMenuItemsKategorija,
                                onChanged: onChangeCallbackCategories,
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                top: size * 0.02,
                                left: size * 0.0,
                                bottom: size * 0.01),
                            child: SizedBox(
                              height:43,
                              width: 120,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                color: crvenaGlavna,
                                onPressed: () {
                                  _filtrirajPretragu();
                                },
                                child: Text(
                                  "Filter".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                  //  Categories(),
                  _izabranaKategorija != "Sve kategorije"
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPaddin),
                          child: SizedBox(
                            height: 105,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: potkategorije.length,
                              itemBuilder: (context, index) =>
                                  buildSubcategory(index),
                            ),
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size * 0.06),
                      //GRID ZA PRIKAZ PO 2 OGLASA JEDAN PORED DRUGOG
                      child: GridView.builder(
                        itemCount: productModel.productsToShowCount,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, //BROJ ELEMENATA U VRSTI
                          mainAxisSpacing: size * 0.03,
                          crossAxisSpacing: size * 0.03,
                        ),
                        itemBuilder: (context, index) => ItemCard(
                            product: productModel.productsToShow[index],
                            press: () async {
                              _id = await _loadId();
                              if (_id !=
                                  productModel.productsToShow[index].ownerId) {
                                prikaziOglas(index);
                              } else {
                                prikaziMojOglas(index);
                              }
                            }),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<void> _filtrirajPretragu() async {
    var size = MediaQuery.of(context).size.width;
    var productModel = Provider.of<ProductModelWeb>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Tema.dark ? darkPozadina : bela,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'Filtiranje pretrage',
            style: TextStyle(
              fontSize: 12.0,
              color: Tema.dark ? svetloZelena : crnaGlavna,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                /*------------NACIN PLACANJA----------------*/
                Column(
                  children: [
                    // Alert za pretragu, minimalna i maksimalna cena
                    /*------------MINIMALNA CENA----------------*/
                    TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Tema.dark ? bela : crnaGlavna,
                      ),
                      controller: _minPriceController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9\.]"))
                      ],
                      cursorColor: Theme.of(context).cursorColor,
                      maxLength: 20,
                      decoration: InputDecoration(
                        labelText: 'Cena od',
                        labelStyle: TextStyle(
                            color: Tema.dark ? svetloZelena : crnaGlavna),
                        helperText: 'Uneti minimalnu cenu pretrage',
                        helperStyle: TextStyle(
                            color: Tema.dark ? svetloZelena : crnaGlavna),
                        suffixIcon: Icon( CupertinoIcons.arrow_turn_left_down,
                            color: Tema.dark ? svetloZelena : siva),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Tema.dark ? svetloZelena : crnaGlavna),
                        ),
                      ),
                    ),
                    /*------------MAKSIMALNA CENA----------------*/
                    TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Tema.dark ? bela : crnaGlavna,
                      ),
                      controller: _maxPriceController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9\.]"))
                      ],
                      cursorColor: Theme.of(context).cursorColor,
                      maxLength: 20,
                      decoration: InputDecoration(
                        labelText: 'Cena do',
                        labelStyle: TextStyle(
                            color: Tema.dark ? svetloZelena : crnaGlavna),
                        helperText: 'Uneti maksimalnu cenu pretrage',
                        helperStyle: TextStyle(
                            color: Tema.dark ? svetloZelena : crnaGlavna),
                        suffixIcon: Icon( CupertinoIcons.arrow_turn_left_up,
                            color: Tema.dark ? svetloZelena : crnaGlavna),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Tema.dark ? svetloZelena : crnaGlavna),
                        ),
                      ),
                    ),
                  ],
                ),
                /*------------GRAD----------------*/
                Text("Odaberite grad",
                    style: TextStyle(
                        color: Tema.dark ? svetloZelena : plavaTekst,
                        fontWeight: FontWeight.bold)),
                Padding(
                  padding: EdgeInsets.only(right: size * 0.00001),
                  child: DropdownButtonFormField(
                    dropdownColor: Tema.dark ? siva2 : bela,
                    hint: Text(
                      "Grad",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Tema.dark ? svetloZelena : zelenaGlavna,
                      ),
                    ),
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.all(size * 0.05),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: zelenaGlavna,
                        ),
                      ),
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
                Text(
                  "Izaberite način plaćanja",
                  style: TextStyle(
                      color: Tema.dark ? svetloZelena : crnaGlavna,
                      fontWeight: FontWeight.bold),
                ),
                /*------------TIP----------------*/
                RadioButton(),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Divider(
                    height: 20.0,
                    color: Tema.dark ? svetloZelena : crnaGlavna,
                  ),
                ),
                Text("Ponude/Potražnje",
                    style: TextStyle(
                        color: Tema.dark ? svetloZelena : plavaTekst,
                        fontWeight: FontWeight.bold)),

                Padding(
                  padding: EdgeInsets.only(right: size * 0.00001),
                  child: DropdownButtonFormField(
                    hint: Text(
                      "Ponuda/Potražnja",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: zelenaGlavna,
                      ),
                    ),
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.all(size * 0.05),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: zelenaGlavna,
                        ),
                      ),
                    ),
                    dropdownColor: Tema.dark ? siva2 : bela,
                    //elevation: 5,
                    //iconSize: 36.0,
                    style: TextStyle(color: plavaGlavna),
                    value: _izabranoNudimTrazim,
                    items: _dropDownMenuItemsNudimTrazim,
                    onChanged: (value) {
                      setState(() {
                        _izabranoNudimTrazim = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          actions: <Widget>[
            _filtered
                ? FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              color: crvenaGlavna,
              onPressed: () {
                /* Resetuj listu */
                productModel.setTotalCountReady(false);
                productModel.setProductsReady(false);
                productModel.setPrivateKey();

                setState(() {
                  _filtered = false;
                });

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreenWeb()),
                        (Route<dynamic> route) => false);
              },
              child: Text(
                "Resetuj".toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: belaGlavna,
                ),
              ),
            )
                : Container(),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              color: zelenaGlavna,
              onPressed: () {
                /* Filtriraj listu productsToShow */
                productModel.filterProductsToShow(
                    _character,
                    _minPriceController.text,
                    _maxPriceController.text,
                    _izabranoNudimTrazim,
                    _selectedItem);
                Navigator.of(context).pop();
                setState(() {
                  _filtered = true;
                });

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreenWeb()));
              },
              child: Text(
                "Potvrdi".toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: crnaGlavna,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  int selectedIndex = 0;
  List proba = [];

  // POTKATEGORIJE
  Widget buildSubcategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          _dontShowBottomIndexLine = false;

          onChangeCallbackSubcategories(
              _izabranaKategorija, potkategorije[selectedIndex]);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
                child: CircleAvatar(
              radius: 40,
              backgroundColor: svetloZelena,
              backgroundImage: potkategorijeIcone[index],
            )),
            // potkategorijeIcone[index] ),
            Center(
              child: Text(
                potkategorije[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: selectedIndex == index ? kTextColor : kNaslovOglasa,
                  color: selectedIndex == index
                      ? Tema.dark
                          ? bela
                          : plavaTekst
                      : Tema.dark
                          ? svetloZelena
                          : crnaGlavna,
                ),
              ),
            ),
            _dontShowBottomIndexLine
                ? Container()
                : Container(
                    margin: EdgeInsets.only(
                        top: kDefaultPaddin / 4), //top padding 5
                    height: 1,
                    width: potkategorije[index].length * 8.0,
                    color: selectedIndex == index
                        ? Colors.black
                        : Colors.transparent,
                  )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      foregroundColor: bela,
      backgroundColor: zelena1,
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Image.asset(
            "images/icons/search.png",
            color: bela,
          ),
          onPressed: () {
            showSearch(
                context: context,
                delegate: DataSearch(
                    Provider.of<ProductModelWeb>(context, listen: false)
                        .productsToShow));
          },
        ),
        IconButton(
          icon: Image.asset(
            "images/icons/cart.png",
            // By default our  icon color is white
            color: bela,
          ),
          onPressed: () {},
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }

  Future<void> prikaziOglas(int index) async {
    var productModel = Provider.of<ProductModelWeb>(context, listen: false);

    var size = MediaQuery.of(context).size;
    var product = productModel.productsToShow[index];
    // bool val = Tema.dark;
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
              child: AlertDialog(
                backgroundColor: Tema.dark? darkPozadina:bela,
                insetPadding: EdgeInsets.all(40),
            content: Container(
              width: 900,
              height: size.height,
              color: Tema.dark?darken(product.color,.3):product.color,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: size.height,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            //BELI DEO NA OGLASU
                            margin: EdgeInsets.only(
                                top: size.height * 0.32,
                                left: size.height * 0.02,
                                right: size.height * 0.02),
                            padding: EdgeInsets.only(
                              top: size.height * 0.02,
                              left: kDefaultPaddin,
                              right: kDefaultPaddin,
                            ),
                            // height: 500,
                            decoration: BoxDecoration(
                              color:
                              Tema.dark ? darkPozadina : bela, //DONJI DEO
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                  //opciono
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24)),
                            ),
                            child: SingleChildScrollView(
                              ///DODALA SAM ZBOG SCROL-A NA MANJEM UREDJAJU
                              child: Column(
                                children: <Widget>[
                                  ColorAndSizeWeb(product: product),
                                  // SizedBox(height: kDefaultPaddin / 5),
                                  DescriptionWeb(product: product), //user
                                  SizedBox(height: kDefaultPaddin / 2),
                                  CounterWithFavBtnWeb(product: product),
                                  SizedBox(height: kDefaultPaddin / 2),
                                  if (product.type == "Nudim")
                                    AddToCartWeb(product: product)
                                ],
                              ),
                            ),
                          ),
                          ProductTitleWithImageWeb(product: product),
                          Container(
                            color: Tema.dark?darken(product.color,.3):product.color,

                            margin:EdgeInsets.only(top:5,left:5),
                            child:  FlatButton(
                              height: 20,
                              minWidth: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(130)),
                              color: Tema.dark?darkPozadina:bela,
                              onPressed: () {
                                //select(0);
                                Navigator.of(context).pop();

                              },
                              child:
                              Icon(Icons.arrow_back,color: product.color,size: 40,),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
        });
  }

  Future<void> prikaziMojOglas(int index) async {
    var productModel = Provider.of<ProductModelWeb>(context, listen: false);

    //print("DDD");
    var size = MediaQuery.of(context).size;
    var product = productModel.productsToShow[index];
    bool val = Tema.dark;
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
              //color: Tema.dark?darkPozadina:bela,
              child: AlertDialog(
                backgroundColor: Tema.dark? darkPozadina:bela,
                insetPadding: EdgeInsets.all(40),
                content: Container(
              width: 900,
              height: size.height,
              color: Tema.dark?darken(product.color,.3):product.color,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: size.height*0.8,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: size.height * 0.32,
                                left: size.height * 0.02,
                                right: size.height * 0.02),
                            padding: EdgeInsets.only(
                              top: size.height * 0.02,
                              left: kDefaultPaddin,
                              right: kDefaultPaddin,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Tema.dark ? darkPozadina : bela, //DONJI DEO
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                  //opciono
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24)),
                            ),
                            child: Column(
                              children: <Widget>[
                                ColorAndSizeMyAdsWeb(product: product),
                                SizedBox(height: kDefaultPaddin / 2),
                                DescriptionMyAdsWeb(product: product),
                                SizedBox(height: kDefaultPaddin / 2),
                                DeleteChangeWeb(product: product),
                              ],
                            ),
                          ),
                          ProductTitleWithImageMyAdsWeb(product: product),
                          Container(
                            color: Tema.dark?darken(product.color,.3):product.color,
                            margin:EdgeInsets.only(top:5,left:5),
                            child:  FlatButton(
                              height: 20,
                              minWidth: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(130)),
                              color: Tema.dark?darkPozadina:bela,
                              onPressed: () {
                                Navigator.of(context).pop();

                              },
                              child:
                              Icon(Icons.arrow_back,color:Tema.dark? product.color: product.color,size: 40,),
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
        });
  }
}

/*=============KLASA ZA RADIOBUTTON ZA RSD ILI ETHER=================*/
class RadioButton extends StatefulWidget {
  const RadioButton({Key key}) : super(key: key);

  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          selectedTileColor: zelena1,
          focusColor: zelena1,
          title: const Text('RSD'),
          leading: Radio<Currency>(
            activeColor: zelena1,
            focusColor: zelena1,
            value: Currency.RSD,
            groupValue: _character,
            onChanged: (Currency value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          selectedTileColor: zelena1,
          focusColor: zelena1,
          title: const Text('Ether'),
          leading: Radio<Currency>(
            activeColor: zelena1,
            value: Currency.Ether,
            groupValue: _character,
            onChanged: (Currency value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
