import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/strings.dart';


import 'package:kotarica/constants/style.dart';

//POTKATEGORIJE!

class Categories extends StatefulWidget {
  String _kategorija;

  Categories(this._kategorija);
  @override
  _CategoriesState createState() => _CategoriesState(kategorija:_kategorija);
}

class _CategoriesState extends State<Categories> {
  String kategorija;

  _CategoriesState({this.kategorija});

  // /* -------POTKATEGORIJE ------ */
  // /* Liste potkategorija */
  // List<dynamic> potkategorije = [];
  // List<DropdownMenuItem<String>> _dropDownMenuItemsPotkategorija;
  //
  // final List<dynamic> mlecniProizvodiList =
  // json.decode(StringConstants.mlecniProizvodi); // lista potkategorija
  //
  // final List<dynamic> suhomesnatoList =
  // json.decode(StringConstants.suhomesnato); // lista potkategorija
  //
  // final List<dynamic> slaniSpajzList =
  // json.decode(StringConstants.slaniSpajz); // lista potkategorija
  //
  // final List<dynamic> slatkiSpajzList =
  // json.decode(StringConstants.slatkiSpajz); // lista potkategorija
  //
  // final List<dynamic> picaList =
  // json.decode(StringConstants.pica); // lista potkategorija
  //
  // final List<dynamic> mlinList =
  // json.decode(StringConstants.mlin); // lista potkategorija
  //
  // final List<dynamic> medList =
  // json.decode(StringConstants.med); // lista potkategorija
  //
  // final List<dynamic> veganList =
  // json.decode(StringConstants.vegan); // lista potkategorija
  //
  // // pri promeni kategorije izaberi potkategoriju
  // void onChangeCallback(category) {
  //   if (category == "Mlečni proizvodi") {
  //     potkategorije = mlecniProizvodiList;
  //     // _dropDownMenuItemsPotkategorija =
  //     //     buildDropdownMenuItemsPotkategorije(mlecniProizvodiList);
  //   } else if (category == "Suhomesnato") {
  //     potkategorije = suhomesnatoList;
  //     // _dropDownMenuItemsPotkategorija =
  //     //     buildDropdownMenuItemsPotkategorije(suhomesnatoList);
  //   } else if (category == "Slani špajz") {
  //     potkategorije = slaniSpajzList;
  //     // _dropDownMenuItemsPotkategorija =
  //     //     buildDropdownMenuItemsPotkategorije(slaniSpajzList);
  //   } else if (category == "Slatki špajz") {
  //     potkategorije = slatkiSpajzList;
  //     // _dropDownMenuItemsPotkategorija =
  //     //     buildDropdownMenuItemsPotkategorije(slatkiSpajzList);
  //   } else if (category == "Piće") {
  //     potkategorije = picaList;
  //     // _dropDownMenuItemsPotkategorija =
  //     //     buildDropdownMenuItemsPotkategorije(picaList);
  //   } else if (category == "Mlin") {
  //     potkategorije = mlinList;
  //     // _dropDownMenuItemsPotkategorija =
  //     //     buildDropdownMenuItemsPotkategorije(mlinList);
  //   } else if (category == "Med") {
  //     potkategorije = medList;
  //     // _dropDownMenuItemsPotkategorija =
  //     //     buildDropdownMenuItemsPotkategorije(medList);
  //   } else if (category == "Vegan") {
  //     potkategorije = veganList;
  //     // _dropDownMenuItemsPotkategorija =
  //     //     buildDropdownMenuItemsPotkategorije(veganList);
  //   } else {
  //     potkategorije = [];
  //   }
  //
  //   setState(() {
  //     _izabranaKategorija = category;
  //     _izabranaPotkategorija = null;
  //   });
  // }


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
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: SizedBox(
        height: 24,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _potkateogrijee.length,
          itemBuilder: (context, index) => buildCategory(index),
        ),
      ),
    );
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _potkateogrijee[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                // color: selectedIndex == index ? kTextColor : kNaslovOglasa,
                 color: selectedIndex == index ? Tema.dark ? bela: plavaTekst :  Tema.dark ? svetloZelena: crnaGlavna
                ,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: kDefaultPaddin / 4), //top padding 5
              height: 1,
              width: 30,
              color: selectedIndex == index ? Colors.black : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
