import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';

//Pocetni deo oglasa

Future<ImageProvider> _loadImage(String thumbnail) async {
  String image = await ipfsImage(thumbnail);
  return Image.memory(base64Decode(image)).image;
}

//OVDE SE DODAJU SLIKE KOJE SE PRIKAZUJU

final List<String> imageList = [
  "images/sir.jpg",
  "images/sir2.png",
  "images/welcome.png"
];

class ProductTitleWithImageMyAdsWeb extends StatefulWidget {
  const ProductTitleWithImageMyAdsWeb({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProductTitleWithImageState createState() => _ProductTitleWithImageState();
}

class _ProductTitleWithImageState extends State<ProductTitleWithImageMyAdsWeb> {
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
    var size = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(widget.product.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: "Montserrat")),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(" (" + widget.product.type + ")",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: "Montserrat")),
            ),
          ),

          SizedBox(height: 5),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: size * 0.0214),
                child: RichText(
                  //DEO SA CENOM
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Cena - rsd\n",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "OpenSansItalic")),
                      TextSpan(
                        text:
                            "${widget.product.priceRsd} din / ${widget.product.measuringUnit}\n",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: "Ubuntu"),
                      ),
                      TextSpan(
                          text: "Cena - eth\n",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "OpenSansItalic")),
                      TextSpan(
                        text: "${widget.product.priceEth}".isEmpty
                            ? '/'
                            : '${widget.product.priceEth} eth / ${widget.product.measuringUnit}\n',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: "Ubuntu"),
                      ),

                      //DATUM
                      TextSpan(
                          text: "Datum objave:\n",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "OpenSansItalic")),
                      TextSpan(
                        //DATUM MORA OVAKO
                        text:
                            "${widget.product.date.day}/${widget.product.date.month}/${widget.product.date.year}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: "Ubuntu"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 5),
              Container(
                child: Expanded(
                  child: Hero(
                    tag: "${widget.product.id}",
                    child: Container(
                        child: ClipRRect(
                      //---=> za radius slike
                      borderRadius: BorderRadius.circular(70.0),
                      /*KORISTI SE ZA SCROLL SLIKA*/
                      child: GestureDetector(
                        onTap: () {
                          // print("Container clicked");
                          _popUpGalerija();
                        },
                        child: Column(
                          children: [
                            GFCarousel(
                              height: size * 0.08,
                              items: widget.product.images.map(
                                (url) {
                                  return Container(
                                    margin: EdgeInsets.all(size * 0.009),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      child: FutureBuilder(
                                          future: _loadImage(url),
                                          builder: (context, snapshot) {
                                            if (snapshot.data != null) {
                                              return Image(
                                                  image: snapshot.data);
                                            } else
                                              return CircularProgressIndicator();
                                          }),
                                    ),
                                  );
                                },
                              ).toList(),
                              onPageChanged: (index) {
                                setState(() {
                                  _current = index;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: map<Widget>(widget.product.images,
                                  (index, url) {
                                return Container(
                                  width: 7.0,
                                  height: 7.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _current == index
                                        ? Colors.redAccent
                                        : Colors.green,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: size * 0.35),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: map<Widget>(widget.product.images, (index, url) {
          //       return Container(
          //         width: 10.0,
          //         height: 10.0,
          //         margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: _current == index ? Colors.redAccent : Colors.green,
          //         ),
          //       );
          //     }),
          //   ),
          // ),
        ],
      ),
    );
  }

  //Funkcija za alert -- brisanje naloga
  Future<void> _popUpGalerija() async {
    var size = MediaQuery.of(context).size.width;
    var size2 = MediaQuery.of(context).size.height;

    return showDialog<void>(
      context: context,

      //barrierDismissible: false,
      builder: (BuildContext context) {
        //
        // return AlertDialog(
        //   title: Text(
        //     'Galerija slika',
        //     style: TextStyle(
        //       color: zelena1,
        //       fontFamily: "Montserrat",
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        return Center(
          child: GFCarousel(
            items: widget.product.images.map(
              (url) {
                return Center(
                  child: FullScreenWidget(
                    child: FutureBuilder(
                        future: _loadImage(url),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return Image(image: snapshot.data);
                          } else
                            return CircularProgressIndicator();
                        }),
                  ),
                );
              },
            ).toList(),
          ),
        );
        //  );
        // return AlertDialog(
        //   title: Text(
        //     'Galerija slika',
        //     style: TextStyle(
        //       color: zelena1,
        //       fontFamily: "Montserrat",
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        //   content: Container(
        //     height:  size2*0.5,
        //     child: GFCarousel(
        //       height: size2 * 1.9,
        //       items: widget.product.images.map(
        //             (url) {
        //           return FutureBuilder(
        //               future: _loadImage(url),
        //               builder: (context, snapshot) {
        //                 if (snapshot.data != null){
        //                   return Image(image: snapshot.data, );
        //                 } else
        //                   return CircularProgressIndicator();
        //               });
        //         },
        //       ).toList(),
        //        //onPageChanged: (index) {
        //       //   setState(() {
        //       //     _current = index;
        //       //   });
        //       // },
        //     ),
        //   ),
        //   actions: <Widget>[
        //     ElevatedButton(
        //       style: ElevatedButton.styleFrom(
        //         primary: zelena1,
        //         onPrimary: Colors.white,
        //       ),
        //       child: Text(
        //         'Vrati se nazad ',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontFamily: "Montserrat",
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //     ),
        //   ],
        // );
      },
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image(
              image: product.images[0],
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
