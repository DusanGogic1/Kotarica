import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:kotarica/constants/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_core/wallet_core.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web_socket_channel/io.dart';

import 'UserModelWeb.dart';

//OCENE KORISNIKA
class MarksUserModelWeb extends UserModelWeb  {

  Credentials credentials;

  Web3Client client;
  String _abiCode;

  EthereumAddress _contractAddress;
  EthereumAddress ownAddress;

  DeployedContract _contract;

  int brojLajkova;

  ContractFunction _likes;
  ContractFunction _addLike;
  ContractFunction _addDislike;
  ContractFunction _getNumLikes;
  ContractFunction _getNumDislikes;
  ContractFunction _likesAmount;

  String _privateKey = "";

  final String rpcUrl = NetworkConstants.rpcUrl;
  final String wsUrl = NetworkConstants.wsUrl;


  MarksUserModelWeb(){
    // initiateSetup();
  }

  @override
  Future<void> initiateSetup([String privateKey]) async {
    client = Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });

    if(privateKey != null) {
      _privateKey = privateKey;
    }
    await getAbi();
    await getCredentials();
    await getDeployedContract();

    if(client != null && credentials != null){
      notifyListeners();
    }
  }
  Future<void> getAbi() async {
    String abiStringFile =
    await rootBundle.loadString("src/abis/LikesContract.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    credentials = await client.credentialsFromPrivateKey(_privateKey);
    ownAddress = await credentials.extractAddress();
   // print("MODEL credentials done");
  }
  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "LikesContract"), _contractAddress);

    _addLike = _contract.function("addLike");
    _addDislike = _contract.function("addDislike");
    _getNumLikes = _contract.function("getNumLikes");
    _getNumDislikes = _contract.function("getNumDislikes");
    _likesAmount=_contract.function("likesAmount");
    _likes = _contract.function("likes");
    //print(await client.call(sender: ownAddress, contract: _contract, function: _likesAmount, params: []));
  }

  //getLikes
  Future<int> getLikes(
      String username,
      ) async {
    List answer = await client.call(
        sender: ownAddress, contract: _contract, function: _getNumLikes, params: [username]);

    return answer[0];
  }

  //getLikes
  Future<void> getDislikes(
      String username,
      ) async {
    List answer = await client.call(
        sender: ownAddress, contract: _contract, function: _getNumDislikes, params: [username]);

    return answer[0];
  }
  Future<void> getNumberOfLikesOnBlochain() async {

    // print("klijent: " +client.toString());
    // print("broj lajkova: " + _likesAmount.toString());
    List bl = await client.call(sender: ownAddress, contract: _contract, function: _likesAmount, params: []);
    brojLajkova = bl[0].toInt();
  }

  Future<List> dajLajkove(int _username) async{

    List lajkovi = new List();
    await getNumberOfLikesOnBlochain();
    for(int i = 0; i < brojLajkova; i++){
      List likeOnBlockchain = await client.call(
          sender: ownAddress,
          contract: _contract,
          function: _likes,
          params: [BigInt.from(i)]
      );
      if(likeOnBlockchain[1].toInt() == _username && likeOnBlockchain[2] == true){
        lajkovi.add(likeOnBlockchain);
      }
    }
    return lajkovi;
  }
  Future<List> dajDislajkove(int _username) async{

    List dislajkovi = new List();
    await getNumberOfLikesOnBlochain();
    for(int i = 0; i < brojLajkova; i++){
      List likeOnBlockchain = await client.call(
          sender: ownAddress,
          contract: _contract,
          function: _likes,
          params: [BigInt.from(i)]
      );

      if(likeOnBlockchain[1].toInt() == _username && likeOnBlockchain[2] == false){
        dislajkovi.add(likeOnBlockchain[0]);
      }
    }
    return dislajkovi;
  }

  Future<List> giveMeMyReviews() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt("id");
    List<dynamic> lista = new List<dynamic>();
    await getNumberOfLikesOnBlochain();
    for(int i = 0; i < brojLajkova; i++){
      List likeOnBlockchain = await client.call(
          sender: ownAddress,
          contract: _contract,
          function: _likes,
          params: [BigInt.from(i)]
      );
      if(likeOnBlockchain[0].toInt() == id) lista.add(likeOnBlockchain);
    }
    return lista;
  }


  //ADD LIKE
  Future<void> addLike(
      int username1,
      int username2,
      String _mess1,
      String _mess2,
      String _mess3,
      ) async {
    await client.sendTransaction(
        credentials,
        Transaction.callContract(
            from: ownAddress,
            gasPrice: EtherAmount.inWei(BigInt.one),
            maxGas: 6721975,
            contract: _contract,
            function: _addLike,
            parameters: [
              BigInt.from(username1),
              BigInt.from(username2),
              _mess1,
              _mess2,
              _mess3,
            ]));
    print("LAJKOVANO U MODELU");
  }
  //ADD DISLIKE
  Future<bool> addDislike(
      int username1,
      int username2,
      String _mess1,
      String _mess2,
      String _mess3,
      ) async {
    await client.sendTransaction(
        credentials,
        Transaction.callContract(
            from: ownAddress,
            gasPrice: EtherAmount.inWei(BigInt.one),
            maxGas: 6721975,
            contract: _contract,
            function: _addDislike,
            parameters: [
              BigInt.from(username1),
              BigInt.from(username2),
              _mess1,
              _mess2,
              _mess3,
            ]));
    // Dislajkovi.add(answerList[0]);
    print("DISLAJKOVANO U MODELI");
  }

  Future<void> resetPrivateKey() async {
    _privateKey = "";
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
}