import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kotarica/constants/currencies.dart';
import 'package:kotarica/constants/strings.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/user/UserInfoStore.dart';
import 'package:kotarica/util/helper_functions.dart';

import '../constants/style.dart';

//smesteni su podaci o proizvodu

class Product {
  int ownerId;
  String ownerUsername;
  String ownerImage;

  int id;
  String title;
  String category;
  String subcategory;
  String measuringUnit;
  String city;
  bool exists;

  String about;
  double priceEth; // double to int (convert to wei)
  int priceRsd;
  String type;
  DateTime date;

  List<dynamic> images;

  Color color;
  int amount;

  static Future<Product> fromTuples(List<dynamic> tuples, Color color) async {
    assert(tuples.length == 3);
    assert(tuples[0] is List<dynamic> && tuples[0].length >= 2);
    assert(tuples[1] is List<dynamic> && tuples[1].length >= 6);
    assert(tuples[2] is List<dynamic> && tuples[2].length >= 6);

    int ownerId = tuples[0][0].toInt();
    String categorySubcategory = tuples[1][2];

    String ownerUsername = (await UserInfoStore.getUserById(ownerId)).username;

    List<String> categorySubcategoryList =
      categorySubcategory.split('-');
    assert (categorySubcategoryList.length == 2);

    String category = categorySubcategoryList[0];
    String subCategory = categorySubcategoryList[1];

    return Product(
        ownerId: ownerId,
        ownerUsername: ownerUsername,
        ownerImage: tuples[0][1],
        id: tuples[1][0].toInt(),
        title: tuples[1][1],
        category: category,
        subcategory: subCategory,
        city: tuples[1][3],
        exists: tuples[1][5],
        about: tuples[2][0],
        priceEth: trim(tuples[2][2].toDouble() / Currencies.wei),
        priceRsd: tuples[2][1].toInt(),
        measuringUnit: tuples[2][3],
        type: tuples[2][4],
        date: DateTime.parse(tuples[2][5]),
        images: tuples[1][4],
        color: color);
  }

  Product({
    @required this.ownerId,
    @required this.ownerUsername,
    @required this.ownerImage,
    @required this.id,
    @required this.title,
    @required this.category,
    @required this.subcategory,
    @required this.city,
    @required this.exists,
    @required this.about,
    @required this.priceEth,
    @required this.priceRsd,
    @required this.measuringUnit,
    @required this.type,
    @required this.date,
    @required this.images,
    @required this.color
  });

  Product.idConstructor(this.id);

  factory Product.fromJson(Map<String, dynamic> jsonData) {
    return Product(
        ownerId: jsonData['ownerId'],
        ownerUsername: jsonData['ownerUsername'],
        ownerImage: jsonData['ownerImage'],
        id: jsonData['id'],
        title: jsonData['title'],
        category: jsonData['category'],
        subcategory: jsonData['subcategory'],
        city: jsonData['city'],
        exists: jsonData['exists'],
        about: jsonData['about'],
        priceEth: jsonData['priceEth'],
        priceRsd: jsonData['priceRsd'],
        measuringUnit: jsonData['measuringUnit'],
        type: jsonData['type'],
        date: DateTime.parse(jsonData['date']),
        images: jsonData['images'],
        color: Colors.blue
    );
  }


  static Map<String, dynamic> toMap(Product product) => {
    'ownerId': product.ownerId,
    'ownerUsername': product.ownerUsername,
    'ownerImage': product.ownerImage,
    'id': product.id,
    'title': product.title,
    'category': product.category,
    'subcategory': product.subcategory,
    'city': product.city,
    'exists': product.exists,
    'about': product.about,
    'priceEth': product.priceEth,
    'priceRsd': product.priceRsd,
    'measuringUnit': product.measuringUnit,
    'type': product.type,
    'date': product.date.toString(),
    'images': product.images,
    'color': ""
  };

  static String encode(List<Product> products) => json.encode(
    products
        .map<Map<String, dynamic>>((products) => Product.toMap(products))
        .toList(),
  );

  static List<Product> decode(String products) =>
      (json.decode(products) as List<dynamic>)
          .map<Product>((item) => Product.fromJson(item))
          .toList();

}