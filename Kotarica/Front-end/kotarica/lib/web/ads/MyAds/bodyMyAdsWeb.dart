import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/home/components/itemCard.dart';
import 'package:provider/provider.dart';
import 'DeleteChangeWeb.dart';
import 'DetailsScreenMyAdsWeb.dart';
import 'ProductTitleImageMyAdsWeb.dart';
import 'colorSizeMyAdsWeb.dart';
import 'descriptionMyAdsWeb.dart';
import 'itemCardListMyAdsWeb.dart';
import 'item_cardMyAdsWeb.dart';
import 'mainViewWeb.dart';


class BodyMyAdsWeb extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<BodyMyAdsWeb> {

  Future<void> prikaziMojOglas(int index) async {
    var productModel = Provider.of<ProductModelWeb>(context, listen: false);

    //print("DDD");
    var size = MediaQuery.of(context).size;
    var product = productModel.productsToShow[index];
    bool val = Tema.dark;
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            //color: Tema.dark?darkPozadina:bela,
              child: AlertDialog(
                backgroundColor: Tema.dark? darkPozadina:bela,
                insetPadding: EdgeInsets.all(40),
                content: Container(
                  width: 900,
                  height: size.height,
                  color: Tema.dark?darken(product.color,.3):product.color,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: size.height*0.8,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    top: size.height * 0.32,
                                    left: size.height * 0.02,
                                    right: size.height * 0.02),
                                padding: EdgeInsets.only(
                                  top: size.height * 0.02,
                                  left: kDefaultPaddin,
                                  right: kDefaultPaddin,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                  Tema.dark ? darkPozadina : bela, //DONJI DEO
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      topRight: Radius.circular(24),
                                      //opciono
                                      bottomLeft: Radius.circular(24),
                                      bottomRight: Radius.circular(24)),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    ColorAndSizeMyAdsWeb(product: product),
                                    SizedBox(height: kDefaultPaddin / 2),
                                    DescriptionMyAdsWeb(product: product),
                                    SizedBox(height: kDefaultPaddin / 2),
                                    DeleteChangeWeb(product: product),
                                  ],
                                ),
                              ),
                              ProductTitleWithImageMyAdsWeb(product: product),
                              Container(
                                color: Tema.dark?darken(product.color,.3):product.color,
                                margin:EdgeInsets.only(top:5,left:5),
                                child:  FlatButton(
                                  height: 20,
                                  minWidth: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(130)),
                                  color: Tema.dark?darkPozadina:bela,
                                  onPressed: () {
                                    Navigator.of(context).pop();

                                  },
                                  child:
                                  Icon(Icons.arrow_back,color:Tema.dark? product.color: product.color,size: 40,),
                                ),
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var productModel = Provider.of<ProductModelWeb>(context, listen: false);

    var products = productModel.getMyAds();
    return Positioned(

      left: MediaQuery.of(context).size.width*0.14,
      child: Container(
        color: Tema.dark?darkPozadina:bela,
        //appBar: buildAppBar(context),
        child: productModel.getTotalCountReady() && productModel.getProductsReady()
            ? Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.68,
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Padding(
                  //padding: EdgeInsets.symmetric(horizontal: size * 0.04),
                  padding: EdgeInsets.symmetric(horizontal: size * 0.06),
                  //GRID ZA PRIKAZ PO 2 OGLASA JEDAN PORED DRUGOG
                  child: GridView.builder(
                    itemCount: productModel.MyproductsCount,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, //BROJ ELEMENATA U VRSTI
                      mainAxisSpacing: size * 0.03,
                      crossAxisSpacing: size * 0.03,
                    ),
                    //package:kotarica/web/home/components/itemCard.dart
                    itemBuilder: (context, index) => ItemCard(
                      product: productModel.Myproducts[index],
                      press: () => prikaziMojOglas(index)
                    ),
                  ),
                ),
              ),
          ],
        ),
            )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      title: Text(
        "Moji oglasi",
        style: TextStyle(color: belaGlavna, fontFamily: "Montserrat"),
      ),
      foregroundColor: bela,
      backgroundColor: zelena1,
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Image.asset(
            "images/icons/search.png",
            color: bela,
          ),
          onPressed: () {
            showSearch(context: context, delegate: DataSearch(Provider.of<ProductModelWeb>(context, listen: false).Myproducts));
          },
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
