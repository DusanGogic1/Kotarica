import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:kotarica/cart/cart_screen.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/components/savedItemCard.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/WebModels/SavedAdsModelWeb.dart';
import 'package:kotarica/web/ads/MyAds/DetailsScreenMyAdsWeb.dart';
import 'package:kotarica/web/ads/MyAds/item_cardMyAdsWeb.dart';
import 'package:kotarica/web/home/components/savedItemCardWeb.dart';
import 'package:kotarica/web/home/screens/details/details_screenWeb.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*STRANICA ZA SACUVANE OGLASE*/

class SavedAdsPagePrikaz extends StatefulWidget {
  _State createState() => _State();
}

class _State extends State<SavedAdsPagePrikaz>{
  // String _username;
  int _id;

  Future<String> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance();

    return prefs.getString("username");
  }

  Future<int> _loadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt("id");
  }

  @override
  Widget build(BuildContext context) {
    var productModel = Provider.of<ProductModelWeb>(context);
    var savedAdsModel = Provider.of<SavedAdsModelWeb>(context);
    var size = MediaQuery.of(context).size.width;

    return Positioned(

      left: MediaQuery.of(context).size.width*0.14,
      child: Container(
     //   appBar: buildAppBar(context),
    color: Tema.dark?darkPozadina:bela,
        child: productModel.getProductsReady() && savedAdsModel.getSavedProductsReady()
            ? Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.68,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
              Expanded(
                child: Padding(
                 // padding: EdgeInsets.symmetric(horizontal: size * 0.04),
                  padding: EdgeInsets.only(top: size * 0.04),
                  // GRID ZA PRIKAZ PO 2 OGLASA JEDAN PORED DRUGOG
                  child: GridView.builder(
                    itemCount: savedAdsModel.productsToShowCount,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, //BROJ ELEMENATA U VRSTI
                      mainAxisSpacing: size * 0.03,
                      crossAxisSpacing: size * 0.03,
                    ),
                    itemBuilder: (context, index) => SavedItemCardWeb (
                        product: savedAdsModel.productsToShow[index],
                        press: () async {
                          // _username = await _loadUsername();
                          _id = await _loadId();

                          if(_id != savedAdsModel.productsToShow[index].ownerId){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreenWeb(
                                    product:
                                    savedAdsModel.productsToShow[index],
                                  ),
                                ));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreenMyAdsWeb(
                                    product:
                                    savedAdsModel.productsToShow[index],
                                  ),
                                ));
                          }
                        }),
                  ),
                ),
              ),
          ],
        ),
            )
            : Center(
          child: CircularProgressIndicator(),
        ),

    ));
  }

  AppBar buildAppBar(context) {
    return AppBar(
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Lista želja", style: Theme.of(context).textTheme.headline4.copyWith(
                color: belaGlavna, fontWeight: FontWeight.bold, fontSize: 25)),
          ],
        ),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      foregroundColor: bela,
      backgroundColor:Tema.dark?zelenaDark: zelena1,
      elevation: 0,
      actions: <Widget>[
        /* IconButton(
          icon: Image.asset(
            "images/icons/search.png",
            color: Tema.dark ? bela : bela,
          ),
          onPressed: () {
            showSearch(
                context: context,
                delegate: DataSearch(
                    Provider.of<ProductModel>(context, listen: false)
                        .productsToShow));
          },
        ),*/
        IconButton(
          icon: Icon(Icons.shopping_cart_outlined, color: Tema.dark ? bela : bela),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CartScreen()));
          },
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}

// SVE DOLE FUNKCIJE MOGU DA SE KORISTE
// IMA OD INSTA, Pinteresta
/*
class StandardGrid extends StatelessWidget {
  const StandardGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: imageList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) => ImageCard(
        imageData: imageList[index],
      ),
    );
  }
}


class StandardStaggeredGrid extends StatelessWidget {
  const StandardStaggeredGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 3,
      itemCount: imageList.length,
      itemBuilder: (context, index) => ImageCard(
        imageData: imageList[index],
      ),
      staggeredTileBuilder: (index) => StaggeredTile.count(1, 1),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    );
  }
}

class InstagramSearchGrid extends StatelessWidget {
  const InstagramSearchGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 3,
      itemCount: imageList.length,
      itemBuilder: (context, index) => ImageCard(
        imageData: imageList[index],
      ),
      staggeredTileBuilder: (index) => StaggeredTile.count(
          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    );
  }
}

class PinterestGrid extends StatelessWidget {
  const PinterestGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: imageList.length,
      itemBuilder: (context, index) => ImageCard(
        imageData: imageList[index],
      ),
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    );
  }
}

//Za sliku
class ImageCard extends StatelessWidget {
  const ImageCard({this.imageData});

  final ImageData imageData;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.network(imageData.imageUrl, fit: BoxFit.cover),
    );
  }
}
*/