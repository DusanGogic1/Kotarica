import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/web/home/components/itemCard.dart';
import 'package:kotarica/web/home/screens/details/details_screenWeb.dart';

class SearchResults extends StatefulWidget {
  List<Product> products;
  final String query;

  SearchResults(this.products, this.query);

  @override
  _State createState() => _State(this.products, this.query);
}

class _State extends State<SearchResults> {
  List<Product> products;
  List<Product> suggestions = [];
  String query;

  _State(this.products, this.query);

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      body: GridView.builder(
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
                builder: (context) => DetailsScreenWeb(
                  product: _searchResults[index],
                ),
              )),
        ),
      ),
    );
  }
}
