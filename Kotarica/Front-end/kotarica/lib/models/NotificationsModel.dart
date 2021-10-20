import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:http/http.dart';
import 'package:kotarica/product/ProductInfoStore.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:web3dart2prerelease/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:async/async.dart' show StreamGroup;
import 'package:rxdart/rxdart.dart';

import 'package:kotarica/constants/network.dart';
import 'package:kotarica/util/ContractHelperPrerelease.dart';
import 'package:kotarica/notification/NotificationClasses.dart';
import 'package:kotarica/notification/SeenNotifications/SeenNotificationsHandler.dart';
import 'package:kotarica/user/UserInfoStore.dart';

class NotificationsModel extends ChangeNotifier {
  String _privateKey;

  String _rpcUrl;
  String _wsUrl;
  Web3Client _client;

  ContractHelper likesContract;
  ContractHelper productMarksContract;
  ContractHelper buyingContract;

  ContractEvent _addedLike;
  ContractEvent _addedDislike;
  ContractEvent _postRated;
  ContractEvent _purchase;

  Future<List<FilterEvent>> _addedLikeLogs;
  Future<List<FilterEvent>> _addedDislikeLogs;
  Future<List<FilterEvent>> _postRatedLogs;
  Future<List<FilterEvent>> _purchaseLogs;
  Future<void> _fetchingUsersFromLogs;

  Stream<FilterEvent> _addedLikeStream;
  Stream<FilterEvent> _addedDislikeStream;
  Stream<FilterEvent> _postRatedStream;
  Stream<FilterEvent> _purchaseStream;
  
  Stream<Tuple2<FilterEvent, bool>> _addedLikeChronologicalStream;
  Stream<Tuple2<FilterEvent, bool>> _addedDislikeChronologicalStream;
  Stream<Tuple2<FilterEvent, bool>> _postRatedChronologicalStream;
  Stream<Tuple2<FilterEvent, bool>> _purchaseChronologicalStream;

  int _userId;

  BehaviorSubject<List<NotificationBase>> _notificationsSubject;
  Stream<List<NotificationBase>> notificationsStream;
  StreamSubscription _streamAllSubscription;

  NotificationsModel();

  Future<void> setPrivateKey() async {
    if (!kIsWeb) {
      _privateKey = await FlutterKeychain.get(
        key: "privatekey",
      );
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _privateKey = prefs.getString("privatekey");
    }

    await initiateSetup(_privateKey);
  }

  Future<void> resetPrivateKey() async {
    _privateKey = "";
  }

  Future<void> savePrivateKey(String privateKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("privatekey", privateKey);
  }

  void setUserId(int id) {
    _userId = id;
    _setUpChronologicalEventStreams();
  }

  Future<void> initiateSetup([String privateKey]) async {
    _rpcUrl = NetworkConstants.rpcUrl;
    _wsUrl = NetworkConstants.wsUrl;
    if(privateKey != null) {
      _privateKey = privateKey;
    }

    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await _getDeployedContracts();

    notifyListeners();
  }

  Future<void> _getDeployedContracts() async {
    likesContract = await ContractHelper.fromParams(
      rpcUrl: _rpcUrl,
      wsUrl: _wsUrl,
      privateKey: _privateKey,
      contractName: "LikesContract",
    );
    _addedLike = likesContract.event("AddedLike");
    _addedDislike = likesContract.event("AddedDislike");

    productMarksContract = await ContractHelper.fromParams(
        rpcUrl: _rpcUrl,
        wsUrl: _wsUrl,
        privateKey: _privateKey,
        contractName: "ProductMarksContract",
    );
    _postRated = productMarksContract.event("PostRated");

    buyingContract = await ContractHelper.fromParams(
        rpcUrl: _rpcUrl,
        wsUrl: _wsUrl,
        privateKey: _privateKey,
        contractName: "BuyingContract",
    );
    _purchase = buyingContract.event("purchase");
  }

  void _setUpChronologicalEventStreams() async {
    if (_streamAllSubscription != null) {
      _streamAllSubscription.cancel();
    }

    _getEventLogs();
    _getEventStreams();

    _addedLikeChronologicalStream = pastAndPresentEvents(_addedLikeLogs, _addedLikeStream);
    _addedDislikeChronologicalStream = pastAndPresentEvents(_addedDislikeLogs, _addedDislikeStream);
    _postRatedChronologicalStream = pastAndPresentEvents(_postRatedLogs, _postRatedStream);
    _purchaseChronologicalStream = pastAndPresentEvents(_purchaseLogs, _purchaseStream);

    _notificationsSubject = BehaviorSubject<List<NotificationBase>>();
    notificationsStream = _notificationsSubject.stream;
    await _listenNotificationsStream();
  }

  void _getEventLogs() {
    _addedLikeLogs = _client.getLogs(FilterOptions.events(
      contract: likesContract.contract,
      event: _addedLike,
      fromBlock: BlockNum.genesis(),
      toBlock: BlockNum.current(),
    ));

    _addedDislikeLogs = _client.getLogs(FilterOptions.events(
      contract: likesContract.contract,
      event: _addedDislike,
      fromBlock: BlockNum.genesis(),
      toBlock: BlockNum.current(),
    ));

    _postRatedLogs = _client.getLogs(FilterOptions.events(
      contract: productMarksContract.contract,
      event: _postRated,
      fromBlock: BlockNum.genesis(),
      toBlock: BlockNum.current(),
    ));

    _purchaseLogs = _client.getLogs(FilterOptions.events(
      contract: buyingContract.contract,
      event: _purchase,
      fromBlock: BlockNum.genesis(),
      toBlock: BlockNum.current(),
    ));

    _fetchingUsersFromLogs = _fetchUsersFromLogs();
  }

  Future<void> _fetchUsersFromLogs() async {
    await _fetchUsersFromEventsByIds(_addedLikeLogs, _addedLike, 0);
    await _fetchUsersFromEventsByIds(_addedDislikeLogs, _addedDislike, 0);
    await _fetchUsersFromEventsByIds(_postRatedLogs, _postRated, 1);
    await _fetchUsersFromEventsByIds(_purchaseLogs, _purchase, 0);
  }

  Future<void> _fetchUsersFromEventsByIds(Future<List<FilterEvent>> events, ContractEvent eventToDecode, int indexOfUserId) async {
    for (FilterEvent event in await events) {
      var decoded = eventToDecode.decodeResults(event.topics, event.data);
      int userId = decoded[indexOfUserId].toInt();
      await UserInfoStore.getUserById(userId);
    }
  }

  void _getEventStreams() {
    _addedLikeStream = _client.events(FilterOptions.events(
        contract: likesContract.contract,
        event: _addedLike,
    ));

    _addedDislikeStream = _client.events(FilterOptions.events(
        contract: likesContract.contract,
        event: _addedDislike,
    ));

    _postRatedStream = _client.events(FilterOptions.events(
      contract: productMarksContract.contract,
      event: _postRated,
    ));

    _purchaseStream = _client.events(FilterOptions.events(
      contract: buyingContract.contract,
      event: _purchase,
    ));
  }

  static Stream<Tuple2<FilterEvent, bool>> pastAndPresentEvents(Future<List<FilterEvent>> pastEvents, Stream<FilterEvent> presentEvents) async* {
    for (FilterEvent event in await pastEvents) yield Tuple2(event, false);
    await for (FilterEvent event in presentEvents) yield Tuple2(event, true);
  }

  Stream<UserRatedNotification> _streamLikes([Stream<Tuple2<FilterEvent, bool>> fromStream]) async* {
    fromStream ??= _addedLikeChronologicalStream;
    await for (var eventTuple in fromStream) {
      var event = eventTuple.item1;
      var isPresent = eventTuple.item2;
      var decoded = _addedLike.decodeResults(event.topics, event.data);
      
      int userIdBy = decoded[0].toInt();
      int userIdWho = decoded[1].toInt();
      print("userIdWho: $userIdWho; _userId: $_userId");
      if (userIdWho != _userId) {
        continue;
      }
      yield await UserRatedNotification.like(
        filterEvent: event,
        isPresentEvent: isPresent,
        userIdBy: userIdBy,
        userIdWho: userIdWho,
        msg1: decoded[2],
        msg2: decoded[3],
        msg3: decoded[4],
      );
    }
  }

  Stream<UserRatedNotification> _streamDislikes([Stream<Tuple2<FilterEvent, bool>> fromStream]) async* {
    fromStream ??= _addedDislikeChronologicalStream;
    await for (var eventTuple in fromStream) {
      var event = eventTuple.item1;
      var isPresent = eventTuple.item2;
      var decoded = _addedDislike.decodeResults(event.topics, event.data);

      int userIdBy = decoded[0].toInt();
      int userIdWho = decoded[1].toInt();
      if (userIdWho != _userId) {
        continue;
      }
      yield await UserRatedNotification.dislike(
        filterEvent: event,
        isPresentEvent: isPresent,
        userIdBy: userIdBy,
        userIdWho: userIdWho,
        msg1: decoded[2],
        msg2: decoded[3],
        msg3: decoded[4],
      );
    }
  }

  Stream<PostRatedNotification> _streamPostRatings([Stream<Tuple2<FilterEvent, bool>> fromStream]) async* {
    fromStream ??= _postRatedChronologicalStream;
    await for (var eventTuple in fromStream) {
      var event = eventTuple.item1;
      var isPresent = eventTuple.item2;
      var decoded = _postRated.decodeResults(event.topics, event.data);

      int postId = decoded[0].toInt();

      int userIdWho = (await ProductInfoStore.getProductById(postId)).ownerId;
      if (userIdWho != _userId) {
        continue;
      }

      int userIdBy = decoded[1].toInt();
      int rating = decoded[2].toInt();
      yield await PostRatedNotification.instance(
          filterEvent: event,
          isPresentEvent: isPresent,
          postId: postId,
          userIdBy: userIdBy,
          rating: rating
      );
    }
  }

  Stream<ProductBoughtNotification> _streamProductBuyings([Stream<Tuple2<FilterEvent, bool>> fromStream]) async* {
    fromStream ??= _purchaseChronologicalStream;
    await for (var eventTuple in fromStream) {
      var event = eventTuple.item1;
      var isPresent = eventTuple.item2;
      var decoded = _purchase.decodeResults(event.topics, event.data);

      int userIdBuyer = decoded[0].toInt();
      int userIdSeller = decoded[1].toInt();
      String type = decoded[6];

      int filterByUserId = (type == "pending" ? userIdSeller : userIdBuyer);
      if (filterByUserId != _userId) {
        continue;
      }

      int postId = decoded[2].toInt();
      int amount = decoded[3].toInt();
      String address = decoded[4];
      String phoneNumber = decoded[5];

      yield await ProductBoughtNotification.instance(
          filterEvent: event,
          isPresentEvent: isPresent,
          postId: postId,
          userIdBy: userIdBuyer,
          amount: amount,
          address: address,
          phoneNumber: phoneNumber,
          type: type
      );
    }
  }

  Stream<NotificationBase> _streamAll([
    Stream<Tuple2<FilterEvent, bool>> fromLikesStream,
    Stream<Tuple2<FilterEvent, bool>> fromDislikesStream,
    Stream<Tuple2<FilterEvent, bool>> fromRatingsStream,
    Stream<Tuple2<FilterEvent, bool>> fromBuyingsStream,
  ]) => StreamGroup.merge<NotificationBase>(<Stream<NotificationBase>>[
    _streamLikes(fromLikesStream).cast<NotificationBase>(),
    _streamDislikes(fromDislikesStream).cast<NotificationBase>(),
    _streamPostRatings(fromRatingsStream).cast<NotificationBase>(),
    _streamProductBuyings(fromBuyingsStream).cast<NotificationBase>(),
  ]).cast<NotificationBase>();

  // Future<void> _listenToLikes() async {
  //   await for (FilterEvent event in _addedLikeChronologicalStream) {
  //     var decoded = _addedLike.decodeResults(event.topics, event.data);
  //
  //     var notification = await UserRatedNotification.like(
  //       filterEvent: event,
  //       usernameBy: decoded[0],
  //       usernameWho: decoded[1],
  //       msg1: decoded[2],
  //       msg2: decoded[3],
  //       msg3: decoded[4],
  //     );
  //
  //     print(notification);
  //   }
  // }

  // Future<void> _listenToLikes2() async {
  //   await for (NotificationBase notification in notificationsStream) {
  //     if (notification is UserRatedNotification) {
  //       print(notification);
  //     }
  //   }
  // }

  List<NotificationBase> _notifications;
  Future<void> _listenNotificationsStream() async {
    // print("Started streaming i guess");
    await _fetchingUsersFromLogs;
    await SeenNotificationsHandler.initializingGlobalHandler;

    _notifications = [];
    _notificationsSubject.add(_notifications);

    if (kIsWeb) {
      _streamAllSubscription = _pollingNotificationsStream().listen((notifications) {
        _notifications = notifications;
        _notificationsSubject.add(_notifications);
        notifyListeners();
      });
    } else {
      _streamAllSubscription = _streamAll().listen((notification) {
        _notifications.add(notification);
        _notificationsSubject.add(_notifications);
        notifyListeners();
      });
    }
  }

  Stream<Tuple2<FilterEvent, bool>> _logsToEvents(Future<List<FilterEvent>> logs) async* {
    for (FilterEvent event in await logs) yield Tuple2(event, false);
  }

  // Bravo za web3dart što ne sluša eventove na web verziji aplikacije
  Stream<List<NotificationBase>> _pollingNotificationsStream() async* {
    while (true) {
      await _getEventLogs();

      List<NotificationBase> notifications = [];
      await for (NotificationBase notification in _streamAll(
        _logsToEvents(_addedLikeLogs),
        _logsToEvents(_addedDislikeLogs),
        _logsToEvents(_postRatedLogs),
        _logsToEvents(_purchaseLogs)
      )) {
        notifications.add(notification);
      }
      if (notifications.length > _notifications.length) {
        yield notifications;
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }
}
