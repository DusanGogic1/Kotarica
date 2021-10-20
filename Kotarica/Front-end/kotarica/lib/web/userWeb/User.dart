// TODO: Dodati slike korisnika u sol

import 'package:flutter/material.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:web3dart/credentials.dart';


class User extends StatelessWidget {
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

  User.fromTuples(List<dynamic> tuple) :
      assert(tuple.length == 3),
      assert(tuple[0] is List<dynamic> && tuple[0].length >= 4),
      assert(tuple[1] is List<dynamic> && tuple[1].length >= 3),
      assert(tuple[2] is List<dynamic> && tuple[2].length >= 5),

      idBig = tuple[0][0],
      username = tuple[0][1],
      owner = tuple[0][2],
      json = tuple[0][3],

      firstName = tuple[1][0],
      lastName = tuple[1][1],
      personalAddress = tuple[1][2],

      phone = tuple[2][0],
      email = tuple[2][1],
      city = tuple[2][2],
      zipCode = tuple[2][3],
      imageHash = tuple[2][4];

  Future<void> fetchIpfsImage({bool checkAlreadyFetched: true}) async {
    if (checkAlreadyFetched && _imageProvider != null) {
      return;
    }
    _imageProvider = await loadIpfsImage(imageHash);
  }

  // Za sliku
  Widget getImage(context) {
    return Row();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
