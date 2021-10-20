// TODO: Dodati slike korisnika u sol

import 'package:flutter/material.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:web3dart/credentials.dart';


class User {
  // Essentials
  BigInt idBig;
  String username;
  EthereumAddress owner;
  String json;

  // Personal
  String firstName;
  String lastName;
  String personalAddress;

  // More details
  String phone;
  String email;
  String city;
  String zipCode;
  String imageHash;

  int get id => idBig.toInt();
  set id (int id) {
    idBig = BigInt.from(id);
  }

  ImageProvider _imageProvider;
  Future<ImageProvider> get imageProvider async {
    await fetchIpfsImage();
    return _imageProvider;
  }

  User({
      @required int id,
      @required this.username,
      @required this.owner,
      @required this.json,

      @required this.firstName,
      @required this.lastName,
      @required this.personalAddress,

      @required this.phone,
      @required this.email,
      @required this.city,
      @required this.zipCode,
      @required this.imageHash
  }) {
    this.id = id;
  }

  User.raw({
    @required this.idBig,
    @required this.username,
    @required this.owner,
    @required this.json,

    @required this.firstName,
    @required this.lastName,
    @required this.personalAddress,

    @required this.phone,
    @required this.email,
    @required this.city,
    @required this.zipCode,
    @required this.imageHash
  });

  User.fromTuples(List<dynamic> tuples) :
      assert(tuples.length == 3),
      assert(tuples[0] is List<dynamic> && tuples[0].length >= 4),
      assert(tuples[1] is List<dynamic> && tuples[1].length >= 3),
      assert(tuples[2] is List<dynamic> && tuples[2].length >= 5),

      idBig = tuples[0][0],
      username = tuples[0][1],
      owner = tuples[0][2],
      json = tuples[0][3],

      firstName = tuples[1][0],
      lastName = tuples[1][1],
      personalAddress = tuples[1][2],

      phone = tuples[2][0],
      email = tuples[2][1],
      city = tuples[2][2],
      zipCode = tuples[2][3],
      imageHash = tuples[2][4];

  Future<void> fetchIpfsImage({bool checkAlreadyFetched: true}) async {
    if (checkAlreadyFetched && _imageProvider != null) {
      return;
    }
    _imageProvider = await loadIpfsImage(imageHash);
  }
}
