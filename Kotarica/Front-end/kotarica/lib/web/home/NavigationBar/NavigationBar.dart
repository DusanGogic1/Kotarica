import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:kotarica/web/home/NavigationBar/src/CompanyName.dart';
import 'package:kotarica/web/home/NavigationBar/src/NavBar.dart';
import 'package:kotarica/web/home/NavigationBar/src/NavBarItem.dart';
import 'package:kotarica/web/registration/Welcome.dart';
import 'package:provider/provider.dart';

import '../../../constants/style.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    UserModelWeb userModel = Provider.of<UserModelWeb>(context, listen: false);
    return Align(
      heightFactor: 10,
      widthFactor: 10,
      alignment: Alignment.centerLeft,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.13,
        color: Tema.dark?zelenaDark:zelena1,
        child: Stack(
          children: [
            CompanyName(),
            Align(
              alignment: Alignment.center,
              child: NavBar(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: NavBarItem(
                name: "Odjavi se",
                icon: Feather.log_out,
                active: false,
                touched: () async {
                  bool success = await userModel.logout();
                  if (success) {
                    //productModel = null;
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => WelcomeWeb()),
                        (Route<dynamic> route) => false);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
