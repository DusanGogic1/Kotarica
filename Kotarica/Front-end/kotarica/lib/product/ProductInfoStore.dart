import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:http/http.dart';
import 'package:kotarica/constants/strings.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import 'package:kotarica/constants/network.dart';
import 'package:kotarica/user/User.dart';
import 'package:kotarica/util/ContractHelper.dart';

import 'Product.dart';

class ProductInfoStore {
  static String _rpcUrl = NetworkConstants.rpcUrl;
  static String _wsUrl = NetworkConstants.wsUrl;
  static String _privateKey;
  static Web3Client _client;

  static bool _initiated = false;

  static ContractHelper _postsContract;

  // PostsContract functions
  static ContractFunction _posts;
  static ContractFunction _postCount;

  static StreamSubscription<FilterEvent> _postChangedSubscription;
  static StreamSubscription<FilterEvent> _postDeletedSubscription;

  static var _byId = HashMap<int, Product>();

  // Public fields
  static bool get isInitiated => _initiated;

  static var _initCompleter = Completer<void>();
  static Future<void> get initiating => _initCompleter.future;

  ProductInfoStore._();

  static Future<void> initiateSetup(String privateKey) async {
    if (_initCompleter.isCompleted)  {
      _initCompleter = Completer<void>();
    }

    if (_initiated) {
      if (privateKey == _privateKey) {
        _initCompleter.complete();
        return;
      }

      await _postChangedSubscription.cancel();
      await _postDeletedSubscription.cancel();
    }
    _privateKey = privateKey;

    await _initiateContracts();

    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    _listenForPostChanges();

    _initiated = true;
    if (_initCompleter.isCompleted==false)  {
      _initCompleter.complete();

    }
  }

  static Future<void> _initiateContracts() async {
    _postsContract = await ContractHelper.fromParams(
      rpcUrl: _rpcUrl,
      wsUrl: _wsUrl,
      privateKey: _privateKey,
      contractName: "PostsContract",
    );
    _posts = _postsContract.function("posts");
    _postCount = _postsContract.function("postCount");
  }

  static void _listenForPostChanges() {
    var postChangedEvent = _postsContract.event("PostChanged");
    var postChangedEventStream = _client.events(FilterOptions.events(contract: _postsContract.contract, event: postChangedEvent));
    _postChangedSubscription = postChangedEventStream.listen((event) async {
      var decoded = postChangedEvent.decodeResults(event.topics, event.data);
      BigInt idBig = decoded[0];
      int id = idBig.toInt();

      if (!_byId.containsKey(id)) {
        return;
      }

      _uncachePost(_byId[id]);
      _cachePost(await _postFromContractById(idBig));
    });

    var postDeletedEvent = _postsContract.event("PostDeleted");
    var postDeletedEventStream = _client.events(FilterOptions.events(contract: _postsContract.contract, event: postDeletedEvent));
    _postDeletedSubscription = postDeletedEventStream.listen((event) {
      var decoded = postDeletedEvent.decodeResults(event.topics, event.data);
      int id = decoded[0].toInt();

      if (!_byId.containsKey(id)) {
        return;
      }

      _uncachePost(_byId[id]);
    });
  }

  static Future<Product> _postFromContractById(BigInt id) async {
    List numPostsList = await _postsContract.call(function: _postCount, params: []);
    BigInt numPosts = numPostsList[0];
    if (id >= numPosts) {
      return null;
    }

    List<dynamic> resPost = await _postsContract.call(function: _posts, params: [id]);
    Product product = await Product.fromTuples(resPost, StringConstants.colors[Random().nextInt(StringConstants.colors.length)]);
    return product;
  }

  static void _cachePost(Product product) {
    if (product == null) {
      return;
    }
    _byId[product.id] = product;
  }

  static void _uncachePost (Product product) {
    assert (product != null);

    _byId.remove(product.id);
  }

  static Future<Product> getProductById(int id) async {
    if (_byId.containsKey(id)) {
      return _byId[id];
    }

    print("getProductById($id)");
    print("WWWWWWWWWWaiting for completer...");
    await initiating;
    print("DDDDDDDDDDone waiting");
    Product product = await _postFromContractById(BigInt.from(id));
    _cachePost(product);

    return product;
  }
}