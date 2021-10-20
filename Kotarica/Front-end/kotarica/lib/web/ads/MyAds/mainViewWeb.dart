import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/ads/AddAdvertPageOneWeb.dart';
import 'package:kotarica/web/ads/MyAds/item_cardMyAdsWeb.dart';
import 'package:kotarica/web/home/CalendarSpace/CalendarSpace.dart';
import 'package:kotarica/web/home/NavigationBar/NavigationBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DetailsScreenMyAdsWeb.dart';
import 'bodyMyAdsWeb.dart';

class mainViewWeb extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<mainViewWeb> {
  String ime;
  Future<String> _loadData(String dataNeeded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = prefs.getString(dataNeeded);
    return data;
  }

  Future<void> _GetUsername() async {
    String username;
    username = await _loadData("username");
    setState(() => ime = username);
  }

  void initState() {
    super.initState();
    _GetUsername();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var productModel = Provider.of<ProductModelWeb>(context, listen: false);
    //NavBar.select2(2);
    return Scaffold(
      body: Container(
        color: Tema.dark?darkPozadina:bela,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            NavigationBar(),
            BodyMyAdsWeb(),
            //CartScreenWeb(),
            CalendarSpace(),
          ],
        ),

      ),
       floatingActionButton: Container(
         margin: EdgeInsets.only(right: size * 0.03, bottom: size * 0.01),
         height: size * 0.06,
         width: size * 0.06,
         child: FloatingActionButton(
           heroTag: "btn1",
           child: Icon(
            Icons.pending_actions,
           color: bela,
             size: size * 0.03,
           ),
           onPressed: () {
             Navigator.push(context,
                 MaterialPageRoute(builder: (context) => AddAdvertPageOneWeb()));
           },
           backgroundColor: Color.fromRGBO(202, 59, 50, 1),
         ),
       ),
        backgroundColor: Tema.dark?bela:crnaGlavna
    );
  }
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

    if (query.isEmpty) {
      return AlertDialog(
        title: Text(
          'Greška pri pretraživanju',
          style: TextStyle(
            color: zelena1,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Polje za pretragu ne sme ostati prazno'),
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
            },
          ),
        ],
      );
    }

    for (var i = 0; i < products.length; i++) {
      var _title = (products[i].title).toLowerCase();
      var _category = (products[i].category).toLowerCase();
      var _subcategory = (products[i].subcategory).toLowerCase();

      if (_title.contains(query.toLowerCase()) ||
          _category.contains(query.toLowerCase()) ||
          _subcategory.contains(query.toLowerCase())) {
        _searchResults.add(products[i]);
        _searchResultsCount++;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.04),
            // Grid za prikaz po 2 oglasa
            child: GridView.builder(
              itemCount: _searchResultsCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //BROJ ELEMENATA U VRSTI
                mainAxisSpacing: size * 0.03,
                crossAxisSpacing: size * 0.03,
              ),
              itemBuilder: (context, index) => ItemCardMyAdsWeb(
                product: _searchResults[index],
                press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreenMyAdsWeb(
                        product: _searchResults[index],
                      ),
                    )),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // PREDLAAZE SUGESTIJE
    final suggestionList = query.isEmpty
        ? suggestions
        : products.where((p) => p.title.toLowerCase().startsWith(query.toLowerCase())).toList();

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