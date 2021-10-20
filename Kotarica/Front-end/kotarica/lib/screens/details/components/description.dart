import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kotarica/ad_rating/rating.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/marks/ProductMarks.dart';
import 'package:kotarica/marks/OwnerAdsMarks.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/user/User.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/style.dart';
import '../../../models/MarksProductModel.dart';

//final _ratingController = TextEditingController();
//double _userRating = 4.5;
double _iconRating = 0;

//Koristi se za opis koji se nalazi u oglasu

class Description extends StatefulWidget {
  const Description({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
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

  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context, listen: false);
    var marksProductModel = Provider.of<MarksProductModel>(context, listen: false);
    //print(marksProductModel.privateKey);
    var size = MediaQuery.of(context).size.width;
    return Column(
      children: [
        //padding
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.product.category+">"+ widget.product.subcategory,
            style:TextStyle(color:crvenaGlavna,
            fontSize: 13)),
          ],
        ),
        SizedBox(height: size*0.09,),
    widget.product.type == "Nudim"?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
                future: marksProductModel.getMean(widget.product.id),
                builder: (context, snapshot) {
                  if(snapshot.data != null) {
                    if(snapshot.data != -1)
                      return Text(
                        snapshot.data.toStringAsFixed(2),
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
                }
                    else return CircularProgressIndicator();
              }
            )
              ],
            ),
            SizedBox(width: 5),
          ],
        ):Container(),
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
                        style: TextStyle( color: Tema.dark ? Colors.grey[100] : bela, fontSize: 16)),
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

              SizedBox(
                height: 5,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: ExpansionTile(
                    childrenPadding: EdgeInsets.all(10),
                    backgroundColor: Tema.dark? darken(widget.product.color,.3):(widget.product.color),
                    collapsedBackgroundColor: Tema.dark? darken(widget.product.color,.3): lighten(widget.product.color),
                    title: Text("Informacije o prodavcu",
                        style: TextStyle( color: Tema.dark ? Colors.grey[100] : bela, fontSize: 16)),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.profile_circled,
                              color: Tema.dark ? bela : bela
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          FutureBuilder(
                            future: userModel.GetFullNameOwner(
                                widget.product.ownerUsername),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                Ucitanoime = snapshot.data;
                                return Text(
                                  snapshot.data,
                                  style: (TextStyle(height: 1.5,  color: Tema.dark ? Colors.grey[100] : bela)),
                                );
                              } else
                                return Text("Nema");
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.location,
                            color: Tema.dark ? bela : bela,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          FutureBuilder(
                            future: userModel.GetCityOwner(
                                widget.product.ownerUsername),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Text(
                                  snapshot.data,
                                  style: (TextStyle(height: 1.5,  color: Tema.dark ? Colors.grey[100] : bela)),
                                );
                              } else
                                return Text("Nema");
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.phone,
                            color: Tema.dark ? Colors.grey[100] : bela,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          FutureBuilder(
                            future: userModel.GetNumberOwner(
                                widget.product.ownerUsername),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Text(
                                  snapshot.data,
                                  style: (TextStyle(height: 1.5,  color: Tema.dark ? Colors.grey[100] : bela)),
                                );
                              } else
                                return Text("Nema");
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      FlatButton(
                        height: 30,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        color:  Tema.dark ? siva : svetlaBoja,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OwnerAdsMarks(
                                      userId: widget.product.ownerId,
                                      username: widget.product.ownerUsername,
                                      productId: widget.product.id
                                  ) //(username:  widget.product.ownerUsername),
                                  ));
                          // ProductMarks
                        },
                        child: Text(
                          "Pogledaj profil prodavca".toUpperCase(),
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Tema.dark?darken(widget.product.color,.1):widget.product.color,
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
