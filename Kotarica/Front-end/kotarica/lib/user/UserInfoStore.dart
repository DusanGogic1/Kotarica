import 'dart:async';
import 'dart:collection';

import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import 'package:kotarica/constants/network.dart';
import 'package:kotarica/user/User.dart';
import 'package:kotarica/util/ContractHelper.dart';

class UserInfoStore {
  static String _rpcUrl = NetworkConstants.rpcUrl;
  static String _wsUrl = NetworkConstants.wsUrl;
  static String _privateKey;
  static Web3Client _client;

  static bool _initiated = false;

  static ContractHelper _usersContract;
  static ContractHelper _extendedUsersContract;

  // UsersContract functions
  static ContractFunction _getUser;
  static ContractFunction _userCount;

  // ExtendedUsersContract functions
  static ContractFunction _getUserIndexByUserName;

  static StreamSubscription<FilterEvent> _userInfoChangedSubscription;
  static StreamSubscription<FilterEvent> _userOwnerChangedSubscription;
  static StreamSubscription<FilterEvent> _userDeletedSubscription;

  static var _byId = HashMap<int, User>();
  static var _byUserName = HashMap<String, User>();

  // Public fields
  static bool get isInitiated => _initiated;

  UserInfoStore._();

  static Future<void> initiateSetup(String privateKey) async {
    if (_initiated) {
      if (privateKey == _privateKey) {
        return;
      }

      await _userInfoChangedSubscription.cancel();
      await _userOwnerChangedSubscription.cancel();
      await _userDeletedSubscription.cancel();
    }
    _privateKey = privateKey;

    await _initiateContracts();

    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    
    _listenForUserChanges();

    _initiated = true;
  }

  static Future<void> _initiateContracts() async {
    _usersContract = await ContractHelper.fromParams(
      rpcUrl: _rpcUrl,
      wsUrl: _wsUrl,
      privateKey: _privateKey,
      contractName: "UsersContract",
    );
    _getUser = _usersContract.function("getUser");
    _userCount = _usersContract.function("userCount");

    _extendedUsersContract = await ContractHelper.fromParams(
      rpcUrl: _rpcUrl,
      wsUrl: _wsUrl,
      privateKey: _privateKey,
      contractName: "ExtendedUsersContract",
    );
    _getUserIndexByUserName = _extendedUsersContract.function("getUserIndexByUserName");
  }

  static void _listenForUserChanges() {
    var userInfoChangedEvent = _extendedUsersContract.event("UserInfoChanged");
    var userInfoChangedEventStream = _client.events(FilterOptions.events(contract: _extendedUsersContract.contract, event: userInfoChangedEvent));
    _userInfoChangedSubscription = userInfoChangedEventStream.listen((event) async {
      var decoded = userInfoChangedEvent.decodeResults(event.topics, event.data);
      BigInt idBig = decoded[0];
      int id = idBig.toInt();

      if (!_byId.containsKey(id)) {
        return;
      }

      // print("FIRSTNAME BEFORE FIRSTNAME BEFORE FIRSTNAME BEFORE FIRSTNAME BEFORE FIRSTNAME BEFORE: ${_byId[id].firstName}");

      _uncacheUser(_byId[id]);
      _cacheUser(await _userFromContractById(idBig));

      // print("FIRSTNAME AFTER FIRSTNAME AFTER FIRSTNAME AFTER FIRSTNAME AFTER FIRSTNAME AFTER: ${_byId[id].firstName}");
    });

    var userOwnerChangedEvent = _extendedUsersContract.event("UserOwnerChanged");
    var userOwnerChangedEventStream = _client.events(FilterOptions.events(contract: _extendedUsersContract.contract, event: userOwnerChangedEvent));
    _userOwnerChangedSubscription = userOwnerChangedEventStream.listen((event) {
      var decoded = userOwnerChangedEvent.decodeResults(event.topics, event.data);
      int id = decoded[0].toInt();

      if (!_byId.containsKey(id)) {
        return;
      }

      // print("OWNER BEFORE OWNER BEFORE OWNER BEFORE OWNER BEFORE OWNER BEFORE: ${_byId[id].owner}");

      EthereumAddress owner = decoded[1];
      _byId[id].owner = owner;

      // print ("OWNER AFTER OWNER AFTER OWNER AFTER OWNER AFTER OWNER AFTER: ${_byId[id].owner}");
    });

    var userDeletedEvent = _usersContract.event("UserDeleted");
    var userDeletedEventStream = _client.events(FilterOptions.events(contract: _usersContract.contract, event: userDeletedEvent));
    _userDeletedSubscription = userDeletedEventStream.listen((event) {
      var decoded = userDeletedEvent.decodeResults(event.topics, event.data);
      int id = decoded[0].toInt();

      if (!_byId.containsKey(id)) {
        return;
      }

      _uncacheUser(_byId[id]);
    });
  }

  static Future<User> _userFromContractById(BigInt id) async {
    List numUsersList = await _usersContract.call(function: _userCount, params: []);
    BigInt numUsers = numUsersList[0];
    if (id >= numUsers) {
      return null;
    }

    List<dynamic> resUser = await _usersContract.call(function: _getUser, params: [id]);
    User user = User.fromTuples(resUser[0]);
    return user;
  }

  static Future<User> _userFromContractByUniqueProperty(ContractFunction byPropertyFunction, dynamic key) async {
    List<dynamic> resIndex = await _extendedUsersContract.call(function: byPropertyFunction, params: [key]);
    bool exists = resIndex[1] as bool;
    if (!exists) {
      return null;
    }
    BigInt index = resIndex[0] as BigInt;

    return await _userFromContractById(index);
  }

  static void _cacheUser(User user) {
    if (user == null) {
      return;
    }
    _byId[user.id] = user;
    _byUserName[user.username] = user;
  }

  static void _uncacheUser (User user) {
    assert (user != null);

    _byId.remove(user.id);
    _byUserName.remove(user.username);
  }

  static Future<User> getUserById(int id) async {
    if (_byId.containsKey(id)) {
      return _byId[id];
    }
    
    User user = await _userFromContractById(BigInt.from(id));
    _cacheUser(user);

    return user;
  }

  static Future<User> _getUserByUniqueProperty (Map byPropertyMap, ContractFunction byPropertyFunction, dynamic key) async {
    if (byPropertyMap.containsKey(key)) {
      return byPropertyMap[key];
    }

    User user = await _userFromContractByUniqueProperty(byPropertyFunction, key);
    _cacheUser(user);

    return user;
  }

  static Future<User> getUserByUserName (String userName) async
  => _getUserByUniqueProperty(_byUserName, _getUserIndexByUserName, userName);
}