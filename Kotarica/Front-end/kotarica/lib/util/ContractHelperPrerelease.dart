import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:web3dart2prerelease/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractHelper {
  static final String _defaultAbiDirPath = "src/abis";

  final String _rpcUrl;
  final String _wsUrl;
  final String _privateKey;
  final String _abiPath;
  final String _contractName;

  Credentials _credentials;
  Web3Client _client;
  String _abiCode;

  EthereumAddress _contractAddress;
  EthereumAddress _ownAddress;

  DeployedContract _contract;

  DeployedContract get contract => _contract;

  static Future<ContractHelper> fromParams({
    @required String rpcUrl,
    @required String wsUrl,
    @required String privateKey,
    @required String contractName,
    String abiPath,
  }) async {
    abiPath??= '$_defaultAbiDirPath/$contractName.json';
    ContractHelper helper = ContractHelper._(rpcUrl: rpcUrl, wsUrl: wsUrl, privateKey: privateKey, contractName: contractName, abiPath: abiPath);
    await helper.initiateSetup();
    return helper;
  }

  ContractHelper._({
    @required rpcUrl,
    @required wsUrl,
    @required privateKey,
    @required contractName,
    @required abiPath,
  }) :
        _rpcUrl = rpcUrl,
        _wsUrl = wsUrl,
        _privateKey = privateKey,
        _abiPath = abiPath,
        _contractName = contractName;

  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await _getAbi();
    await _getCredentials();
    await _getDeployedContract();
  }

  Future<void> _getAbi() async {
    String abiStringFile =  await rootBundle.loadString(_abiPath);
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
    // print(_contractAddress);
  }

  Future<void> _getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> _getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, _contractName), _contractAddress);
  }

  ContractFunction function(String name) => _contract.function(name);
  ContractEvent event(String name) => _contract.event(name);

  Future<List<dynamic>> call ({
    @required ContractFunction function,
    @required List params,
  }) async => (await _client.call(
    sender: _ownAddress,
    contract: _contract,
    function: function,
    params: params,
  ));

  Future<String> sendTransaction ({
    @required ContractFunction function,
    @required List params,
    maxGas = 6721975,
  }) => _client.sendTransaction(
    _credentials,
    Transaction.callContract(
      maxGas: maxGas,
      contract: _contract,
      function: function,
      parameters: params
    )
  );
}
