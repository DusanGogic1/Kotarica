import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/product/ProductInfoStore.dart';
import 'package:kotarica/web/home/HomeScreen.dart';
import 'package:provider/provider.dart';

import 'package:kotarica/ads/AddAdvertPageOne.dart';
import 'package:kotarica/models/NotificationsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/navigation_drawer/maindrawer.dart';
import '../../constants/style.dart';
import '../../notification/NotificationClasses.dart';

class NotificationPageWeb extends StatefulWidget {
  @override
  _NotificationPageWebState createState() => _NotificationPageWebState();
}

class _NotificationPageWebState extends State<NotificationPageWeb> {
  List<NotificationBase> _notificationsList;
  // PushNotificationHelper _userRatedPushNotifications;
  // PushNotificationHelper _productRatedPushNotifications;
  // PushNotificationHelper _productBoughtPushNotifications;

  @override
  void initState() {
    super.initState();
    // _userRatedPushNotifications = PushNotificationHelper(
    //   channelId: "kotarica_userrated",
    //   channelName: "Profile Rated",
    //   channelDescription: "When someone likes/dislikes your profile",
    //   onSelectNotification: _onSelectUserRatedNotification,
    // );
    //
    // _productRatedPushNotifications = PushNotificationHelper(
    //   channelId: "kotarica_productrated",
    //   channelName: "Product Post Rated",
    //   channelDescription: "When someone rates one of your product posts",
    // );
    //
    // _productBoughtPushNotifications = PushNotificationHelper(
    //   channelId: "kotarica-productbought",
    //   channelName: "Product Purchased",
    //   channelDescription: "When someone purchases a certain quantity of your product",
    // );
  }

  // Future _onSelectUserRatedNotification(String listIndexStr) {
  //   int listIndex = int.parse(listIndexStr);
  //   // setState(() {
  //   //   _notificationsList[listIndex].markAsSeen();
  //   // });
  // }
  //
  // int _makePushNotification(NotificationBase notification, int listIndex) {
  //   if (notification is UserRatedNotification) return _makeUserRatedPushNotification(notification, listIndex);
  //   else if (notification is PostRatedNotification) return _makeProductRatedPushNotification(notification, listIndex);
  //   else if (notification is ProductBoughtNotification) return _makeProductBoughtPushNotification(notification, listIndex);
  //   else throw("Unknown or unsupported notification type for push notifications");
  // }
  //
  // int _makeGenericPushNotification({@required PushNotificationHelper helper, @required String title, @required String body, @required int listIndex}) {
  //   int notificationId = helper.reserveId();
  //   helper.show(title, body, id: notificationId, payload: listIndex.toString());
  //   return notificationId;
  // }
  //
  // int _makeUserRatedPushNotification(UserRatedNotification notification, int listIndex)
  // => _makeGenericPushNotification(
  //     helper: _userRatedPushNotifications,
  //     title: "Korisnik ${notification.userBy.firstName} ${notification.userBy.lastName}",
  //     body: "Vas je ${notification.liked ? "pozitivno" : "negativno"} ocenio",
  //     listIndex: listIndex
  // );
  //
  // int _makeProductRatedPushNotification(PostRatedNotification notification, int listIndex)
  // => _makeGenericPushNotification(
  //     helper: _productRatedPushNotifications,
  //     title: "Korisnik ${notification.userBy.firstName} ${notification.userBy.lastName}",
  //     body: "je ocenio Va?? proizvod ocenom ${notification.rating}.",
  //     listIndex: listIndex
  // );
  //
  // int _makeProductBoughtPushNotification(ProductBoughtNotification notification, int listIndex)
  // => _makeGenericPushNotification(
  //     helper: _productBoughtPushNotifications,
  //     title: notification.mainText,
  //     body: notification.subText,
  //     listIndex: listIndex
  // );

  @override
  Widget build(BuildContext context) {
    var notificationsModel = Provider.of<NotificationsModel>(context,listen:true);
    var notificationsStream = notificationsModel.notificationsStream;
    var size = MediaQuery.of(context).size.width;
    // print("About to query stream i guess");


    return Container(
        width: 500,
        child: Column(
          children: [
            Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size * 0.04),
                  /*GRID SE KORISTI ZA OBAVESTENJA*/
                  child: StreamBuilder(
                      stream: notificationsStream,
                      builder: (context, AsyncSnapshot<List<NotificationBase>> snapshot) {
                        if (snapshot.hasData) {
                          _notificationsList = snapshot.data;
                          _notificationsList.sort();
                          if (_notificationsList.length > 0) {
                            dynamic newNotification = _notificationsList.last;
                            if (newNotification.isPresentEvent) {
                              // int notificationIndex = _makePushNotification(newNotification, _notificationsList.length - 1);

                              newNotification.isPresentEvent = false;
                              // newNotification.pushNotificationIndex = notificationIndex;
                            }
                          }

                            return ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              //BROJ OBAVESTENJA ZA PRIKAZIVANJE
                              itemCount: _notificationsList.length + 2,
                              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              //   crossAxisSpacing: 1,
                              //   mainAxisSpacing: 1,
                              //   crossAxisCount: 1,
                              //   childAspectRatio: MediaQuery.of(context).size.width /
                              //       (MediaQuery.of(context).size.height / 9),
                              // ),
                              reverse: true,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 1) {
                                  // return  SizedBox();
                                  // return TextButton(
                                  //   onPressed: () async {
                                  //     await notificationsModel.likesContract.sendTransaction(
                                  //       function: notificationsModel.likesContract.function("addLike"),
                                  //       params: [BigInt.from((await SharedPreferences.getInstance()).getInt("id")), BigInt.from(1), "Da", "Da", "Da"],
                                  //     );
                                  //     print("bruh");
                                  //   },
                                  //   child: Text("Like user 'bbbb'"),
                                  // );
                                  // return TextButton(
                                  //   child: Text("Rate product 0 with rating of 9"),
                                  //   onPressed: () async {
                                  //     await notificationsModel.productMarksContract.sendTransaction(
                                  //         function: notificationsModel.productMarksContract.function("addMarks"),
                                  //         params: [BigInt.from(9), BigInt.from(0), BigInt.from((await SharedPreferences.getInstance()).getInt("id"))],
                                  //     );
                                  //   },
                                  // );
                                  return Row(children: [
                                    TextButton(
                                      child: Text("Pending"),
                                      onPressed: () async {
                                        await notificationsModel.buyingContract.sendTransaction(
                                          function: notificationsModel.buyingContract.function("addToPending"),
                                          params: [
                                            BigInt.from((await SharedPreferences.getInstance()).getInt("id")),
                                            BigInt.from((await ProductInfoStore.getProductById(0)).ownerId),
                                            BigInt.from(0),
                                            BigInt.from(5),
                                            "Medakovi??eva bb",
                                            (await SharedPreferences.getInstance()).getString("phone"),
                                            "kg",
                                            "RSD"
                                          ],
                                        );
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Confirm"),
                                      onPressed: () async {
                                        await notificationsModel.buyingContract.sendTransaction(
                                          function: notificationsModel.buyingContract.function("addToConfirmed"),
                                          params: [BigInt.from(0)],
                                        );
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () async {
                                        await notificationsModel.buyingContract.sendTransaction(
                                          function: notificationsModel.buyingContract.function("addToCanceled"),
                                          params: [BigInt.from(0)],
                                        );
                                      },
                                    ),
                                  ]);
                                }
                                else if (index == 0) {
                                  // return  SizedBox();
                                  return TextButton(
                                    onPressed: () async {
                                      await notificationsModel.likesContract.sendTransaction(
                                        function: notificationsModel.likesContract.function("addDislike"),
                                        params: [BigInt.from((await SharedPreferences.getInstance()).getInt("id")), BigInt.from(1), "Da", "Da", "Da"],
                                      );
                                      print("bruh");
                                    },
                                    child: Text("Dislike user 'bbbb'"),
                                  );
                                }

                                int listIndex = index - 2;
                                NotificationBase listElement = _notificationsList[listIndex];
                                return Container(
                                  height: 96,
                                  child:listElement.getWidget(context, size, () {
                                    int pushIndex = listElement.pushNotificationIndex;
                                    if (pushIndex != null) {
                                      // _userRatedPushNotifications.cancel(pushIndex);
                                    }
                                  })
                                );
                              },
                            );
                        } else {
                          // return Center(child: Text("Trentno nemate obave??tenja.", style:
                          //   TextStyle(color: Tema.dark ? bela: crnaGlavna)));
                          return Center(child: SizedBox());
                        }
                      }),
                )),
          ],
        ));
  }

}
