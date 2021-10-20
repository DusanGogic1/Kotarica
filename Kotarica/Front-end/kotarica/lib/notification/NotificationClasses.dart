import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kotarica/notification/SeenNotifications/SeenNotificationsHandler.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/product/ProductInfoStore.dart';
import 'package:web3dart2prerelease/web3dart.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/user/User.dart';
import 'package:kotarica/user/UserInfoStore.dart';
import 'package:kotarica/util/helper_functions.dart';

abstract class NotificationBase implements Comparable<NotificationBase> {
  final FilterEvent filterEvent;
  bool isPresentEvent;
  final int logIndex;
  final String transactionHash;
  final int blockNum;
  int pushNotificationIndex;

  NotificationBase(this.filterEvent, this.isPresentEvent)
      : logIndex = filterEvent?.logIndex,
        transactionHash = filterEvent?.transactionHash,
        blockNum = filterEvent?.blockNum;

  bool isSeen() => SeenNotificationsHandler.globalHandler
      .isNotificationSeen(transactionHash, logIndex);

  Future<void> markAsSeen() {
    return SeenNotificationsHandler.globalHandler.addSeenNotification(transactionHash, logIndex);
  }

  Widget getWidget(BuildContext context, double size, [void Function() onTapAdditional]);

  @override
  int compareTo(NotificationBase other) {
    int cmpBlockNum = blockNum.compareTo(other.blockNum);
    if (cmpBlockNum == 0) {
      return logIndex.compareTo(other.logIndex);
    }
    return cmpBlockNum;
  }
}

class NotificationWidgetBase extends StatefulWidget {
  final NotificationBase notification;
  final double size;
  final Widget child;
  final void Function() onTapAdditional;

  NotificationWidgetBase({
    @required this.notification,
    @required this.size,
    @required this.child,
    void Function() onTapAdditional,
    Key key
  }) : this.onTapAdditional = (onTapAdditional ?? () {}), super(key: key);
  _NotificationWidgetBaseState createState() => _NotificationWidgetBaseState();
}

class _NotificationWidgetBaseState extends State<NotificationWidgetBase> {
  bool _isSeen;

  @override
  void initState() {
    super.initState();
    _isSeen = widget.notification.isSeen();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isSeen) {
          return;
        }

        widget.notification.markAsSeen();
        widget.onTapAdditional();
        setState(() {
          _isSeen = true;
        });
      },
      child: Container(
        padding: EdgeInsets.only(top: widget.size * 0.005),
        margin: EdgeInsets.only(
            left: widget.size * 0.0001, right: widget.size * 0.0001),
        decoration: BoxDecoration(
          color: (_isSeen ? Colors.white : Colors.lightGreen[50]),
          border: Border.all(color: plavaGlavna, width: widget.size * 0.0001),
          borderRadius: BorderRadius.all(Radius.circular(17.0)),
        ),
        child: Center(
          child: Container(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}


// ---------- USER RATED NOTIFICATION ---------- //

class UserRatedNotification extends NotificationBase {
  final int userIdBy;
  final int userIdWho;
  final String msg1;
  final String msg2;
  final String msg3;
  final bool liked;

  User userBy;

  UserRatedNotification._(
      {@required FilterEvent filterEvent,
        @required bool isPresentEvent,
      @required this.userIdBy,
      @required this.userIdWho,
      @required this.msg1,
      @required this.msg2,
      @required this.msg3,
      @required this.liked})
      : super(filterEvent, isPresentEvent);

  static Future<UserRatedNotification> general(
      {@required FilterEvent filterEvent,
        @required bool isPresentEvent,
      @required int userIdBy,
      @required int userIdWho,
      @required String msg1,
      @required String msg2,
      @required String msg3,
      @required bool liked}) async {
    var notification = UserRatedNotification._(
        filterEvent: filterEvent,
        isPresentEvent: isPresentEvent,
        userIdBy: userIdBy,
        userIdWho: userIdWho,
        msg1: msg1,
        msg2: msg2,
        msg3: msg3,
        liked: liked);
    await notification._initiateSetup();
    return notification;
  }

  static Future<UserRatedNotification> like(
          {@required FilterEvent filterEvent,
            @required bool isPresentEvent,
          @required int userIdBy,
          @required int userIdWho,
          @required String msg1,
          @required String msg2,
          @required String msg3}) =>
      general(
          filterEvent: filterEvent,
          isPresentEvent: isPresentEvent,
          userIdBy: userIdBy,
          userIdWho: userIdWho,
          msg1: msg1,
          msg2: msg2,
          msg3: msg3,
          liked: true);

  static Future<UserRatedNotification> dislike(
          {@required FilterEvent filterEvent,
            @required bool isPresentEvent,
          @required int userIdBy,
          @required int userIdWho,
          @required String msg1,
          @required String msg2,
          @required String msg3}) =>
      general(
          filterEvent: filterEvent,
          isPresentEvent: isPresentEvent,
          userIdBy: userIdBy,
          userIdWho: userIdWho,
          msg1: msg1,
          msg2: msg2,
          msg3: msg3,
          liked: false);

  Future<void> _initiateSetup() async {
    userBy = await UserInfoStore.getUserById(userIdBy);
  }

  @override
  String toString() {
    return '"$userIdBy" ${liked ? "likes" : "dislikes"} "$userIdWho": "$msg1", "$msg2", "$msg3"';
  }

  @override
  Widget getWidget(BuildContext context, double size, [void Function() onTapAdditional]) =>
      UserRatedNotificationWidget(notification: this, size: size, onTapAdditional: onTapAdditional);
}

class UserRatedNotificationWidget extends StatefulWidget {
  final UserRatedNotification notification;
  final double size;
  final void Function() onTapAdditional;

  UserRatedNotificationWidget(
      {@required this.notification, @required this.size, this.onTapAdditional, Key key})
      : super(key: key);
  _UserRatedNotificationState createState() => _UserRatedNotificationState();
}

class _UserRatedNotificationState extends State<UserRatedNotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return NotificationWidgetBase(
      notification: widget.notification,
      size: widget.size,
      onTapAdditional: widget.onTapAdditional,
      child: Row(
        children: [
          AspectRatio(
              aspectRatio: 1,
              child: Container(
                // padding: EdgeInsets.all(widget.size * 0.02),
                // margin: EdgeInsets.only(
                //     left: widget.size * 0.01,
                //     top: widget.size * 0.01,
                //     right: widget.size * 0.08),
                child: FittedBox(
                  child: futureWidgetBuilder(
                    future: widget.notification.userBy.imageProvider,
                    builder: (context, imageProvider)
                    => CircleAvatar(
                      backgroundImage: imageProvider,
                      radius: widget.size * 0.08,
                    ),
                    // => Container(width: 1024, height:1024, child:Image(image: imageProvider))
                  ),
                ),
              ),
          ),
          //DEO ZA TEKST OBAVESTENJA
          Expanded(
            child: Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                      "Korisnik ${widget.notification.userBy.firstName} ${widget.notification.userBy.lastName}\n",
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: plavaTekst,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    TextSpan(
                      text:
                      "Vas je ${widget.notification.liked ? "pozitivno" : "negativno"} ocenio.",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: plavaTekst, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )

          ),
        ],
      ),
    );
  }
}


// ---------- POST RATED NOTIFICATION ---------- //

class PostRatedNotification extends NotificationBase {
  final int postId;
  final int userIdBy;
  final int rating;

  Product ratedProduct;
  User userBy;

  PostRatedNotification._({
    @required FilterEvent filterEvent,
    @required bool isPresentEvent,
    @required this.postId,
    @required this.userIdBy,
    @required this.rating,
  }) : super(filterEvent, isPresentEvent);

  static Future<PostRatedNotification> instance({
    @required FilterEvent filterEvent,
    @required bool isPresentEvent,
    @required int postId,
    @required int userIdBy,
    @required int rating,
  }) async {
    var notification = PostRatedNotification._(
      filterEvent: filterEvent,
      isPresentEvent: isPresentEvent,
      postId: postId,
      userIdBy: userIdBy,
      rating: rating,
    );
    await notification._initiateSetup();
    return notification;
  }

  Future<void> _initiateSetup() async {
    userBy = await UserInfoStore.getUserById(userIdBy);
    ratedProduct = await ProductInfoStore.getProductById(postId);
  }

  @override
  String toString() {
    return '"$userIdBy" rated product/post "$postId" with rating "$rating"';
  }

  @override
  Widget getWidget(BuildContext context, double size, [void Function() onTapAdditional]) =>
      PostRatedNotificationWidget(notification: this, size: size, onTapAdditional: onTapAdditional);
}

class PostRatedNotificationWidget extends StatefulWidget {
  final PostRatedNotification notification;
  final double size;
  final void Function() onTapAdditional;

  PostRatedNotificationWidget(
      {@required this.notification, @required this.size, this.onTapAdditional, Key key})
      : super(key: key);
  _PostRatedNotificationState createState() => _PostRatedNotificationState();
}

class _PostRatedNotificationState extends State<PostRatedNotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return NotificationWidgetBase(
      notification: widget.notification,
      size: widget.size,
      onTapAdditional: widget.onTapAdditional,
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              // padding: EdgeInsets.all(widget.size * 0.02),
              // margin: EdgeInsets.only(
              //     left: widget.size * 0.01,
              //     top: widget.size * 0.01,
              //     right: widget.size * 0.08),
              child: FittedBox(
                child: futureWidgetBuilder(
                  future: widget.notification.userBy.imageProvider,
                  builder: (context, imageProvider)
                  => CircleAvatar(
                    backgroundImage: imageProvider,
                    radius: widget.size * 0.08,
                  ),
                  // => Container(width: 1024, height:1024, child:Image(image: imageProvider))
                ),
              ),
            ),
          ),
          //DEO ZA TEKST OBAVESTENJA
          Expanded(
            child: Center(
              child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                    "Korisnik ${widget.notification.userBy.firstName} ${widget.notification.userBy.lastName}\n",
                    style: Theme.of(context).textTheme.headline4.copyWith(
                        color: plavaTekst,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  TextSpan(
                    text:
                    "je ocenio Vaš proizvod ocenom ${widget.notification.rating}.",
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(color: plavaTekst, fontSize: 14),
                  ),
                ],
              ),
            ),
            )
          ),
        ],
      ),
    );
  }
}


// ---------- PRODUCT BOUGHT NOTIFICATION ---------- //

class ProductBoughtNotification extends NotificationBase {
  final int postId;
  final int userIdBy;
  final int amount;
  final String address;
  final String phoneNumber;
  final String type; // pending, confirmed, cancelled
  String mainText;
  String subText;
  Future<ImageProvider> futureImageProvider;

  Product boughtProduct;
  User userBy;

  ProductBoughtNotification._({
    @required FilterEvent filterEvent,
    @required bool isPresentEvent,
    @required this.postId,
    @required this.userIdBy,
    @required this.amount,
    @required this.address,
    @required this.phoneNumber,
    @required this.type,
  }) : super(filterEvent, isPresentEvent);

  static Future<ProductBoughtNotification> instance({
    @required FilterEvent filterEvent,
    @required bool isPresentEvent,
    @required int postId,
    @required int userIdBy,
    @required int amount,
    @required String address,
    @required String phoneNumber,
    @required String type,
  }) async {
    assert (type == "pending" || type == "confirmed" || type == "cancelled");
    var notification = ProductBoughtNotification._(
      filterEvent: filterEvent,
      isPresentEvent: isPresentEvent,
      postId: postId,
      userIdBy: userIdBy,
      amount: amount,
      address: address,
      phoneNumber: phoneNumber,
      type: type,
    );
    await notification._initiateSetup();
    return notification;
  }

  Future<void> _initiateSetup() async {
    userBy = await UserInfoStore.getUserById(userIdBy);
    boughtProduct = await ProductInfoStore.getProductById(postId);

    if (isPending) {
      futureImageProvider = userBy.imageProvider;
      mainText = "Korisnik ${userBy.firstName} ${userBy.lastName}";
      subText = "želi da kupi Vaš proizvod: ${boughtProduct.title}.";
    } else {
      futureImageProvider = loadIpfsImage(boughtProduct.images[0]);
      mainText = "${isConfirmed ? "Odobrena" : "Poništena"} Vam je porudžbina";
      subText = "za proizvod: ${boughtProduct.title}.";
    }
  }

  bool get isPending => type == "pending";
  bool get isConfirmed => type == "confirmed";
  bool get isCancelled => type == "cancelled";

  @override
  String toString() {
    String action;
    if (isPending) {
      action = "wants to buy";
    } else if (isConfirmed) {
      action = "bought";
    } else if (isCancelled) {
      action = "can't buy";
    }

    return '"$userIdBy" $action $amount of product "$postId", to be shipped to "$address." Call $phoneNumber.';
  }

  @override
  Widget getWidget(BuildContext context, double size, [void Function() onTapAdditional]) =>
      ProductBoughtNotificationWidget(notification: this, size: size, onTapAdditional: onTapAdditional);
}

class ProductBoughtNotificationWidget extends StatefulWidget {
  final ProductBoughtNotification notification;
  final double size;
  final void Function() onTapAdditional;

  ProductBoughtNotificationWidget(
      {@required this.notification, @required this.size, this.onTapAdditional, Key key})
      : super(key: key);
  _ProductBoughtNotificationState createState() => _ProductBoughtNotificationState();
}

class _ProductBoughtNotificationState extends State<ProductBoughtNotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return NotificationWidgetBase(
      notification: widget.notification,
      size: widget.size,
      onTapAdditional: widget.onTapAdditional,
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              // padding: EdgeInsets.all(widget.size * 0.02),
              // margin: EdgeInsets.only(
              //     left: widget.size * 0.01,
              //     top: widget.size * 0.01,
              //     right: widget.size * 0.08),
              child: FittedBox(
                child: futureWidgetBuilder(
                  future: widget.notification.futureImageProvider,
                  builder: (context, imageProvider)
                  => CircleAvatar(
                    backgroundImage: imageProvider,
                    radius: widget.size * 0.08,
                  ),
                  // => Container(width: 1024, height:1024, child:Image(image: imageProvider))
                ),
              ),
            ),
          ),
          //DEO ZA TEKST OBAVESTENJA
          Expanded(
            child: Center(
              child:RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                      "${widget.notification.mainText}\n",
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: plavaTekst,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    TextSpan(
                      text:
                      widget.notification.subText,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: plavaTekst, fontSize: 14),
                    ),
                  ],
                ),
              )
            )
          ),
        ],
      ),
    );
  }
}
