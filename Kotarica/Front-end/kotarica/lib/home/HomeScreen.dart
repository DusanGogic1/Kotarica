import 'dart:async';
import 'dart:ui' as ui;

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/ads/MyAds/DetailsScreenMyAds.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/models/SavedAdsModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/screens/details/details_screen.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ads/SavedAds/savedAdsPage.dart';
import 'package:kotarica/chat/ChatMain.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/components/body.dart';
import 'package:kotarica/notification/notificationPage.dart';

import '../constants/navigation_drawer/maindrawer.dart';
import '../constants/style.dart';
import 'components/itemCard.dart';

var currentIndex;
PageController _pageController;

class HomeScreen extends StatefulWidget {
  String izabranaKategorija;
  String izabranaPotkategorija;

  HomeScreen({this.izabranaKategorija, this.izabranaPotkategorija});

  @override
  _HomeScreenState createState() =>
      _HomeScreenState(izabranaKategorija, izabranaPotkategorija);
}

class _HomeScreenState extends State<HomeScreen> {
  String izabranaKategorija;
  String izabranaPotkategorija;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;
    _pageController = PageController(initialPage: 0);
  }

  _HomeScreenState(this.izabranaKategorija, this.izabranaPotkategorija);

  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size.width;
    return Scaffold(
      //appBar: buildAppBar(context),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            currentIndex = newIndex;
          });
        },
        children: [
          Body(
              staraIzabranaKategorija: izabranaKategorija,
              staraIzabranaPotkategorija: izabranaPotkategorija),
          MainPageChat(),
          NotificationPage(),
          SavedAdsPage()
        ],
      ),
    );
  }
}

// klasa za navigation bar
BubbleBottomBar buildBottomBar(BuildContext context) {
  return BubbleBottomBar(
    elevation: 10,
    opacity: 0.2,
    backgroundColor: Tema.dark ? Colors.blueGrey[700] : Colors.blueGrey[100],
    borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    currentIndex: currentIndex,
    hasInk: true,
    inkColor: Colors.black26,
    hasNotch: true,
    fabLocation: BubbleBottomBarFabLocation.end,
    items: <BubbleBottomBarItem>[
      //POCETNA
      BubbleBottomBarItem(
          backgroundColor: belaGlavna,
          icon: IconButton(
            icon: Icon(Icons.dashboard),
            color: Tema.dark ? Colors.white : Colors.black,
            onPressed: () {
              currentIndex = 0;
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          activeIcon: Icon(
            Icons.dashboard,
            color: crvenaGlavna,
          ),
          title: Text("Početna",
              style: TextStyle(
                fontSize: 12.0,
                color: Tema.dark ? svetloZelena : zelena1,
              ))),
      //INBOX
      BubbleBottomBarItem(
          backgroundColor: belaGlavna,
          icon: IconButton(
            icon: Icon(Icons.inbox),
            color: Tema.dark ? Colors.white : Colors.black,
            onPressed: () {
              currentIndex = 1;
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainPageChat()));
            },
          ),
          activeIcon: Icon(
            Icons.inbox,
            color: crvenaGlavna,
          ),
          title: Text("Poruke",
              style: TextStyle(
                fontSize: 12.0,
                color: Tema.dark ? svetloZelena : zelena1,
              ))),

      //OBAVESTENJA
      BubbleBottomBarItem(
          backgroundColor: belaGlavna,
          icon: IconButton(
              icon: Icon(Icons.notifications_none),
              color: Tema.dark ? Colors.white : Colors.black,
              onPressed: () {
                currentIndex = 2;
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage()));
              }),
          activeIcon: Icon(
            Icons.notifications_none,
            color: crvenaGlavna,
          ),
          title: Text("Obaveštenja",
              style: TextStyle(
                fontSize: 9.0,
                color: Tema.dark ? svetloZelena : zelena1,
              ))),
      //SACUVANI OGLASI
      BubbleBottomBarItem(
          backgroundColor: belaGlavna,
          icon: IconButton(
            icon: Icon(Icons.bookmark),
            color: Tema.dark ? Colors.white : Colors.black,
            onPressed: () {
              Provider.of<SavedAdsModel>(context, listen: false).getSavedAds();

              currentIndex = 3;
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SavedAdsPage()));
            },
          ),
          activeIcon: Icon(
            Icons.bookmark,
            color: crvenaGlavna,
          ),
          title: Text("Lista želja",
              style: TextStyle(
                fontSize: 10.0,
                color: Tema.dark ? svetloZelena : zelena1,
              )))
    ],
  );
}

class DataSearch extends SearchDelegate<String> {
  List<Product> products;
  List<Product> suggestions = [];

  DataSearch(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    // akcija za app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    /* Implementacija pretrazivanja */

    var size = MediaQuery.of(context).size.width;
    List<Product> _searchResults = [];
    int _searchResultsCount = 0;

    List<Product> _titleSearchResults = [];
    int _titleSearchResultsCount = 0;
    List<Product> _categorySearchResults = [];
    int _categorySearchResultsCount = 0;
    List<Product> _subcategorySearchResults = [];
    int _subcategorySearchResultsCount = 0;
    List<Product> _aboutSearchResults = [];
    int _aboutSearchResultsCount = 0;

    List<Product> _searchResultsToShow = [];
    int _searchResultsToShowCount = 0;

    for (var i = 0; i < products.length; i++) {
      var _title = (products[i].title).toLowerCase().trim();
      var _about = (products[i].about).toLowerCase().trim();
      var _category = (products[i].category).toLowerCase().trim();
      var _subcategory = (products[i].subcategory).toLowerCase().trim();

      if (_title.contains(query.toLowerCase().trim()) ||
          _category.contains(query.toLowerCase().trim()) ||
          _subcategory.contains(query.toLowerCase().trim()) ||
          _about.contains(query.toLowerCase().trim())) {
        _searchResults.add(products[i]);
        _searchResultsCount++;
      }

      if (_title.contains(query.toLowerCase().trim())) {
        _titleSearchResults.add(products[i]);
        _titleSearchResultsCount++;
      } else if (_category.contains(query.toLowerCase().trim())) {
        _categorySearchResults.add(products[i]);
        _categorySearchResultsCount++;
      } else if (_subcategory.contains(query.toLowerCase().trim())) {
        _subcategorySearchResults.add(products[i]);
        _subcategorySearchResultsCount++;
      } else if (_about.contains(query.toLowerCase().trim())) {
        _aboutSearchResults.add(products[i]);
        _aboutSearchResultsCount++;
      }
    }

    _searchResultsToShowCount = _searchResultsCount;
    _searchResultsToShow = _searchResults;

    int selectedIndex = 0;
    List _tabs = [
      'Svi rezultati',
      'Naziv',
      'Kategorija',
      'Potkategorija',
      'Opis'
    ];

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          query.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
                  child: SizedBox(
                    height: 24,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            switch (selectedIndex) {
                              case 0:
                                {
                                  _searchResultsToShowCount =
                                      _searchResultsCount;
                                  _searchResultsToShow = _searchResults;
                                }
                                break;
                              case 1:
                                {
                                  _searchResultsToShowCount =
                                      _titleSearchResultsCount;
                                  _searchResultsToShow = _titleSearchResults;
                                }
                                break;
                              case 2:
                                {
                                  _searchResultsToShowCount =
                                      _categorySearchResultsCount;
                                  _searchResultsToShow = _categorySearchResults;
                                }
                                break;
                              case 3:
                                {
                                  _searchResultsToShowCount =
                                      _subcategorySearchResultsCount;
                                  _searchResultsToShow =
                                      _subcategorySearchResults;
                                }
                                break;
                              case 4:
                                {
                                  _searchResultsToShowCount =
                                      _aboutSearchResultsCount;
                                  _searchResultsToShow = _aboutSearchResults;
                                }
                                break;
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPaddin),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _tabs[index],
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
                              Container(
                                margin: EdgeInsets.only(
                                    top: kDefaultPaddin / 4), //top padding 5
                                height: 1,
                                width: _tabs[index].length * 8.0,
                                color: selectedIndex == index
                                    ? Colors.black
                                    : Colors.transparent,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          query.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size * 0.04),
                    // Grid za prikaz po 2 oglasa
                    child: GridView.builder(
                      itemCount: _searchResultsToShowCount,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //BROJ ELEMENATA U VRSTI
                        mainAxisSpacing: size * 0.03,
                        crossAxisSpacing: size * 0.03,
                      ),
                      itemBuilder: (context, index) => ItemCard(
                        product: _searchResultsToShow[index],
                        press: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                product: _searchResultsToShow[index],
                              ),
                            )),
                      ),
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(
                      top: size * 0.01, left: size * 0.1, right: size * 0.05),
                  child: Image(
                    image: AssetImage('images/empty_search.png'),
                  ),
                ),
        ],
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // PREDLAAZE SUGESTIJE
    final suggestionList = query.isEmpty
        ? suggestions
        : products
            .where((p) => p.title.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
          onTap: () {
            showResults(context);
          },
          title: RichText(
            text: TextSpan(
                text: suggestionList[index].title.substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: suggestionList[index].title.substring(query.length),
                      style: TextStyle(color: Colors.grey))
                ]),
          )),
      itemCount: suggestionList.length,
    );
  }
}

class ResultsPage extends StatefulWidget {
  String query;
  List<Product> products;
  List<Product> suggestions = [];

  ResultsPage(this.query, this.products, this.suggestions);

  @override
  _ResultsPageState createState() =>
      _ResultsPageState(query, products, suggestions);
}

class _ResultsPageState extends State<ResultsPage> {
  int _id;

  String query;
  List<Product> products;
  List<Product> suggestions = [];

  int selectedIndex;
  final List _tabs = [
    'Svi rezultati',
    'Naziv',
    'Kategorija',
    'Potkategorija',
    'Opis'
  ];

  List<Product> _searchResults;
  int _searchResultsCount;

  List<Product> _titleSearchResults;
  int _titleSearchResultsCount;
  List<Product> _categorySearchResults;
  int _categorySearchResultsCount;
  List<Product> _subcategorySearchResults;
  int _subcategoryearchResultsCount;
  List<Product> _aboutSearchResults;
  int _aboutSearchResultsCount;

  List<Product> _searchResultsToShow;
  int _searchResultsToShowCount;

  _ResultsPageState(this.query, this.products, this.suggestions);

  Image emptySearchImage;
  int emptySearchWidth;
  int emptySearchHeight;
  bool emptySearchImageReady;

  Future<int> _loadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt("id");
  }

  void _getEmptySearchImage() async {
    emptySearchImage = Image(image: AssetImage('images/empty_search.png'));
    Completer<ui.Image> completer = new Completer<ui.Image>();

    emptySearchImage.image
        .resolve(new ImageConfiguration())
        .addListener(new ImageStreamListener((ImageInfo image, bool _) {
      completer.complete(image.image);
    }));

    ui.Image info = await completer.future;
    emptySearchWidth = info.width;
    emptySearchHeight = info.height;

    emptySearchImageReady = true;
  }

  @override
  void initState() {
    emptySearchImageReady = false;
    _getEmptySearchImage();

    _searchResults = [];
    _searchResultsCount = 0;

    _titleSearchResults = [];
    _titleSearchResultsCount = 0;
    _categorySearchResults = [];
    _categorySearchResultsCount = 0;
    _subcategorySearchResults = [];
    _subcategoryearchResultsCount = 0;
    _aboutSearchResults = [];
    _aboutSearchResultsCount = 0;

    _searchResultsToShow = [];
    _searchResultsToShowCount = 0;

    selectedIndex = 0;

    print("PRODUCTS IN RESULTS: ");
    for (var i = 0; i < products.length; i++) {
      print(products[i].title);
    }

    for (var i = 0; i < products.length; i++) {
      var _title = (products[i].title).toLowerCase().trim();
      var _about = (products[i].about).toLowerCase().trim();
      var _category = (products[i].category).toLowerCase().trim();
      var _subcategory = (products[i].subcategory).toLowerCase().trim();

      if (_title.contains(query.toLowerCase().trim()) ||
          _category.contains(query.toLowerCase().trim()) ||
          _subcategory.contains(query.toLowerCase().trim()) ||
          _about.contains(query.toLowerCase().trim())) {
        _searchResults.add(products[i]);
        _searchResultsCount++;
      }

      if (_title.contains(query.toLowerCase().trim())) {
        _titleSearchResults.add(products[i]);
        _titleSearchResultsCount++;
      } else if (_category.contains(query.toLowerCase().trim())) {
        _categorySearchResults.add(products[i]);
        _categorySearchResultsCount++;
      } else if (_subcategory.contains(query.toLowerCase().trim())) {
        _subcategorySearchResults.add(products[i]);
        _subcategoryearchResultsCount++;
      } else if (_about.contains(query.toLowerCase().trim())) {
        _aboutSearchResults.add(products[i]);
        _aboutSearchResultsCount++;
      }
    }

    _searchResultsToShowCount = _searchResultsCount;
    _searchResultsToShow = _searchResults;
  }

  @override
  Widget build(BuildContext context) {
    var productModel = Provider.of<ProductModel>(context, listen: false);
    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "Rezultati pretrage",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                      color: belaGlavna,
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
            ],
          ),
        ),
        foregroundColor: bela,
        backgroundColor: Tema.dark ? zelenaDark : zelena1,
        elevation: 0,
      ),
      backgroundColor: Tema.dark ? darkPozadina : bela,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          query.isNotEmpty && productModel.getProductsReady()
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
                  child: SizedBox(
                    height: 24,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            switch (selectedIndex) {
                              case 0:
                                {
                                  _searchResultsToShowCount =
                                      _searchResultsCount;
                                  _searchResultsToShow = _searchResults;
                                }
                                break;
                              case 1:
                                {
                                  _searchResultsToShowCount =
                                      _titleSearchResultsCount;
                                  _searchResultsToShow = _titleSearchResults;
                                }
                                break;
                              case 2:
                                {
                                  _searchResultsToShowCount =
                                      _categorySearchResultsCount;
                                  _searchResultsToShow = _categorySearchResults;
                                }
                                break;
                              case 3:
                                {
                                  _searchResultsToShowCount =
                                      _subcategoryearchResultsCount;
                                  _searchResultsToShow =
                                      _subcategorySearchResults;
                                }
                                break;
                              case 4:
                                {
                                  _searchResultsToShowCount =
                                      _aboutSearchResultsCount;
                                  _searchResultsToShow = _aboutSearchResults;
                                }
                                break;
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPaddin),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _tabs[index],
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
                              Container(
                                margin: EdgeInsets.only(
                                    top: kDefaultPaddin / 4), //top padding 5
                                height: 1,
                                width: _tabs[index].length * 8.0,
                                color: selectedIndex == index
                                    ? Colors.black
                                    : Colors.transparent,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          query.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size * 0.04),
                    // Grid za prikaz po 2 oglasa
                    child: GridView.builder(
                      itemCount: _searchResultsToShowCount,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //BROJ ELEMENATA U VRSTI
                        mainAxisSpacing: size * 0.03,
                        crossAxisSpacing: size * 0.03,
                      ),
                      itemBuilder: (context, index) => ItemCard(
                          product: _searchResultsToShow[index],
                          press: () async {
                            _id = await _loadId();

                            if (_id != _searchResultsToShow[index].ownerId) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                    product: _searchResultsToShow[index],
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreenMyAds(
                                    product: _searchResultsToShow[index],
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                  ),
                )
              : Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: size * 0.6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        emptySearchImageReady
                            ? Container(
                                width: emptySearchWidth / 2,
                                height: emptySearchHeight / 2,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: emptySearchImage,
                                ))
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
