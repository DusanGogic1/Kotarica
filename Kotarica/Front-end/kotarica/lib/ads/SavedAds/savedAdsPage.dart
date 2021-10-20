import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/ads/MyAds/DetailsScreenMyAds.dart';

import 'package:kotarica/cart/cart_screen.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/home/components/itemCard.dart';
import 'package:kotarica/home/components/savedItemCard.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/models/SavedAdsModel.dart';
import 'package:kotarica/screens/details/details_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/navigation_drawer/maindrawer.dart';
import '../AddAdvertPageOne.dart';

/*STRANICA ZA SACUVANE OGLASE*/

class SavedAdsPage extends StatefulWidget {
  _State createState() => _State();
}

class _State extends State<SavedAdsPage>{
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
    var productModel = Provider.of<ProductModel>(context);
    var savedAdsModel = Provider.of<SavedAdsModel>(context);
    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Tema.dark ? darkPozadina : bela,
      appBar: buildAppBar(context),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        child: Icon(
          Icons.pending_actions,
          color: bela,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddAdvertPageOne()));
        },
        backgroundColor: Color.fromRGBO(202, 59, 50, 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: buildBottomBar(context),
      body: productModel.getProductsReady() && savedAdsModel.getSavedProductsReady()
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size * 0.04),
              // GRID ZA PRIKAZ PO 2 OGLASA JEDAN PORED DRUGOG
              child: GridView.builder(
                itemCount: savedAdsModel.productsToShowCount,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //BROJ ELEMENATA U VRSTI
                  mainAxisSpacing: size * 0.03,
                  crossAxisSpacing: size * 0.03,
                ),
                itemBuilder: (context, index) => SavedItemCard(
                    product: savedAdsModel.productsToShow[index],
                    press: () async {
                      // _username = await _loadUsername();
                      _id = await _loadId();

                      if(_id != savedAdsModel.productsToShow[index].ownerId){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                product:
                                savedAdsModel.productsToShow[index],
                              ),
                            ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreenMyAds(
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
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  AppBar buildAppBar(context) {
    var productModel = Provider.of<ProductModel>(context);
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
        IconButton(
          icon: Badge(
            shape: BadgeShape.circle,
            badgeColor: Colors.white,
            badgeContent: Text(
              productModel.getCartLength().toString(),
              style: TextStyle(fontSize: 11, color: zelena1),
            ),
            position: BadgePosition.topEnd(top: -15, end: -15),
            animationType: BadgeAnimationType.scale,
            child: Icon(Icons.shopping_cart_outlined,
                color: Tema.dark ? bela : bela),
          ),
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