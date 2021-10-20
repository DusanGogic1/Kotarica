import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kotarica/constants/navigation_drawer/maindrawer.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/models/SavedAdsModel.dart';
import 'package:kotarica/user/UserInfo.dart';
import 'package:kotarica/web/WebModels/SavedAdsModelWeb.dart';
import 'package:kotarica/web/ads/SavedAds/savedAdsPagePrikaz.dart';
import 'package:kotarica/web/home/CalendarSpace/CalendarSpace.dart';
import 'package:kotarica/web/home/NavigationBar/NavigationBar.dart';
import 'package:provider/provider.dart';

import '../AddAdvertPageOneWeb.dart';
import 'image_data.dart';

/*STRANICA ZA SACUVANE OGLASE*/

class SavedAdsPageWeb extends StatelessWidget {
  final UserInfo userInfo;

  const SavedAdsPageWeb({Key key, this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var savedAdsModel = Provider.of<SavedAdsModelWeb>(context, listen: false);
    //savedAdsModel.getSavedAdsIds;
    return Scaffold(
      body:Container(
        //margin: EdgeInsets.only(right: size * 0.023, bottom: size * 0.02),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            NavigationBar(),
            SavedAdsPagePrikaz(),
            CalendarSpace(),
          ],
        ),
      ),
     // appBar: buildAppBar(context),
      // drawer: Drawer(
      //   child: NavigationBar(),
      // ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: size * 0.01, right: size * 0.01),
        height: size * 0.06,
        width: size * 0.06,
        child: FloatingActionButton(
          heroTag: "btttttn33",
          child: Icon(
            Icons.pending_actions,
            color: bela,
            size: size * 0.03,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddAdvertPageOneWeb()));
          },
          backgroundColor: crvenaGlavna,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      //bottomNavigationBar: buildBottomBar(context),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: zelena1,
      elevation: 0,
      actions: <Widget>[SizedBox(width: kDefaultPaddin / 2)],
    );
  }
}

//SVE DOLE FUNKCIJE MOGU DA SE KORISTE
//IMA OD INSTA, Pinteresta

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
    var size = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(left: size * 0.19),
      width: size * 0.75,
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 8,
        itemCount: imageList.length,
        itemBuilder: (context, index) => ImageCard(
          imageData: imageList[index],
        ),
        staggeredTileBuilder: (index) => StaggeredTile.count(1, 1),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
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
