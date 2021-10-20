import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/ad_rating/rating.dart';
import 'package:kotarica/ads/ChangeMyAds/ChangeMyAdsPageOne.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/home/components/body.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:kotarica/web/WebModels/BuyingModelWeb.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:kotarica/web/ads/ChangeMyAds/ChangeMyAdsPageOne.dart';
import 'package:kotarica/web/home/HomeScreen.dart';
import 'package:provider/provider.dart';




class DeleteChangeWeb extends StatefulWidget {

  Product product;
  final void Function (Product) onProductUpdated;

  DeleteChangeWeb({
    Key key,
    @required this.product,
    this.onProductUpdated,
  }) : super(key: key);

  @override
  _DeleteChangeWebState createState() => _DeleteChangeWebState();
}

class _DeleteChangeWebState extends State<DeleteChangeWeb> {

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery
        .of(context)
        .size
        .width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Row(
        children: <Widget>[
          //--DUGME ZA CET--
          Container(
            margin: EdgeInsets.only(right: kDefaultPaddin),
            height: size * 0.04,
            width: size * 0.045,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Tema.dark? darken(widget.product.color,.3):(widget.product.color),
              ),
            ),
            child: IconButton(
              icon: Icon(CupertinoIcons.clear_thick),//Image.asset("images/icons/Trash.png"),
              //uzima boju oglasa na pocetnoj strani
              color:Tema.dark? darken(widget.product.color,.3):(widget.product.color),
              onPressed: () async {
                bool deleted = await _deletePost();
                if (deleted) {
                 // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreenWeb()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomeScreenWeb()));

                /*  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreenWeb()));*/
                }
              },
            ),
          ),
          //---DUGME KUPI---
          Expanded(
            child: SizedBox(
              height: 50,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color:Tema.dark?darken(widget.product.color,.3): widget.product.color,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>ChangeMyAdsPageOneWeb(product: widget.product , onProductUpdated: (product) {
                            setState(() {
                              widget.product = product;
                            });
                            widget.onProductUpdated?.call(product);
                          }) ));
                },
                child: Text(
                  "Izmeni oglas".toUpperCase(),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _deletePost() async {
    var productModel = Provider.of<ProductModelWeb>(context, listen: false);
    var buyingModel = Provider.of<BuyingModelWeb>(context, listen: false);
    var userModel = Provider.of<UserModelWeb>(context, listen: false);
    bool deleted = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Tema.dark?darkPozadina:bela,
          title: Text(
            'Brisanje oglasa',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Da li ste sigurni da želite da obrišete ovaj oglas?',
                style:TextStyle(color:Tema.dark?bela:crnaGlavna)),
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
                'Obriši ',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                showLoadingDialog(context);
                var addresses = await buyingModel.getUserInfo(widget.product.id);
                await productModel.deletePostedProduct(widget.product.id);

                for(var i = 0; i < addresses.length; i++)
                {
                  await buyingModel.transferAllToCancelled(widget.product.id);
                  var username = await userModel.GetOwnerUsername(addresses[i][0].toInt());
                  var etherAddress = await userModel.GetOwnerInfo(username);
                  if(addresses[i][7] == "ETH")
                    await buyingModel.sendEther2(addresses[i][3].toInt(), widget.product.priceEth, etherAddress);
                }
                deleted = true;

                //Navigator.of(context, rootNavigator: true).pop();
              //  await showInformationAlert(context, "Brisanje oglasa je uspešno.");
                await showInformationAlertWeb(context, "Brisanje oglasa je uspešno.");
               // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreenWeb()));
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomeScreenWeb()));
              /*  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreenWeb()));*/
             //   Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: zelena1,
                onPrimary: Colors.white,
              ),
              child: Text(
                'Odustani ',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return deleted;
  }
}