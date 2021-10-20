import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:provider/provider.dart';

import 'DetailsScreenMyAds.dart';
import 'itemCardListMyAds.dart';
import 'item_cardMyAds.dart';
import 'mainView.dart';

//za vrednosti u radioButtonu
enum Currency { RSD, Ether }
Currency _character = Currency.RSD;

class BodyMyAds extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<BodyMyAds> {
  Brightness getBrightness() {
    return Tema.dark ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var productModel = Provider.of<ProductModel>(context, listen: false);

    var products = productModel.getMyAds();

    return Theme(
        data: ThemeData(
          brightness: getBrightness(),
        ),
        child: Scaffold(
          backgroundColor: Tema.dark ? darkPozadina : Colors.grey.shade200,
          appBar: buildAppBar(context),
          body: productModel.getTotalCountReady() &&
                  productModel.getProductsReady()
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPaddin),
                      child: /*------DROPDOWN KATEGORIJA------*/
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size * 0.04),
                        //GRID ZA PRIKAZ PO 2 OGLASA JEDAN PORED DRUGOG
                        child: GridView.builder(
                          itemCount: productModel.MyproductsCount,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, //BROJ ELEMENATA U VRSTI
                            mainAxisSpacing: size * 0.03,
                            crossAxisSpacing: size * 0.03,
                          ),
                          itemBuilder: (context, index) => ItemCardMyAds(
                            product: productModel.Myproducts[index],
                            press: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreenMyAds(
                                  product: productModel.Myproducts[index],
                                ),
                              ),
                            ),
                          ),
                        ),
                        /*
              PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: productModel.MyproductsCount,
                itemBuilder: (context, index) => ItemCardListMyAds(
                  productModel.Myproducts,
                  productModel.MyproductsCount,
                  size,
                ),
                onPageChanged: (context) {
                  print("changed");
                },
              ),*/
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }

  AppBar buildAppBar(context) {
    return AppBar(
      title: Text(
        "Moji oglasi",
        style: TextStyle(
            color: Tema.dark ? bela : bela, fontFamily: "Montserrat"),
      ),
      foregroundColor:  Tema.dark ? bela : siva2,
      backgroundColor: Tema.dark ? zelenaDark : zelena1,
      elevation: 0,
      actions: <Widget>[
        /*IconButton(
          icon: Image.asset(
            "images/icons/search.png",
            color:  Tema.dark ? bela : siva2,
          ),
          onPressed: () {
            showSearch(
                context: context,
                delegate: DataSearch(
                    Provider.of<ProductModel>(context, listen: false)
                        .Myproducts));
          },
        ),*/
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
