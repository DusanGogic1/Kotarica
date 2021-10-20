import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:kotarica/constants/currencies.dart';
import 'package:kotarica/constants/strings.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:web3dart/web3dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_core/wallet_core.dart';
import 'package:kotarica/constants/network.dart';
import 'package:web_socket_channel/io.dart';
import 'package:path_provider/path_provider.dart';

import 'package:kotarica/web/home/components/body.dart';

class ProductModelWeb extends ChangeNotifier {
  Credentials credentials;
  Web3Client client;

  static List<Product> totalProducts = [];
  static int totalProductsCount = 0; // svi oglasi

  List<Product> productsToShow =
  []; // lista prikazuje oglase korisniku (homeScreen)
  int productsToShowCount = 0;

  List<Product> Myproducts = [];
  int MyproductsCount = 0;

  final String rpcUrl = NetworkConstants.rpcUrl;
  final String wsUrl = NetworkConstants.wsUrl;

  String _abiCode;

  SharedPreferences prefs;

  // ignore: deprecated_member_use
  static List<Product> cart = new List<Product>();

  static List<Product> kupljeni = new List<Product>();

  EthereumAddress _contractAddress;
  EthereumAddress ownAddress;

  DeployedContract _contract;

  ContractFunction _postCount;
  ContractFunction _posts;
  ContractFunction _createPost;
  ContractFunction _updatePost;
  ContractFunction _deletePost;
  ContractEvent _postCreated;

  String _privateKey = "";

  bool _initiated = false;
  bool _productsReady = false;
  bool _countReady = false;

  String _ownerUsername;

  ProductModelWeb() {}

  Future<void> initiateSetup([String privateKey]) async {
    client = Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });

    prefs = await SharedPreferences.getInstance();
    _privateKey = privateKey;

    await getAbi();
    await getCredentials();
    await getDeployedContract();

    if (client != null && credentials != null) notifyListeners();
  }

  Future<void> getAbi() async {
    String abiStringFile =
    await rootBundle.loadString("src/abis/PostsContract.json");
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
        ContractAbi.fromJson(_abiCode, "PostsContract"), _contractAddress);

    _postCount = _contract.function("postCount");
    _posts = _contract.function("posts");
    _createPost = _contract.function("createPost");
    _updatePost = _contract.function("updatePost");
    _deletePost = _contract.function("deletePost");
    _postCreated = _contract.event("postCreated");

    // funkcija nakon deploymenta
    // prvi param je username trenutno ulogovanog korisnika,
    // drugi param nam kazuje da li je potrebno da se menja productsToShow lista
    await getProducts("Sve kategorije");
  }

  Future<void> postProduct(
      String title,
      String category,
      String subcategory,
      String about,
      int priceRSD,
      double priceETH,
      List<Uint8List> images,
      String measuringUnit,
      String type,
      DateTime date)
  => postOrUpdateProduct(title, category, subcategory, about, priceRSD, priceETH, images, measuringUnit, type, date);

  Future<void> updateProduct(
      int postId,
      String title,
      String category,
      String subcategory,
      String about,
      int priceRSD,
      double priceETH,
      List<Uint8List> images,
      String measuringUnit,
      String type,
      DateTime date)
  => postOrUpdateProduct(title, category, subcategory, about, priceRSD, priceETH, images, measuringUnit, type, date, postId: postId);

  Future<void> postOrUpdateProduct(
      String title,
      String category,
      String subcategory,
      String about,
      int priceRSD,
      double priceETH,
      List<Uint8List> images,
      String measuringUnit,
      String type,
      DateTime date,
      {
        int postId,
      }) async {
    _productsReady = false;
    _countReady = false;
    bool update = postId != null;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = prefs.getInt("id");
    String image = prefs.getString("image");

    List<String> files = [];

    if (images.length != 0) {
      print("IF");
      for (Uint8List asset in images) {
        final filePath = "nesto";

        String base64Image = base64Encode(asset);

        final http.Client _httpClient = http.Client();
        var response =
        await _httpClient.post(NetworkConstants.nodeEndpointUpload, body: {
          "image": base64Image,
          "name": filePath,
        });

        if (response.statusCode == 200) {
          var decoded = json.decode(response.body);
          var hashCode = decoded['hash'];
          files.add(hashCode);
        }
      }
    } else {
      print("ELSE");
      files.add("QmVHPogyEADBiTqB2dcsCAM4Co2qDz3o5fDrFgHgdP8DG6");
    // Image image = Image.asset("images/default.jpg");
     // String base64Image =image..buffer.asUint8List();// base64Encode(image);
   //   var data = await rootBundle.load('images/default.jpg');

    //QmVHPogyEADBiTqB2dcsCAM4Co2qDz3o5fDrFgHgdP8DG6
    //   final bytes = await rootBundle.load("images/default.jpg");
    //   final f = File("${(await getTemporaryDirectory()).path}/default.jpg");
    //   await f.writeAsBytes(
    //       bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    //   String base64Image = base64Encode(f.readAsBytesSync());
    //  String fileName = f.path.split("/").last;
    //
    //   final http.Client _httpClient = http.Client();
    //   var response =
    //   await _httpClient.post(NetworkConstants.nodeEndpointUpload, body: {
    //     "image": base64Image,
    //     "name": fileName,
    //   });
    //
    //   if (response.statusCode == 200) {
    //     var decoded = json.decode(response.body);
    //     var hashCode = decoded['hash'];
    //     files.add(hashCode);
    //   }
    }

    String city = prefs.getString("city");
    priceETH = trim(priceETH);

    // eth to wei
    priceETH *= Currencies.wei;

    if (update) {
      await client.sendTransaction(credentials, Transaction.callContract(
        maxGas: 6721975,
        contract: _contract,
        function: _updatePost,
        parameters: [
          BigInt.from(postId),
          title,
          category + '-' + subcategory, // stack to deep resenje
          about,
          BigInt.from(priceRSD),
          BigInt.from(priceETH),
          files,
          measuringUnit,
          type,
          date.toString()
        ],
      ));
    }
    else {
      await client.sendTransaction(
          credentials,
          Transaction.callContract(
              maxGas: 6721975,
              contract: _contract,
              function: _createPost,
              parameters: [
                BigInt.from(id),
                title,
                category + '-' + subcategory, // stack to deep resenje
                about,
                BigInt.from(priceRSD),
                BigInt.from(priceETH),
                files,
                measuringUnit,
                type,
                date.toString()
              ]));
    }

    await getProducts("Sve kategorije");
  }

  Future<int> setProductCount() async {
    List productCountList = await client.call(
        sender: ownAddress,
        contract: _contract,
        function: _postCount,
        params: []);

    totalProductsCount = productCountList[0].toInt();

    print(totalProductsCount.toString() + " COUNT OF PRODUCTS");
    _countReady = true;
  }

  // funkcija za setovanje oglasa u liste
  // prvi param je username trenutno ulogovanog korisnika,
  Future<void> getProducts([String category, String subcategory]) async {
    await setProductCount();

    // Dodaj sve oglase u listu
    totalProducts.clear();
    int colorIndex = 0;
    for (var i = 0; i < totalProductsCount; i++) {
      if (colorIndex == 6) colorIndex = 0;

      var temp = await client.call(
          sender: ownAddress,
          contract: _contract,
          function: _posts,
          params: [BigInt.from(i)]);

      bool exists = temp[1][5];
      if (!exists) {
        totalProducts.add(null);
        continue;
      }

      List<String> categorySubcategoryList =
      temp[1][2].split('-'); // splitted category & subcategory

      // TODO: ???
      var user = UserModelWeb();
      await user.initiateSetup(this._privateKey);

      var username = await user.GetOwnerUsername(temp[0][0].toInt());
      // print("proizvodID: " + temp[1][0].toString());
      // print("username ownera: " + username);

      totalProducts.add(Product(
          ownerId: temp[0][0].toInt(),
          ownerUsername: username,
          ownerImage: temp[0][1],
          id: temp[1][0].toInt(),
          title: temp[1][1],
          category: categorySubcategoryList[0],
          subcategory: categorySubcategoryList[1],
          city: temp[1][3],
          exists: exists,
          about: temp[2][0],
          priceEth: temp[2][2].toDouble() / Currencies.wei,
          priceRsd: temp[2][1].toInt(),
          measuringUnit: temp[2][3],
          type: temp[2][4],
          date: DateTime.parse(temp[2][5]),
          images: temp[1][4],
          color: StringConstants.colors[colorIndex]));
      colorIndex++;
    }

    // poziv funkcije za menjanje liste productsToShow u koliko je to potrebno
    if (category != null) getProductsToShow(category, subcategory);
    _productsReady = true;
    notifyListeners();
  }

  void getProductsToShow(String category, String subcategory) {
    // izaberi oglase za prikaz korisniku (homepage)
    productsToShow.clear();
    productsToShowCount = 0;
    for (var i = 0; i < totalProductsCount; i++) {
      if (totalProducts[i] == null) {
        continue;
      }
      if (category == "Sve kategorije") {
        productsToShow.add(totalProducts[i]);
        productsToShowCount++;
      } else if (totalProducts[i].category == category && subcategory == null) {
        productsToShow.add(totalProducts[i]);
        productsToShowCount++;
      } else if (totalProducts[i].category == category &&
          totalProducts[i].subcategory == subcategory) {
        productsToShow.add(totalProducts[i]);
        productsToShowCount++;
      }
    }
  }
  Future<Product> getProductById(int id) async {
    var temp = await client.call(
        sender: ownAddress,
        contract: _contract,
        function: _posts,
        params: [BigInt.from(id)]);

    print("proizvod: " + temp.toString());
    var userModel = UserModelWeb();
    await userModel.setPrivateKey();
    var username = await userModel.GetOwnerUsername(temp[0][0].toInt());
    Product p = new Product(
        ownerId: temp[0][0].toInt(),
        ownerUsername: username,
        ownerImage: temp[0][1],
        id: temp[1][0].toInt(),
        title: temp[1][1],
        category: temp[1][2].split('-')[0],
        subcategory: temp[1][2].split('-')[1],
        city: temp[1][3],
        exists: true,
        about: temp[2][0],
        priceEth: trim(temp[2][2].toDouble() / Currencies.wei),
        priceRsd: temp[2][1].toInt(),
        measuringUnit: temp[2][3],
        type: temp[2][4],
        date: DateTime.parse(temp[2][5]),
        images: temp[1][4],
        color: StringConstants.colors[id%6]);
    print("proizvod1: ");


    return p;
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

  bool getInitiated() {
    return _initiated;
  }

  bool getProductsReady() {
    print("get");
    print(_productsReady);
    return _productsReady;
  }

  void setProductsReady(bool value) {
    _productsReady = value;
  }

  bool getTotalCountReady() {
    return _countReady;
  }

  void setTotalCountReady(bool value) {
    _countReady = value;
  }

  /* MOJI OGLASI*/
  void getMyAds() {
    Myproducts.clear();
    var _id = prefs.getInt("id");
    for (var i = 0; i < totalProductsCount; i++) {
      if (totalProducts[i]!=null && totalProducts[i].exists == true && totalProducts[i].ownerId == _id) {
        // print(totalProducts[i].title);
        Myproducts.add(totalProducts[i]);
      }
    }
    MyproductsCount = Myproducts.length;
  }
  void addToCart(Product p) {
    bool isItIn = false;
    int index = -1;
    for(int i=0;i<cart.length;i++) {
      if(cart[i].id == p.id)
      {
        cart.removeAt(i);
        index = i;
        break;
      }
    }
    if(index == -1) cart.add(p);
    else cart.insert(index, p);
    notifyListeners();
  }

  /* Filtriranje oglasa */
  void filterProductsToShow(Currency character, String minPrice,
      String maxPrice, String type, String city) {
    if (character.toString() == 'Currency.RSD') {
      // Currency RSD (default value!)

      if (minPrice != '') {
        // Min RSD set
        productsToShow = productsToShow
            .where((i) => i.priceRsd >= int.parse(minPrice))
            .toList();
        productsToShowCount = productsToShow.length;
      }

      if (maxPrice != '') {
        // Max RSD set
        productsToShow = productsToShow
            .where((i) => i.priceRsd <= int.parse(maxPrice))
            .toList();
        productsToShowCount = productsToShow.length;
      }

      if (type != null) {
        // Nudim / Trazim set
        productsToShow = productsToShow.where((i) => i.type == type).toList();
        productsToShowCount = productsToShow.length;
      }

      if (city != null) {
        // Opstina set
        productsToShow = productsToShow.where((i) => i.city == city).toList();
        productsToShowCount = productsToShow.length;
      }
    } else if (character.toString() == 'Currency.Ether') {
      // Currency ETH

      if (minPrice != '') {
        // Min ETH set
        productsToShow = productsToShow
            .where((i) => i.priceEth >= double.parse(minPrice))
            .toList();
        productsToShowCount = productsToShow.length;
      }

      if (maxPrice != '') {
        // Max ETH set
        productsToShow = productsToShow
            .where((i) => i.priceEth <= double.parse(maxPrice))
            .toList();
        productsToShowCount = productsToShow.length;
      }

      if (type != null) {
        // Nudim / Trazim set
        productsToShow = productsToShow.where((i) => i.type == type).toList();
        productsToShowCount = productsToShow.length;
      }

      if (city != null) {
        // Opstina set
        productsToShow = productsToShow.where((i) => i.city == city).toList();
        productsToShowCount = productsToShow.length;
      }
    } else
      throw ('error radiobutton');
  }



  void removeFromCart(Product p) {
    cart.remove(p);
  }

  //kada se klikne zavrsi kupovinu --> brise se sve iz card
  static void removeAllFromCart(Product p) {
    cart.clear();
  }

  static String getCartPriceSumRsd() {
    double price = 0;
    for (int i = 0; i < cart.length; i++) {
      price += cart[i].priceRsd;
    }
    return price.toString();
  }

  static String getCartPriceSumEth() {
    double price = 0;
    for (int i = 0; i < cart.length; i++) {
      price += cart[i].priceEth;
    }
    return price.toStringAsFixed(6);
  }

  static void addToKupljeni(Product p) {
    kupljeni.add(p);
  }

  static void addToKupljenifromCart(
      List<Product> proizvodi) //vise proizvoda dodaje
  {
    for (int i = 0; i < proizvodi.length; i++) {
      kupljeni.add(proizvodi[i]);
    }
  }

  Future<void> deletePostedProduct(int postId) async {
    await client.sendTransaction(credentials, Transaction.callContract(
        maxGas: 6721975,
        contract: _contract,
        function: _deletePost,
        parameters: [
          BigInt.from(postId),
        ]
    ));
  }
}
