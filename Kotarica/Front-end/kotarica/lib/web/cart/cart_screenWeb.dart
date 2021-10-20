import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/home/HomeScreen.dart';
import '../home/HomeScreen.dart';
import 'components/body.dart';
import 'components/check_out_card.dart';
import 'package:kotarica/web/home/NavigationBar/src/NavBar.dart';
import 'package:kotarica/web/WebModels/BuyingModelWeb.dart';
import 'package:provider/provider.dart';

class CartScreenWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var buyingModel = Provider.of<BuyingModelWeb>(context, listen :false);
    return Scaffold(
      backgroundColor: Tema.dark ? siva2 : bela,
      appBar: buildAppBar(context),
      body: Align(alignment:Alignment.centerRight,child: BodyWeb()),
      bottomNavigationBar: CheckoutCardWeb(),
    );
  }
  AppBar buildAppBar(BuildContext context) {
    var productModel = Provider.of<ProductModelWeb>(context);
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color:Tema.dark?svetloZelena: Colors.black),
        onPressed: () {
          selected[0] = true;
          selected[7] = false;
          selected[5] = false;
          selected[2] = false;//=> Navigator.of(context).pop(),
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomeScreenWeb()),
                  (route) => false);

        }),
      backgroundColor: Tema.dark ? siva2 : zelena1,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Vaša korpa",
            style: TextStyle( color: Tema.dark ? svetloZelena : belaGlavna),
          ),
          //--BROJ U KORPI--
          Text(
            ProductModelWeb.cart.length == 1 ? "${ProductModelWeb.cart.length} proizvod" : "${ProductModelWeb.cart.length} proizvoda",
            style:TextStyle( color: Tema.dark ? svetloZelena :svetloZelena, fontSize: 12),
          ),
        ],
      ),
    );
  }
}