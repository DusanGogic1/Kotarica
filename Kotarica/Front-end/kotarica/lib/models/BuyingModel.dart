import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_core/wallet_core.dart';
import 'package:kotarica/constants/network.dart';
import 'package:web_socket_channel/io.dart';

import '../util/AuthApi.dart';
import '../util/ContractHelper.dart';
import 'UserModel.dart';

class BuyingModel extends ChangeNotifier{
  Credentials credentials;
  Web3Client client;

  AuthApi authApi = new AuthApi();

  final String rpcUrl = NetworkConstants.rpcUrl;
  final String wsUrl = NetworkConstants.wsUrl;

  String _abiCode;

  EthereumAddress _contractAddress;
  EthereumAddress ownAddress;

  DeployedContract _contract;

  ContractFunction _pendingCount;
  ContractFunction _pending;
  ContractFunction _canceledCount;
  ContractFunction _canceled;
  ContractFunction _confirmedCount;
  ContractFunction _confirmed;
  ContractFunction _addToPending;
  ContractFunction _addToConfirmed;
  ContractFunction _addToCanceled;

  ContractEvent _purchase;

  String _privateKey = "";
  String currentUsername=""; //ulogovan korisnik(username)

  ContractHelper _extendedContract;

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

    if (client != null && credentials != null) {
      notifyListeners();
    }
  }



  Future<void> getAbi() async {
    String abiStringFile =
    await rootBundle.loadString("src/abis/BuyingContract.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
    // print(_contractAddress);
  }

  Future<void> getCredentials() async {
    //HARDKODOVANO
    print("pk:"+_privateKey);
    credentials = await client.credentialsFromPrivateKey(_privateKey);
    ownAddress = await credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "BuyingContract"), _contractAddress);


    _pendingCount = _contract.function("pendingCount");
    _pending = _contract.function("pending");

    _confirmedCount = _contract.function("confirmedCount");
    _confirmed = _contract.function("confirmed");

    _canceledCount = _contract.function("canceledCount");
    _canceled = _contract.function("canceled");

    _addToPending = _contract.function("addToPending");
    _addToConfirmed = _contract.function("addToConfirmed");
    _addToCanceled = _contract.function("addToCanceled");

    _purchase = _contract.event("purchase");
  }


    //TRANSAKCIJA
    Future<void> addToPending(int sellerId, int productId, int amount, String adresa, String unit, String paidIn) async
    {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int buyerId = prefs.getInt("id");
      String telefon = prefs.getString("phone");

      await client.sendTransaction(credentials,
          Transaction.callContract(
              gasPrice: EtherAmount.inWei(BigInt.one),
              maxGas: 6721975,
              contract: _contract,
              function: _addToPending,
              parameters: [
                BigInt.from(buyerId),
                BigInt.from(sellerId),
                BigInt.from(productId),
                BigInt.from(amount),
                adresa,
                telefon,
                unit,
                paidIn
              ]
          )
      );
    }

    Future<List> getAllPendingBuyer() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int buyerId = prefs.getInt("id");

      List pending = new List();
      List pa = await client.call(
          sender: ownAddress,
          contract: _contract,
          function: _pendingCount,
          params: []);

      for(int i = 0; i < pa[0].toInt(); i++){
        List pendingProduct = await client.call(
            sender: ownAddress,
            contract: _contract,
            function: _pending,
            params: [BigInt.from(i)]);

        if(pendingProduct[0].toInt() == buyerId)
          pending.add(pendingProduct);
      }

      return pending;
    }

  Future<List> getAllPendingSeller() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int sellerId = prefs.getInt("id");
    print("prodavac: " + sellerId.toString());
    List pending = new List();
    List pa = await client.call(
        sender: ownAddress,
        contract: _contract,
        function: _pendingCount,
        params: []);

    for(int i = 0; i < pa[0].toInt(); i++){
      List pendingProduct = await client.call(
          sender: ownAddress,
          contract: _contract,
          function: _pending,
          params: [BigInt.from(i)]);
      pendingProduct.add(i);
      if(pendingProduct[1].toInt() == sellerId && pendingProduct[5].toString() != "") {
        pending.add(pendingProduct);
      }
    }

    return pending;
  }

    Future<int> numberOfConfirmed(int productId) async
    {
      int numberOfBoughtProduct = 0;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int buyerId = prefs.getInt("id");

      List ba = await client.call(
        sender: ownAddress,
        contract: _contract,
        function: _confirmedCount,
        params: []);

      for(int i = 0; i < ba[0].toInt(); i++){
        List boughtProduct = await client.call(
          sender: ownAddress,
          contract: _contract,
          function: _confirmed,
          params: [BigInt.from(i)]);
        //print(boughtProduct);
        if(boughtProduct[0].toInt() == buyerId &&
          boughtProduct[2].toInt() == productId ) {
          numberOfBoughtProduct++;
        }
      }
      return numberOfBoughtProduct;
    }

  Future<void> addToConfirmed(int pendingId) async
  {
    await client.sendTransaction(credentials,
        Transaction.callContract(
            gasPrice: EtherAmount.inWei(BigInt.one),
            maxGas: 6721975,
            contract: _contract,
            function: _addToConfirmed,
            parameters: [
              BigInt.from(pendingId),
            ]
        )
    );
  }

  Future<List> getAllConfirmedBuyer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int buyerId = prefs.getInt("id");

    List confirmed = new List();
    List ca = await client.call(
        sender: ownAddress,
        contract: _contract,
        function: _confirmedCount,
        params: []);

    for(int i = 0; i < ca[0].toInt(); i++){
      List confirmedProduct = await client.call(
          sender: ownAddress,
          contract: _contract,
          function: _confirmed,
          params: [BigInt.from(i)]);

      if(confirmedProduct[0].toInt() == buyerId)
        confirmed.add(confirmedProduct);
    }

    return confirmed;
  }

  Future<List> getAllConfirmedSeller() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int sellerId = prefs.getInt("id");

    List confirmed = new List();
    List ca = await client.call(
        sender: ownAddress,
        contract: _contract,
        function: _confirmedCount,
        params: []);

    for(int i = 0; i < ca[0].toInt(); i++){
      List confirmedProduct = await client.call(
          sender: ownAddress,
          contract: _contract,
          function: _confirmed,
          params: [BigInt.from(i)]);

      if(confirmedProduct[1].toInt() == sellerId)
        confirmed.add(confirmedProduct);
    }

    return confirmed;
  }

  Future<void> addToCancelled(int pendingId) async
  {
    await client.sendTransaction(credentials,
        Transaction.callContract(
            gasPrice: EtherAmount.inWei(BigInt.one),
            maxGas: 6721975,
            contract: _contract,
            function: _addToCanceled,
            parameters: [
              BigInt.from(pendingId),
            ]
        )
    );
  }

  Future<List> getAllCanceledBuyer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int buyerId = prefs.getInt("id");

    List canceled = new List();
    List ca = await client.call(
        sender: ownAddress,
        contract: _contract,
        function: _canceledCount,
        params: []);

    for(int i = 0; i < ca[0].toInt(); i++){
      List canceledProduct = await client.call(
          sender: ownAddress,
          contract: _contract,
          function: _canceled,
          params: [BigInt.from(i)]);

      if(canceledProduct[0].toInt() == buyerId) {
        print("aaa");
        canceled.add(canceledProduct);
      }
    }

    return canceled;
  }

  Future<List> getAllCanceledSeller() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int sellerId = prefs.getInt("id");

    List canceled = new List();
    List ca = await client.call(
        sender: ownAddress,
        contract: _contract,
        function: _canceledCount,
        params: []);

    for(int i = 0; i < ca[0].toInt(); i++){
      List canceledProduct = await client.call(
          sender: ownAddress,
          contract: _contract,
          function: _canceled,
          params: [BigInt.from(i)]);

      if(canceledProduct[1].toInt() == sellerId)
        canceled.add(canceledProduct);
    }

    return canceled;
  }


  Future<void> setPrivateKey() async {
    _privateKey = await FlutterKeychain.get(
      key: "privatekey",
    );

    await initiateSetup(_privateKey);
    //print("private key set on startup " + _privateKey + " userMarks");
  }
  Future<void> resetPrivateKey() async {
    _privateKey = "";
  }

  Future<void> sendEther(int amount, double priceEth, String ownerUsername, BuildContext context) async {
    
    EthereumAddress seller = await Provider.of<UserModel>(context, listen: false).GetOwnerInfo(ownerUsername);
    await client.sendTransaction(
        credentials,
        Transaction(
          to: seller,
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 6721975,
          value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(amount*priceEth*pow(10, 6)))
        ));
  }

  Future<void> sendEther2(int amount, double priceEth, EthereumAddress seller) async {
    await client.sendTransaction(
        credentials,
        Transaction(
            to: seller,
            gasPrice: EtherAmount.inWei(BigInt.one),
            maxGas: 6721975,
            value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(amount*priceEth*pow(10, 6)))
        ));
  }

  Future<num> getBalance() async {
    EtherAmount balance = await client.getBalance(ownAddress);
    return balance.getValueInUnit(EtherUnit.ether);
  }

  void notify(){
    notifyListeners();
  }

  Future<bool> isItBoughtable(double priceEth) async{
    if(priceEth == null) return true;
    var balance = await getBalance();
    return balance >= priceEth;
  }

  Future<bool> transferAllToCancelled(int productId) async
  {
    List pa = await client.call(sender: ownAddress, contract: _contract, function: _pendingCount, params: []);
    for(int i = 0; i < pa[0].toInt(); i++) {

      List pendingProduct = await client.call(sender: ownAddress, contract: _contract, function: _pending, params: [BigInt.from(i)]);
      if(pendingProduct[2].toInt() == productId && pendingProduct[5].toString() != "") {
        await addToCancelled(i);
      }
    }
    return true;
  }

  Future<List> getUserInfo(int productId) async{

    List pending = new List();
    List pa = await client.call(sender: ownAddress, contract: _contract, function: _pendingCount, params: []);

    for(int i = 0; i < pa[0].toInt(); i++){

      List pendingProduct = await client.call(sender: ownAddress, contract: _contract, function: _pending, params: [BigInt.from(i)]);

      if(pendingProduct[2].toInt() == productId && pendingProduct[5].toString() != "") {
        pending.add(pendingProduct);
      }
    }
    return pending;
  }
}