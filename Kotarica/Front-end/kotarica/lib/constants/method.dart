//PROVERA ZA OCENU! -->TODO
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/style.dart';

Container dajIkonu(bool provera){
  if(provera==true)
  {
    return Container(
        child: Icon(
          CupertinoIcons.hand_thumbsup_fill,
          size: 25,
          color: Colors.green[500],
        )
    );
  }
  else
  {
    return Container(
        child:Icon(
          CupertinoIcons.hand_thumbsdown_fill,
          size: 25,
          color: Colors.red[500],
        )
    );
  }
}
Color dajBoju(bool provera){
  if(provera==true)
  {
    return svetloZelena;
  }
  else
  {
    return  Color.fromRGBO(250, 129, 107,1);
  }

}
Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

  // /*------DROPDOWN KATEGORIJA------*/
  // Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  // Padding(
  // padding: EdgeInsets.only(
  // top: size * 0.01, left: size * 0.02),
  // child: DropdownButton(
  // dropdownColor: bela,
  // elevation: 5,
  // icon: Icon(
  // Icons.keyboard_arrow_down,
  // color: crvenaGlavna,
  // ),
  // iconSize: 36.0,
  // value: _izabranaKategorija,
  // style: TextStyle(color: plavaGlavna),
  // items: _dropDownMenuItemsKategorija,
  // onChanged: (newvalue) {
  // setState(() {
  // _izabranaKategorija = newvalue;
  // //print(newvalue);
  // });
  // },
  // )),




