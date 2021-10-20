import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kotarica/ads/AddAdvertPageOne.dart';
import 'package:kotarica/ads/MyAds/DetailsScreenMyAds.dart';
import 'package:kotarica/ads/SavedAds/savedAdsPage.dart';
import 'package:kotarica/cart/cart_screen.dart';
import 'package:kotarica/chat/ChatMain.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/navigation_drawer/maindrawer.dart';
import 'package:kotarica/constants/strings.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/models/BuyingModel.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/notification/notificationPage.dart';
import 'package:kotarica/screens/details/details_screen.dart';
import 'package:kotarica/web/WebModels/BuyingModelWeb.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ads/MyAds/bodyMyAds.dart';
import '../../constants/style.dart';
import 'categories.dart';
import 'itemCard.dart';

Currency _character = Currency.RSD;
String _adresa = adresa;
final _adresaController = TextEditingController();

var _pages = [HomeScreen(), MainPageChat(), NotificationPage(), SavedAdsPage()];

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
const String nudimTrazim = '["Nudim","Trazim"]';
List<dynamic> nudimTrazimLista = json.decode(nudimTrazim);
List<DropdownMenuItem<String>> _dropDownMenuItemsNudimTrazim;
String _izabranoNudimTrazim;

class Body extends StatefulWidget {
  String staraIzabranaKategorija;
  String staraIzabranaPotkategorija;

  Body({this.staraIzabranaKategorija, this.staraIzabranaPotkategorija});

  @override
  _State createState() =>
      _State(staraIzabranaKategorija, staraIzabranaPotkategorija);
}

class _State extends State<Body> {
  // String _username;
  int _id;

  String staraIzabranaKategorija;
  String staraIzabranaPotkategorija;

  _State(this.staraIzabranaKategorija, this.staraIzabranaPotkategorija);

  Future<int> _loadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt("id");
  }

  Future<String> _loadData(String dataNeeded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = prefs.getString(dataNeeded);
    return data;
  }

  Future<String> _loadAdresa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _name = prefs.getString("personalAddress");
    //print(_name);
    setState(() {
      adresa = _name;
      _adresaController.text = adresa;
    });
    return _name;
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
    // _selectedItem = citiesList[0]; defaultna vrednost null

    /* Za kategorije dropdown */
    _dropDownMenuItemsKategorija =
        buildDropdownMenuItemsKategorije(kategorijeLista);
    _izabranaKategorija = kategorijeLista[0];

    /* Za tip dropdown */
    _dropDownMenuItemsNudimTrazim =
        buildDropdownMenuItemsNudimTrazim(nudimTrazimLista);
    // _izabranoNudimTrazim = nudimTrazimLista[0]; defaultna vrednost null

    potkategorije = sveKategorijeList;
    potkategorijeIcone = sveKategorijeListIcone;

    if (staraIzabranaKategorija != null) {
      _izabranaKategorija = staraIzabranaKategorija;
      onChangeCallbackCategories(_izabranaKategorija);
      if (_izabranaPotkategorija != null) {
        _izabranaPotkategorija = staraIzabranaPotkategorija;
        onChangeCallbackSubcategories(
            _izabranaKategorija, _izabranaPotkategorija);
      }
    }

    print("Stare izabrane: $_izabranaKategorija i $_izabranaPotkategorija");
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
    } else if (category == "Voće") {
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

      Provider.of<ProductModel>(context, listen: false)
          .setTotalCountReady(false);
      Provider.of<ProductModel>(context, listen: false).setProductsReady(false);
      Provider.of<ProductModel>(context, listen: false)
          .getProducts(_izabranaKategorija);
    });
  }

  void onChangeCallbackSubcategories(categories, subcategories) {
    setState(() {
      Provider.of<ProductModel>(context, listen: false)
          .setTotalCountReady(false);
      Provider.of<ProductModel>(context, listen: false).setProductsReady(false);
      Provider.of<ProductModel>(context, listen: false)
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
                color: Tema.dark ? bela : zelenaGlavna),
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
                color: Tema.dark ? bela : zelenaGlavna),
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
    var productModel = Provider.of<ProductModel>(context);
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Tema.dark ? darkPozadina : bela,
      appBar: buildAppBar(context),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top:16.0),
        child: FloatingActionButton(
          heroTag: "btn111",
          child: Icon(
            Icons.pending_actions,
            color: bela,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddAdvertPageOne()));
          },
          backgroundColor: Color.fromRGBO(202, 59, 50, 1),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: buildBottomBar(context),
      body: productModel.getProductsReady()
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //search
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              // onChanged: (newvalue) {
                              //   setState(() {
                              //     _izabranaKategorija = newvalue;
                              //     //print(newvalue);
                              //   });
                              // },
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              top: size * 0.02, left: size * 0.0),
                          child: FlatButton(
                            height: size * 0.09,
                            minWidth: size * 0.30,
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
                      ]),
                ),

                // Categories(_izabranaKategorija),
                _izabranaKategorija != "Sve kategorije"
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: kDefaultPaddin),
                        child: SizedBox(
                          height: 80,
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
                    padding: EdgeInsets.symmetric(horizontal: size * 0.04),
                    //GRID ZA PRIKAZ PO 2 OGLASA JEDAN PORED DRUGOG
                    child: GridView.builder(
                      itemCount: productModel.productsToShowCount,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //BROJ ELEMENATA U VRSTI
                        mainAxisSpacing: size * 0.03,
                        crossAxisSpacing: size * 0.03,
                      ),
                      itemBuilder: (context, index) => ItemCard(
                          product: productModel.productsToShow[index],
                          press: () async {
                            // _username = await _loadUsername();
                            _id = await _loadId();

                            if (_id !=
                                productModel.productsToShow[index].ownerId) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                      product:
                                          productModel.productsToShow[index],
                                    ),
                                  ));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreenMyAds(
                                      product:
                                          productModel.productsToShow[index],
                                    ),
                                  ));
                            }
                          },
                          izabranaKategorija: _izabranaKategorija,
                          izabranaPotkategorija: _izabranaPotkategorija),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
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
          _izabranaPotkategorija = potkategorije[selectedIndex];

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
              radius: 27,
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

  Future<void> _filtrirajPretragu() async {
    var size = MediaQuery.of(context).size.width;
    var productModel = Provider.of<ProductModel>(context, listen: false);

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
                Text("Ponuda/Potražnja",
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
                              builder: (BuildContext context) => HomeScreen()),
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
                    MaterialPageRoute(builder: (context) => HomeScreen()));
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

  AppBar buildAppBar(context) {
    var productModel = Provider.of<ProductModel>(context);
    TextEditingController queryController = new TextEditingController();

    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      title: !isSearching
          ? RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Početna",
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: belaGlavna,
                          fontWeight: FontWeight.bold,
                          fontSize: 25)),
                ],
              ),
            )
          : TextField(
              autofocus: true,
              onSubmitted: (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultsPage(
                        queryController.text, productModel.productsToShow, []),
                  ),
                );
              },
              textInputAction: TextInputAction.search,
              controller: queryController,
              onChanged: (value) {
                // _filterCountries(value);
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintText: "Pretraži oglase",
                  hintStyle: TextStyle(color: Colors.white)),
            ),
      foregroundColor: bela,
      backgroundColor: Tema.dark ? zelenaDark : zelena1,
      elevation: 0,
      actions: <Widget>[
        isSearching && productModel.getProductsReady()
            ? IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    this.isSearching = false;
                    // filteredCountries = countries;
                  });
                },
              )
            : !isSearching && productModel.getProductsReady()
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        this.isSearching = true;
                      });
                    },
                  )
                : Container(),
        IconButton(
          icon: Badge(
            shape: BadgeShape.circle,
            badgeColor: Colors.white,
            badgeContent: Text(
              productModel.getCartLength().toString(),
              style: TextStyle(fontSize: 11, color: zelena1),
            ),
            position: BadgePosition.topEnd(top: -15, end: -15),
            animationType: BadgeAnimationType.scale,
            child: Icon(Icons.shopping_cart_outlined,
                color: Tema.dark ? bela : bela),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CartScreen()));
          },
        ),
        /*Icon(Icons.shopping_cart_outlined, color: Tema.dark ? bela : bela),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CartScreen()));
          },
        ),*/
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}

/*=============KLASA ZA RADIOBUTTON ZA RSD ILI ETHER=================*/
class RadioButton extends StatefulWidget {
  final priceEth;
  const RadioButton({Key key, @required this.priceEth}) : super(key: key);

  @override
  RadioButtonState createState() => RadioButtonState(priceEth);
}

class RadioButtonState extends State<RadioButton> {
  static var character = Currency.RSD;
  final priceEth;

  RadioButtonState(this.priceEth);
  void initState() {
    super.initState();
    setState(() {
      character = Currency.RSD;
    });
  }

  Widget build(BuildContext context) {
    var buyingModel = Provider.of<BuyingModel>(context);
    return Column(
      children: <Widget>[
        ListTile(
          selectedTileColor: zelenaGlavna,
          focusColor: zelenaGlavna,
          title: Text(
            'RSD - pouzećem',
            style: TextStyle(color: Tema.dark ? bela : crnaGlavna),
          ),
          leading: Radio<Currency>(
            activeColor: zelenaGlavna,
            focusColor: zelenaGlavna,
            value: Currency.RSD,
            groupValue: character,
            onChanged: (Currency value) {
              setState(() {
                print(value);
                character = Currency.RSD;
              });
            },
          ),
        ),
        FutureBuilder(
          future: buyingModel.isItBoughtable(priceEth),
          builder: (context, snapshot) {
            print(priceEth);
            if(snapshot.data == true || snapshot.data == null)
            {
              return ListTile(
                selectedTileColor: zelenaGlavna,
                focusColor: zelenaGlavna,
                title: Text('Ether - online',
                    style: TextStyle(color: Tema.dark ? bela : crnaGlavna)),
                leading: Radio<Currency>(
                  activeColor: zelenaGlavna,
                  value: Currency.Ether,
                  groupValue: character,
                  onChanged: (Currency value) {
                    setState(() {
                      print(value);
                      character = Currency.Ether;
                    });
                    },
                  ),
                );
              }
            else return Container(
              alignment: Alignment.center,
              child: Text("Nemate dovoljno novca da bi kupovali u kriptovalutama.\n", style: TextStyle(color:Tema.dark?bela:Colors.black)),);
          }
        ),
      ],
    );
  }
}

Future<String> _loadData(String dataNeeded) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String data = prefs.getString(dataNeeded);
  return data;
}

Future<String> _loadAdresa() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String _name = prefs.getString("personalAddress");
  print(_name);
  return _name;
}
