import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:kotarica/constants/network.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/product/SavedProduct.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_core/wallet_core.dart';
import 'package:web_socket_channel/io.dart';


class SavedAdsModelWeb extends ChangeNotifier {
  int _userId;
  Credentials credentials;

  Web3Client client;
  String _abiCode;

  EthereumAddress _contractAddress;
  EthereumAddress ownAddress;

  DeployedContract _contract;
  String _privateKey = "";

  final String rpcUrl = NetworkConstants.rpcUrl;
  final String wsUrl = NetworkConstants.wsUrl;

  ContractFunction _save;
  ContractFunction _check;
  ContractFunction _savedAdverts;
  ContractFunction _countSavedAdverts;

  List<SavedProduct> savedProducts = [];
  int savedProductsCount = 0;

  List<Product> productsToShow =
  []; // lista prikazuje oglase korisniku (savedAds)
  int productsToShowCount = 0;

  bool _savedProductsReady = false;
  bool _readyForCheck;

  SavedAdsModel() {}

  Future<void> initiateSetup([String privateKey]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    client = Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });

    if (privateKey != null) {
      _userId = prefs.getInt("id");
      _privateKey = privateKey;
    }

    await getAbi();

    await getCredentials();
    await getDeployedContract();

    if (client != null && credentials != null) notifyListeners();
  }

  Future<void> getAbi() async {
    String abiStringFile =
    await rootBundle.loadString("src/abis/SavedAdsContract.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    credentials = await client.credentialsFromPrivateKey(_privateKey);
    ownAddress = await credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "SavedAdsContract"), _contractAddress);

    _save = _contract.function("save");
    _check = _contract.function("check");
    _savedAdverts = _contract.function("savedAdverts");
    _countSavedAdverts = _contract.function("countSavedAdverts");

    // await getSavedAds();
  }

  /* Provera da li je oglas sacuvan. userId koji je sacuvao oglas (VEC SE NALAZI U MODELU) i id oglasa */
  Future<bool> checkIfExists(int _id) async {
    List answerList = await client.call(
        contract: _contract,
        function: _check,
        params: [BigInt.from(_userId), BigInt.from(_id)]);

    /*print("user id" +
        _userId.toString() +
        "id oglasa " +
        _id.toString() +
        " " +
        answerList[0].toString());*/
    return answerList[0];
  }

  Future<int> setSavedAdsCount() async {
    List productCountList = await client.call(
        sender: ownAddress,
        contract: _contract,
        function: _countSavedAdverts,
        params: []);

    savedProductsCount = productCountList[0].toInt();

    print(savedProductsCount.toString() + " COUNT OF PRODUCTS [saved]");
  }

  /* save/unsave oglas */
  /* moj id, id vlasnika, id oglasa za cuvanje */
  Future<bool> save(int _id, int _ownerId, int _productId) async {
    if (_id != _ownerId) {
      await client.sendTransaction(
          credentials,
          Transaction.callContract(
              maxGas: 6721975,
              contract: _contract,
              function: _save,
              parameters: [BigInt.from(_id), BigInt.from(_productId)]));

      await getSavedAds();
      print("saved advert changed.");
      return true;
    } else
      return false;
  }

  Future<void> getSavedAds() async {
    _savedProductsReady = false;
    await setSavedAdsCount();

    savedProducts.clear();
    for (var i = 0; i < savedProductsCount; i++) {
      var temp = await client.call(
          sender: ownAddress,
          contract: _contract,
          function: _savedAdverts,
          params: [BigInt.from(i)]);

      savedProducts.add(SavedProduct(
        /* userId */
          temp[0].toInt(),
          /* id */
          temp[1].toInt(),
          /* visible */
          temp[2]));
    }

    productsToShow.clear();
    productsToShowCount = 0;
    for (var i = 0; i < savedProductsCount; i++) {
      if (savedProducts[i].userId == _userId &&
          savedProducts[i].visible == true) {
        //productsToShow.add(ProductModelWeb.getProductById(savedProducts[i].id));
        productsToShowCount++;
      }
    }

    _savedProductsReady = true;

    notifyListeners();
  }

  bool getReadyForCheck() {
    return _readyForCheck;
  }

  void setReadyForCheck(bool value) {
    _readyForCheck = value;
  }


  Future<void> savePrivateKey(String privateKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("privatekey", privateKey);
  }

  Future<void> setPrivateKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _privateKey = prefs.getString("privatekey");

    await initiateSetup(_privateKey);
    //print("private key set on startup " + _privateKey + " usermodel");
  }

  Future<void> resetPrivateKey() async {
    _privateKey = "";
  }

  bool getSavedProductsReady() {
    print("saved");
    print(_savedProductsReady);
    return _savedProductsReady;
  }

  void setSavedProductsReady(bool value) {
    _savedProductsReady = value;
  }
}
