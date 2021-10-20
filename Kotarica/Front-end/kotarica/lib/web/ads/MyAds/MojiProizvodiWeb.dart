import 'package:flutter/material.dart';

//smesteni su podaci o proizvodu

class MyProductWeb {
  final String image, title, description;
  DateTime dateAndTime;
  final int price, size, id;
  final Color color;
  final String owner; //POTREBNO ZA IME VLASNIKA OBJAVE

  MyProductWeb(
      {this.id,
      this.image,
      this.title,
      this.dateAndTime,
      this.price,
      this.description,
      this.size,
      this.color,
      this.owner});
}

//
// ignore: non_constant_identifier_names
List<MyProductWeb> Myproducts = [
//   MyProduct(
//     id: 1,
//     title: "Sir",
//     price: 234,
//     size: 12,
//     description: dummyText,
//     image: "images/sir2.png",
//     dateAndTime: "13",
//     color: HP_siva,
//   ),
//   MyProduct(
//       id: 4,
//       title: "Sir",
//       price: 234,
//       size: 11,
//       description: dummyText,
//       image: "images/sir2.png",
//       dateAndTime: "13",
//       color: HP_plava),
//
];
// String dummyText =
//     "Najbolji domaci proizvodi. Najbolji domaci proizvodi. Najbolji domaci proizvodi. Najbolji domaci proizvodi. Najbolji domaci proizvodi. Najbolji domaci proizvodi. Najbolji domaci proizvodi. Najbolji domaci proizvodi. ";
