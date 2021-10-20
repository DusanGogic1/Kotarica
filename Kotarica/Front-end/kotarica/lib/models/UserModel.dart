import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:http/http.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/notification/SeenNotifications/SeenNotificationsApi.dart';
import 'package:kotarica/notification/SeenNotifications/SeenNotificationsHandler.dart';
import 'package:kotarica/product/ProductInfoStore.dart';
import 'package:kotarica/user/User.dart';
import 'package:kotarica/user/UserInfoStore.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wallet_core/wallet_core.dart';

import 'package:kotarica/util/AuthApi.dart';
import 'package:kotarica/util/ContractHelper.dart';
import 'package:kotarica/constants/network.dart';
import 'package:kotarica/util/helper_functions.dart';

import 'BuyingModel.dart';

class UserModel extends ChangeNotifier {
  Credentials credentials;
  Web3Client client;

  AuthApi authApi = new AuthApi();

  final String rpcUrl = NetworkConstants.rpcUrl;
  final String wsUrl = NetworkConstants.wsUrl;

  String _abiCode;

  EthereumAddress _contractAddress;
  EthereumAddress ownAddress;

  DeployedContract _contract;

  ContractFunction _userCount;
  ContractFunction _users; //mapping
  ContractFunction _createUser;
  ContractFunction _checkUser;
  ContractFunction _attemptLogin;
  ContractFunction _getJson;
  ContractFunction _getUser;
  ContractFunction _getUserByUsername;
  ContractFunction _getInfo;
  ContractFunction _deleteUser;
  ContractEvent _userCreated;

  // Extended contract functions/events
  ContractFunction _getUserIndexByUserName;
  ContractFunction _getUserIndexByEmail;
  ContractFunction _getUserIndexByPhoneNumber;
  ContractFunction _getUserIndexByOwner;
  ContractFunction _changeUserInfo;
  ContractFunction _changeUserOwner;

  String _privateKey = "";
  String currentUsername = ""; //ulogovan korisnik(username)

  ContractHelper _extendedContract;

  List<User> userInfoList = [];

  UserModel() {}

  Future<void> initiateSetup([String privateKey]) async {
    if(privateKey != null) {
      _privateKey = privateKey;
    }

    // kondicev deo
    _extendedContract = await ContractHelper.fromParams(
        rpcUrl: rpcUrl,
        wsUrl: wsUrl,
        privateKey: _privateKey,
        contractName: "ExtendedUsersContract",
        abiPath: "src/abis/ExtendedUsersContract.json");

    await UserInfoStore.initiateSetup(_privateKey);
    await ProductInfoStore.initiateSetup(_privateKey);
    // kondicev deo

    client = Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();

    if (client != null && credentials != null) {
      notifyListeners();
    }
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/abis/UsersContract.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
    // print(_contractAddress);
  }

  Future<void> getCredentials() async {
    credentials = await client.credentialsFromPrivateKey(_privateKey);
    ownAddress = await credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "UsersContract"), _contractAddress);

    _userCount = _contract.function("userCount");
    _users = _contract.function("users");
    _createUser = _contract.function("createUser");
    _checkUser = _contract.function("checkUser");
    _attemptLogin = _contract.function("attemptLogin");
    _getJson = _contract.function("getJson");
    _getUser = _contract.function("getUser");
    _getUserByUsername = _contract.function("getUserByUsername");
    _userCreated = _contract.event("userCreated");
    _getInfo = _contract.function("getInfo");
    _deleteUser=_contract.function("deleteUser");
    initExtendedContractFunctions();
  }

  void initExtendedContractFunctions() {
    //dodato void
    _getUserIndexByUserName =
        _extendedContract.function("getUserIndexByUserName");
    _getUserIndexByEmail = _extendedContract.function("getUserIndexByEmail");
    _getUserIndexByPhoneNumber =
        _extendedContract.function("getUserIndexByPhoneNumber");
    _getUserIndexByOwner = _extendedContract.function("getUserIndexByOwner");
    _changeUserInfo = _extendedContract.function("changeUserInfo");
    _changeUserOwner = _extendedContract.function("changeUserOwner");
  }

  Future<int> register(
      String username,
      String firstName,
      String lastName,
      String personalAddress,
      String phone,
      String email,
      String city,
      String zipCode,
      String image) async {
    List answerList = await client.call(
        sender: ownAddress,
        contract: _contract,
        function: _checkUser,
        params: [username, email, phone, ownAddress]);
    int answer = answerList[0].toInt();

    if (answer == 0) {
      // U koliko je sve u redu dodaj korisnika

      List idList = await client
          .call(contract: _contract, function: _userCount, params: []);
      int id = idList[0].toInt();

      // kreiraj json
      final String payloadJson =
          createUserPayload(id, username); // map to string

      await client.sendTransaction(
          credentials,
          Transaction.callContract(
              gasPrice: EtherAmount.inWei(BigInt.one),
              maxGas: 6721975,
              contract: _contract,
              function: _createUser,
              parameters: [
                username,
                payloadJson, // prosledjivanje payload-a na blockchain
                firstName,
                lastName,
                personalAddress,
                phone,
                email,
                city,
                zipCode,
                image
              ]));
    }
    return answer;
  }

  // funkcija za login
  // proverava tokene i vraca ga ako je sve u redu
  // poziva funkciju u sol i pokusava da pronadje korisnika sa istim korisnickim imenom i sifrom
  Future<String> login(String username) async {
    String token = await authApi.checkToken(
        username, _contract, client, _getJson, _getUserByUsername, ownAddress);

    if (token != null) {
      // do login
      List answerList = await client.call(
          sender: ownAddress,
          contract: _contract,
          function: _attemptLogin,
          params: [username, ownAddress]);

      if (answerList[1] == true) {
        await FlutterKeychain.put(key: "token", value: token);
        await getUser(answerList[0].toInt());

        currentUsername = username; //sacuvaj ulogovanog korisnika
        return token;
      }
    }

    return null;
  }

  Future<bool> logout() async {
    await FlutterKeychain.remove(key: "token");

    var token = await FlutterKeychain.get(key: "token");
    if (token == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await FlutterKeychain.remove(key: "privatekey");
      //restartovanje teme ??
      Tema.dark=false;
      return true;
    } else
      return false;
  }

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("username");
  }

  Future<void> getUser(int index) async {
    //SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List answerList = await client.call(
        sender: ownAddress, contract: _contract, function: _getUser, params: [BigInt.from(index)]);

    currentUsername = answerList[0][0][1]; //sacuvaj ulogovanog korisnika

    prefs.setInt("id", answerList[0][0][0].toInt());
    prefs.setString("username", answerList[0][0][1]);
    prefs.setString("ownerAddress", (answerList[0][0][2] as EthereumAddress).hex);
    prefs.setString("firstname", answerList[0][1][0]);
    prefs.setString("lastname", answerList[0][1][1]);
    prefs.setString("personalAddress", answerList[0][1][2]);
    prefs.setString("phone", answerList[0][2][0]);
    prefs.setString("email", answerList[0][2][1]);
    prefs.setString("city", answerList[0][2][2]);
    prefs.setString("zipCode", answerList[0][2][3]);
    prefs.setString("image", answerList[0][2][4]);

    int userId = answerList[0][0][0].toInt();
    if (SeenNotificationsHandler.globalHandler?.userId != userId) {
      await SeenNotificationsHandler.setGlobalHandlerFromUserId(userId);
    }

    print("Korisnicko ime i id novog ulogovanog: " + prefs.getString("username") + " " + prefs.getInt("id").toString());
  }

  Future<String> GetOwnerUsername(int id) async{

    List answer = await client.call(contract: _contract, function: _users, params: [BigInt.from(id)]);
    var username = answer[0][1];

    return username;
  }

  Future<String> getFirstnameLastname(int id) async{

    List answer = await client.call(contract: _contract, function: _users, params: [BigInt.from(id)]);
    return answer[1][0] + " " + answer[1][1];
  }

  /*----- UZIMANJE INFORMACIJA O DRUGOM KORISNIKU ----- */
   Future<EthereumAddress> GetOwnerInfo(String username) async {
     List answerList = await client
         .call(contract: _contract, function: _getInfo, params: [username]);
     User korisnik = null;
     if (answerList[1] == true) {
       korisnik = User(
           id: answerList[0][0][0].toInt(),
           username: answerList[0][0][1],
           //username
           owner: answerList[0][0][2],
           //sifra
           json: answerList[0][0][3],
           //json
           firstName: answerList[0][1][0],
           //ime
           lastName: answerList[0][1][1],
           //prezime
           personalAddress: answerList[0][1][2],
           //adresa
           phone: answerList[0][2][0],
           //telefon
           email: answerList[0][2][1],
           city: answerList[0][2][2],
           zipCode: answerList[0][2][3],
           imageHash: answerList[0][2][4]);
       userInfoList.add(korisnik);
     }
     //var buyingModel = Provider.of<BuyingModel>(context, listen: false);
     //buyingModel.Kupovina(korisnik.owner, price);
     return korisnik.owner;
   }

  Future<String> GetCityOwner(String username) async {
    List answerList = await client
        .call(contract: _contract, function: _getInfo, params: [username]);
    String p;
    if (answerList[1] == true) {
      p = answerList[0][2][2];
    }
    return p;
  }
  Future<ImageProvider> GetImageOwner(String username) async {
    List answerList = await client
        .call(contract: _contract, function: _getInfo, params: [username]);
    ImageProvider p;
    String s;
    if (answerList[1] == true) {
      s = answerList[0][2][4];
    }
    print(answerList[0][2][4]);
    if(s!=null)
      return _loadImage(s);
  }
  Future<ImageProvider> _loadImage(String thumbnail) async {
    String image = await ipfsImage(thumbnail);
    return Image.memory(base64Decode(image)).image;
  }

  Future<String> GetNumberOwner(String username) async {
    List answerList = await client
        .call(contract: _contract, function: _getInfo, params: [username]);
    String p;
    if (answerList[1] == true) {
      p = answerList[0][2][0];
    }
    return p;
  }
  Future<bool> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username");
    print(username);
    List answerList = await client
        .call(contract: _contract, function: _getUserByUsername, params: [username]);

    int id=answerList[0].toInt();
    if(answerList[1]==true){
      // print(answerList[1]);
      // await client
      //     .call(contract: _contract, function: _deleteUser, params: [BigInt.from(id)]);
      await client.sendTransaction(credentials, Transaction.callContract(
          maxGas: 6721975,
          contract: _contract,
          function: _deleteUser,
          parameters: [BigInt.from(id)]
      ));

      logout();
      if (id != null) {
        await SeenNotificationsApi.deleteUserSeenNotifications(id);
      }
      return true;
    }
    else
      {
        return false;
        print("greska");
      }
  }

  Future<String> GetFullNameOwner(String username) async {
    List answerList = await client
        .call(contract: _contract, function: _getInfo, params: [username]);
    String p;
    if (answerList[1] == true) {
      p = answerList[0][1][0] + " " + answerList[0][1][1];
    }
    return p;
  }

  Future<bool> checkUniqueUserProperty(
      ContractFunction propertyCheckerFunction, String propertyValue) async {
    List<dynamic> res = await _extendedContract.call(
      function: propertyCheckerFunction,
      params: [propertyValue],
    );
    bool exists = res[1];

    return !exists;
  }

  Future<bool> checkUniqueUserName(String userName) async =>
      checkUniqueUserProperty(_getUserIndexByUserName, userName);

  Future<bool> checkUniqueEmail(String email) async =>
      checkUniqueUserProperty(_getUserIndexByEmail, email);

  Future<bool> checkUniquePhoneNumber(String phoneNumber) async =>
      checkUniqueUserProperty(_getUserIndexByPhoneNumber, phoneNumber);

  Future<bool> checkUniqueOwner(EthereumAddress owner) async {
    List<dynamic> res = await _extendedContract.call(
      function: _getUserIndexByOwner,
      params: [owner],
    );
    bool exists = res[1];

    return !exists;
  }

  Future<void> updateUserInfo(
      {@required String currentUserName,
      @required String firstName,
      @required String lastName,
      @required String email,
      @required String phoneNumber,
      @required String personalAddress,
      @required String city,
      @required String zipCode,
      @required String ipfsImageHash}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt("id");

    if (email != prefs.getString("email") && !await checkUniqueEmail(email)) {
      throw EmailNotUniqueException(email);
    }

    if (phoneNumber != prefs.getString("phone") &&
        !await checkUniquePhoneNumber(phoneNumber)) {
      throw PhoneNumberNotUniqueException(phoneNumber);
    }

    String userName = prefs.getString("username");

    await _extendedContract.sendTransaction(
      function: _changeUserInfo,
      params: [
        userName,
        firstName,
        lastName,
        email,
        phoneNumber,
        personalAddress,
        city,
        zipCode,
        ipfsImageHash,
      ],
    );

    await getUser(index);
  }

  Future<void> changeUserOwner({
    @required BuildContext context,
    @required String currentUsername,
    @required String newPrivateKey,
  }) async {
    EthereumAddress newOwner = await (await client.credentialsFromPrivateKey(newPrivateKey)).extractAddress();

    if (newOwner != ownAddress && !await checkUniqueOwner(newOwner)) {
      throw OwnerNotUniqueException(newOwner);
    }

    await _extendedContract.sendTransaction(
        function: _changeUserOwner,
        params: [
          currentUsername,
          newOwner,
        ],
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt("id");
    await getUser(index);

    for (dynamic model in getModelsList(context)) {
      await model.initiateSetup(newPrivateKey);
    }
    await FlutterKeychain.put(key: "privatekey", value: newPrivateKey);
  }

  Future<void> resetPrivateKey() async {
    _privateKey = "";
  }

  Future<void> savePrivateKey(String privateKey) async {
    print("setting private key " + privateKey);

    await FlutterKeychain.put(key: "privatekey", value: privateKey);
  }

  Future<void> setPrivateKey() async {
    _privateKey = await FlutterKeychain.get(
      key: "privatekey",
    );
    print(_privateKey);
    await initiateSetup(_privateKey);
    //print("private key set on startup " + _privateKey + " usermodel");
  }

  String getUsername() {
    return currentUsername;
  }
}

class EmailNotUniqueException implements Exception {
  String cause;
  EmailNotUniqueException(String email) {
    cause = "The email '$email' already exists.";
  }
}

class PhoneNumberNotUniqueException implements Exception {
  String cause;
  PhoneNumberNotUniqueException(String phoneNumber) {
    cause = "The phone number '$phoneNumber' already exists.";
  }
}

class OwnerNotUniqueException implements Exception {
  String cause;
  OwnerNotUniqueException(EthereumAddress owner) {
    cause = "The owner '$owner' already owns an account.";
  }
}
