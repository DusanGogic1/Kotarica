import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:http/http.dart';
import 'package:kotarica/constants/network.dart';
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:wallet_core/wallet_core.dart';
import 'package:web3dart/credentials.dart';
import 'package:web_socket_channel/io.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MarksProductModelWeb extends UserModelWeb {

  Credentials credentials;
  Web3Client client;
  String _abiCode;

  EthereumAddress _contractAddress;
  EthereumAddress ownAddress;

  DeployedContract _contract;

  ContractFunction _addMarks;
  ContractFunction _marksCount;
  ContractFunction _toRate;
  ContractFunction _marks;

  String _privateKey = "";

  final String rpcUrl = NetworkConstants.rpcUrl;
  final String wsUrl = NetworkConstants.wsUrl;


  Future<void> initiateSetup([String privateKey]) async {
    client = Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });

    if(privateKey != null) {
      _privateKey = privateKey;
    }
    print(privateKey);
    await getAbi();

    await getCredentials();
    await getDeployedContract();

    if(client != null && credentials != null){
      notifyListeners();
    }
  }

  Future<void> getAbi() async {
    String abiStringFile =
    await rootBundle.loadString("src/abis/ProductMarksContract.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }
  Future<void> getCredentials() async {
    credentials = await client.credentialsFromPrivateKey(_privateKey);
    ownAddress = await credentials.extractAddress();
    //print("MODEL credentials done");
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "ProductMarksContract"), _contractAddress);

    _addMarks = _contract.function("addMarks");
    _marksCount=_contract.function("MarksCount");
    _toRate=_contract.function("toRate");
    _marks=_contract.function("marks");
    //print(await client.call(sender: ownAddress, contract: _contract, function: _marksCount, params: []));
  }
  //ADD Marks
  Future<void> addMarks(
      double _ocena,
      int _id,
      ) async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int _username = prefs.getInt("id");

      await client.sendTransaction(
          credentials,
          Transaction.callContract(
              from: ownAddress,
              gasPrice: EtherAmount.inWei(BigInt.one),
              maxGas: 6721975,
              contract: _contract,
              function: _addMarks,
              parameters: [
                BigInt.from((_ocena*10).toInt()),
                BigInt.from(_id),
                BigInt.from(_username)
              ]));
  }
  Future<double> getMean(
      int _id,
      ) async {
    List numMarks = await client.call(sender: ownAddress, contract: _contract, function: _marksCount, params: []);
    double mean = 0;
    int numOfReviews = 0;
    for(int i = 0; i < numMarks[0].toInt(); i++){
      List marks = await client.call(sender: ownAddress, contract: _contract, function: _marks, params: [BigInt.from(i)]);
      if(marks[1].toInt() == _id){
        mean+=marks[2].toInt();
        numOfReviews++;
      }
    }
    if(mean == 0) return -1;
    mean = (mean/10)/numOfReviews;
    return mean;
  }

  Future<List> getMarks(
      int _id,
      ) async{

      List numMarks = await client.call(sender: ownAddress, contract: _contract, function: _marksCount, params: []);
      List<dynamic> myMarks = new List<dynamic>();
      int markNumber = 0;
      for(int i = 0; i < numMarks[0].toInt(); i++){
        List marks = await client.call(sender: ownAddress, contract: _contract, function: _marks, params: [BigInt.from(i)]);
        if(marks[1].toInt() == _id){
            myMarks.add(marks);
            markNumber++;
        }
      }
      myMarks.add(markNumber);
      return myMarks;
  }

  Future<int> numberOfMarksPerUser(int productId) async {

    int numOfRatedProducts = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int rater = prefs.getInt("id");

    List mc = await client.call(
        sender: ownAddress,
        contract: _contract,
        function: _marksCount,
        params: []);

    for(int i = 0; i < mc[0].toInt(); i++){
      List boughtProduct = await client.call(
          sender: ownAddress,
          contract: _contract,
          function: _marks,
          params: [BigInt.from(i)]);
      print(boughtProduct);
      print("rater: " + rater.toString() + "productId: " + productId.toString());
      if(boughtProduct[0].toInt() == rater && boughtProduct[1].toInt() == productId ) {
        numOfRatedProducts++;
      }
    }
    return numOfRatedProducts;
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