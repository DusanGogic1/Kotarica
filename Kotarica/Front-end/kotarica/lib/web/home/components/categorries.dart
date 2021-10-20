import 'package:flutter/material.dart';


import 'package:kotarica/constants/style.dart';

//POTKATEGORIJE!

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List _potkateogrijee = [
    'Sir',
    'Kajmak',
    'Mleko',
    'Kackavalj',
    'Kiselo mleko',
    'Jogurt',
    'Ostalo',
  ];

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: size * 1.8),
      child: SizedBox(
        height: 28,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _potkateogrijee.length,
          itemBuilder: (context, index) => buildCategory(index),
        ),
      ),
    );
  }

  Widget buildCategory(int index) {
    var size = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: size * 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _potkateogrijee[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == index ? kTextColor : kNaslovOglasa,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: kDefaultPaddin / 4), //top padding 5
              height: 2,
              width: 70,
              color: selectedIndex == index ? Colors.black : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
