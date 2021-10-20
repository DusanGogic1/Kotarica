import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/screens/details/details_screen.dart';
import 'package:kotarica/web/ads/AddAdvertPageOneWeb.dart';
import 'package:kotarica/web/ads/SavedAds/savedAdsPage.dart';
import 'package:kotarica/web/ads/SearchResults.dart';
import 'package:kotarica/web/home/CalendarSpace/CalendarSpace.dart';
import 'package:kotarica/web/home/components/body.dart';
import 'package:kotarica/chat/ChatMain.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/notification/notificationPage.dart';


import 'NavigationBar/NavigationBar.dart';
import 'components/itemCard.dart';

var currentIndex = 0;
class HomeScreenWeb extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenWeb> {

  _HomeScreenState();


  @override
  Widget build(BuildContext context) {
    setState(() {});

    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            NavigationBar(),
            BodyWeb(),
            CalendarSpace(),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(right: size * 0.03, bottom: size * 0.01),
        height: size * 0.06,
        width: size * 0.06,
        child: FloatingActionButton(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
  backgroundColor: Tema.dark? darkPozadina:bela,
    );
  }
}

//klasa za navigation bar
BubbleBottomBar buildBottomBar(BuildContext context) {
  return BubbleBottomBar(
    opacity: 0.2,
    backgroundColor: Colors.blueGrey[100],
    borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    currentIndex: currentIndex,
    hasInk: true,
    inkColor: Colors.black12,
    hasNotch: true,
    fabLocation: BubbleBottomBarFabLocation.end,
    items: <BubbleBottomBarItem>[
      //POCETNA
      BubbleBottomBarItem(
          backgroundColor: belaGlavna,
          icon: IconButton(
            icon: Icon(Icons.dashboard),
            color: Colors.black,
            onPressed: () {
              currentIndex = 0;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreenWeb()));
            },
          ),
          activeIcon: Icon(
            Icons.dashboard,
            color: crvenaGlavna,
          ),
          title: Text("Početna",
              style: TextStyle(
                fontSize: 12.0,
                color: zelena1,
              ))),
      //INBOX
      BubbleBottomBarItem(
          backgroundColor: belaGlavna,
          icon: IconButton(
            icon: Icon(Icons.inbox),
            color: Colors.black,
            onPressed: () {
              currentIndex = 1;
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
                color: zelena1,
              ))),

      //OBAVESTENJA
      BubbleBottomBarItem(
          backgroundColor: belaGlavna,
          icon: IconButton(
              icon: Icon(Icons.notifications_none),
              color: Colors.black,
              onPressed: () {
                currentIndex = 2;
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
                color: zelena1,
              ))),
      //SACUVANI OGLASI
      BubbleBottomBarItem(
          backgroundColor: belaGlavna,
          icon: IconButton(
            icon: Icon(Icons.star_border),
            color: Colors.black,
            onPressed: () {
              currentIndex = 3;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SavedAdsPageWeb()));
            },
          ),
          activeIcon: Icon(
            Icons.star,
            color: crvenaGlavna,
          ),
          title: Text("Sačuvani",
              style: TextStyle(
                fontSize: 10.0,
                color: zelena1,
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
        icon: Icon(Icons.search),
        onPressed: () {
          print("Products count: " + products.length.toString());

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SearchResults(products, query)));
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
              Text('Polje pretrage ne sme ostati prazno'),
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
              itemBuilder: (context, index) => ItemCard(
                product: _searchResults[index],
                press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
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
