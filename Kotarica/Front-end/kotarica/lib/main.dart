import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:kotarica/constants/MyThemes.dart';
import 'package:kotarica/models/BuyingModel.dart';
import 'package:kotarica/models/MarksProductModel.dart';
import 'package:kotarica/models/MarksUserModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/registration/Welcome.dart';
import 'package:kotarica/util/AuthApi.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:kotarica/web/WebModels/BuyingModelWeb.dart';
import 'package:kotarica/web/WebModels/MarksProductModelWeb.dart';
import 'package:kotarica/web/WebModels/MarksUserModelWeb.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/WebModels/SavedAdsModelWeb.dart';
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:kotarica/web/home/HomeScreen.dart';
import 'package:kotarica/web/registration/Welcome.dart';

import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

import 'home/HomeScreen.dart';
import 'models/NotificationsModel.dart';
import 'models/ProductModel.dart';

import 'models/SavedAdsModel.dart';
import 'util/helper_functions.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  if (kIsWeb) {
    print("web");
    runApp(MyAppWeb());
  } else {
    print("telefon");
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  AuthApi authApi = new AuthApi();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(create: (context) => UserModel()),
        ChangeNotifierProvider<ProductModel>(
            create: (context) => ProductModel()),
        ChangeNotifierProvider<MarksUserModel>(
            create: (context) => MarksUserModel()),
        ChangeNotifierProvider<MarksProductModel>(
            create: (context) => MarksProductModel()),
        ChangeNotifierProvider<BuyingModel>(create: (context) => BuyingModel()),
        ChangeNotifierProvider<SavedAdsModel>(
            create: (context) => SavedAdsModel()),
        ChangeNotifierProvider<NotificationsModel>(
            create: (context) => NotificationsModel()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kotarica',
        theme: ThemeData(fontFamily: "Montserrat"),
        home: FutureBuilder(
          future: tokenOrEmpty, // provera tokena
          builder: (context, snapshot) {
            // return Welcome();
            if (snapshot.data != null) {
              var str = snapshot.data;
              var token = str.split(".");

              if (token.length != 3) {
                return Welcome();
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(token[1]))));
                print(
                    DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000));

                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                    .isAfter(DateTime.now())) {
                  Provider.of<UserModel>(context, listen: false)
                      .setPrivateKey();
                  for (dynamic model in getModelsList(context)) {
                    model.setPrivateKey();
                  }
                  return HomeScreen(); // idi na home page
                } else
                  return Welcome();
              }
            } else
              return Welcome();
          },
        ),
      ),
    );
  }

  Future<String> get tokenOrEmpty async {
    var token = await FlutterKeychain.get(key: "token");
    print("token" + token);
    if (token == null) return "";

    return token;
  }
}

class MyAppWeb extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModelWeb>(
            create: (context) => UserModelWeb()),
        ChangeNotifierProvider<ProductModelWeb>(
            create: (context) => ProductModelWeb()),
        ChangeNotifierProvider<MarksUserModelWeb>(
            create: (context) => MarksUserModelWeb()),
        ChangeNotifierProvider<MarksProductModelWeb>(
            create: (context) => MarksProductModelWeb()),
        ChangeNotifierProvider<BuyingModelWeb>(
            create: (context) => BuyingModelWeb()),
        ChangeNotifierProvider<SavedAdsModelWeb>(
            create: (context) => SavedAdsModelWeb()),
        ChangeNotifierProvider<NotificationsModel>(
            create: (context) => NotificationsModel()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kotarica',
        home: FutureBuilder(
          future: tokenOrEmpty, // provera tokena
          builder: (context, snapshot) {
          //  return WelcomeWeb();
            if (snapshot.data != null) {
              var str = snapshot.data;
              var token = str.split(".");

              if (token.length != 3) {
                //print(DateTime.now());
                return WelcomeWeb();
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(token[1]))));
                print(
                    DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000));

                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                    .isAfter(DateTime.now())) {
                  //print(DateTime.now());
                  for (dynamic model in getModelsListWeb(context)) {
                    //getModelsListWeb
                    model.setPrivateKey();
                  }
                  return HomeScreenWeb(); // idi na home page
                } else
                  return WelcomeWeb(); //welcome
              }
            } else
              return WelcomeWeb();
          },
        ),
      ),
    );
  }

  Future<String> get tokenOrEmpty async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print(DateTime.now());
    var token = prefs.getString("token");
    if (token == null) return "";

    return token;
  }
}
