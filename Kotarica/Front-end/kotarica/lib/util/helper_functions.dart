import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/models/BuyingModel.dart';
import 'package:kotarica/models/MarksProductModel.dart';
import 'package:kotarica/models/MarksUserModel.dart';
import 'package:kotarica/models/NotificationsModel.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/models/SavedAdsModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/web/WebModels/BuyingModelWeb.dart';
import 'package:kotarica/web/WebModels/MarksProductModelWeb.dart';
import 'package:kotarica/web/WebModels/MarksUserModelWeb.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/WebModels/SavedAdsModelWeb.dart';
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:kotarica/web/home/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kotarica/constants/network.dart';

final String nodeEndPoint = NetworkConstants.nodeEndpointDownload;
final String nodeEndPoint2 = NetworkConstants.nodeEndpointUpload;

Future<String> ipfsImage<Object>(String hash) async{
  var response = await http.post(nodeEndPoint, body: {
    "hash": hash,
  });

  String decoded;

  if(response.statusCode == 200)
  {
    decoded = json.decode(response.body)['content'];
  }
  print(decoded[0]);
  return decoded;
}

String createUserPayload(int id, String username) {
  final Map<String, dynamic> payload = {
    "id": id,
    "username": username
  }; // payload koji se salje na blockchain

  return json.encode(payload);
}

Future<ImageProvider> loadIpfsImage(String hash) async {
  print("hash: kupljeno: " + hash);
  String image = await ipfsImage(hash);
  return Image.memory(base64Decode(image)).image;
}

Widget defaultFutureLoadingWidget(BuildContext context) {
  return const CircularProgressIndicator();
}

/// Convenience function for using FutureBuilder to construct widgets depending on asynchronous resources
FutureBuilder<T> futureWidgetBuilder<T> ({
  @required Future<T> future,
  @required Function(BuildContext context, T data) builder,
  Function(BuildContext context, AsyncSnapshot<T> snapshot) loadingBuilder,
}) {
  loadingBuilder ??= (BuildContext context, AsyncSnapshot<T> snapshot) => defaultFutureLoadingWidget(context);
  return FutureBuilder<T>(
    future: future,
    builder: (BuildContext context, AsyncSnapshot<T> snapshot)
    => (snapshot.hasData ? builder(context, snapshot.data) : loadingBuilder(context, snapshot)),
  );
}

// Widget SharedPrefsWidget({ @required Widget Function(BuildContext context, SharedPreferences prefs) builder, Widget Function(BuildContext context) loadingBuilder }) {
//   loadingBuilder ??= (BuildContext context) => const CircularProgressIndicator();
//   return FutureBuilder(
//       future: SharedPreferences.getInstance(),
//       builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot)
//         => (snapshot.hasData ? builder(context, snapshot.data) : loadingBuilder(context)),
//   );
// }

/// Constructs a FutureBuilder, accepting a build method with a bundled SharedPreferences object
FutureBuilder sharedPrefsWidgetBuilder({
  @required Function(BuildContext context, SharedPreferences prefs) builder,
  Function(BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) loadingBuilder,
}) => futureWidgetBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    builder: builder,
    loadingBuilder: loadingBuilder,
  );

/// Constructs a FutureBuilder, accepting a build method with a bundled ImageProvider object obtained from an image over IPFS
FutureBuilder ipfsImageWidgetBuilder({
  @required String imageHash,
  @required Function(BuildContext context, ImageProvider imageProvider) builder,
  Function(BuildContext context, AsyncSnapshot<String> snapshot) loadingBuilder
}) => futureWidgetBuilder<String>(
    future: ipfsImage(imageHash),
    builder: (BuildContext context, String base64Image) {
      ImageProvider imageProvider = Image.memory(base64Decode(base64Image)).image;
      return builder(context, imageProvider);
    },
    loadingBuilder: loadingBuilder,
  );

Future<void> showLoadingDialog(BuildContext context, {String text = "Molimo sačekajte..."}) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return new WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              children: [
                Center(
                  child: Column(children: [
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(zelenaGlavna)),
                    SizedBox(height: 10),
                    Text(text, style: TextStyle(color: Colors.black))
                  ],),
                )
              ],
            )
        );
      }
  );
}

Future<void> showInformationAlert(BuildContext context, String text) async {
  return showDialog<void>(
    context: context,
    //barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Tema.dark?darkPozadina:bela,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text,style: TextStyle(
                color: Tema.dark?bela:crnaGlavna,

              ),),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: zelena1,
              onPrimary: Colors.white,
            ),
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              /*Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreenWeb()));*/
            },
          ),
        ],
      );
    },
  );
}


Future<void> showInformationAlertWeb(BuildContext context, String text) async {
  return showDialog<void>(
    context: context,
    //barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Tema.dark?darkPozadina:bela,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text,style: TextStyle(
                color: Tema.dark?bela:crnaGlavna,

              ),),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: zelena1,
              onPrimary: Colors.white,
            ),
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              //Navigator.of(context).pop();
              /*Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreenWeb()));*/
             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreenWeb()));
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomeScreenWeb()));


            },
          ),
        ],
      );
    },
  );
}

// NOVE MODELE UBCITI OVDE
/// Returns a list of all models within the app for convenience.
List<dynamic> getModelsList(BuildContext context) {
  return <dynamic>[
    Provider.of<UserModel>(context, listen: false),
    Provider.of<ProductModel>(context, listen: false),
    Provider.of<MarksUserModel>(context, listen: false),
    Provider.of<MarksProductModel>(context, listen: false),
    Provider.of<BuyingModel>(context, listen: false),
    Provider.of<SavedAdsModel>(context, listen: false),
    Provider.of<NotificationsModel>(context, listen: false),
  ];
}

// NOVE MODELE UBCITI OVDE
/// Returns a list of all models within the app for convenience.
List<dynamic> getModelsListWeb(BuildContext context) {
  return <dynamic>[
    Provider.of<UserModelWeb>(context, listen: false),
    Provider.of<MarksUserModelWeb>(context, listen: false),
    Provider.of<ProductModelWeb>(context, listen: false),
    Provider.of<SavedAdsModelWeb>(context, listen: false),
    Provider.of<MarksProductModelWeb>(context, listen: false),
    Provider.of<BuyingModelWeb>(context, listen: false),
    Provider.of<NotificationsModel>(context, listen: false),
  ];
}

double trim(double n) {
  String removedDecimals = removeDecimalZeroFormat(n);
  removedDecimals = roundDecimal(double.parse(removedDecimals));

  return double.parse(removedDecimals);
}

String removeDecimalZeroFormat(double n) {
  return n.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
}

String roundDecimal(double n) {
  return n.toStringAsFixed(6);
}
