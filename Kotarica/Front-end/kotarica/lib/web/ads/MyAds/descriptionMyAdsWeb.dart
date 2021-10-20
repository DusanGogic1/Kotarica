import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kotarica/ads/MyAds/MojiProizvodi.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/marks/OwnerAdsMarks.dart';
import 'package:kotarica/marks/ProductMarks.dart';
import 'package:kotarica/models/MarksProductModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/user/User.dart';
import 'package:kotarica/web/WebModels/MarksProductModelWeb.dart';
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//final _ratingController = TextEditingController();
//double _userRating = 4.5;
double _iconRating = 0;

//Koristi se za opis koji se nalazi u oglasu

class DescriptionMyAdsWeb extends StatefulWidget {
  const DescriptionMyAdsWeb({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<DescriptionMyAdsWeb> {
  String ime;

  String Ucitanoime;

  Future<String> _loadData(String dataNeeded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = prefs.getString(dataNeeded);
    return data;
  }

  Future<void> _GetUsername() async {
    String username;
    username = await _loadData("username");
    setState(() => ime = username);
  }

  void initState() {
    super.initState();
    _GetUsername();
  }

  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModelWeb>(context, listen: false);
    var marksProductModel =
    Provider.of<MarksProductModelWeb>(context, listen: false);

    User korisnik;
    String grad;

    var size = MediaQuery.of(context).size.width;
    return Column(
      children: [
        //padding
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                widget.product.category +
                    ">" +
                    widget.product.subcategory,
                style: TextStyle(color: crvenaGlavna, fontSize: 13)),
          ],
        ),
        SizedBox(height: size*0.009,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
                future: marksProductModel.getMean(widget.product.id),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    if(snapshot.data != -1)
                      return Text(
                        snapshot.data.toString(),
                        style: TextStyle(fontSize: 20, color: Tema.dark ? bela : crnaGlavna,  //DONJI DEO
                        ),
                      );
                    else return SizedBox();
                  }
                  else return CircularProgressIndicator();
                }
            ),
            Row(
              children: [
                FutureBuilder(
                    future: marksProductModel.getMean(widget.product.id),
                    builder: (context, snapshot) {
                      if(snapshot.data != null) {
                        if(snapshot.data != -1)
                          return RatingBar.builder(
                              unratedColor: Tema.dark ? bela : siva2,  //DONJI DEO,
                              itemSize: size*0.08,
                              initialRating: snapshot.data,
                              minRating: snapshot.data,
                              maxRating: snapshot.data,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              )
                          );
                        else return Text("Proizvod trenutno nema ocena");
                      } else
                        return CircularProgressIndicator();
                    }),
                SizedBox(width: 5),
                FutureBuilder(
                    future: marksProductModel.getMean(widget.product.id),
                    builder: (context, snapshot) {
                      if(snapshot.data != null) {
                        if(snapshot.data != -1)
                          return FlatButton(
                            height: 30,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            color: zelena1,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductMarks(id: widget.product.id)));
                            },
                            child: Text(
                              "ocene ".toUpperCase(),
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Tema.dark ? crnaGlavna : bela, //DONJI DEO
                              ),
                            ),
                          );
                        else return SizedBox();
                      } else
                        return CircularProgressIndicator();
                    }),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: size * 0.01),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container() /*ExpansionTile(
                      childrenPadding: EdgeInsets.all(10),
                      backgroundColor: (widget.product.color),
                      collapsedBackgroundColor: lighten(widget.product.color),
                      title: Text("Opis oglasa",
                          style: TextStyle(color: bela, fontSize: 16)),
                      children: [
                        Text(
                          widget.product.about,
                          style: TextStyle(height: 1.5, color: bela),
                        ),
                      ],
                    ),*/
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: size * 0.01),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: ExpansionTile(
                    childrenPadding: EdgeInsets.all(10),
                    backgroundColor: Tema.dark? darken(widget.product.color,.3):(widget.product.color),
                    collapsedBackgroundColor:Tema.dark?darken(widget.product.color,.3): lighten(widget.product.color),
                    title: Text("Opis oglasa",
                        style: TextStyle( color: Tema.dark ? bela : bela, fontSize: 16)),
                    children: [
                      Text(
                        widget.product.about,
                        style: TextStyle(height: 1.5, color: bela),
                      ),
                    ]),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
