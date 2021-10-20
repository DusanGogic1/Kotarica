import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/util/helper_functions.dart';

//Pocetni deo oglasa

//OVDE SE DODAJU SLIKE KOJE SE PRIKAZUJU


Future<ImageProvider> _loadImage(String thumbnail) async {
  String image = await ipfsImage(thumbnail);
  return Image.memory(base64Decode(image)).image;
}

final List<String> imageList = [
  //  var br = widget.product.images.length;
  "images/sir.jpg",
  "images/sir2.png",
  "images/welcome.png"
];

class ProductTitleWithImageWeb extends StatefulWidget {
  const ProductTitleWithImageWeb({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProductTitleWithImageState createState() => _ProductTitleWithImageState();
}

class _ProductTitleWithImageState extends State<ProductTitleWithImageWeb> {


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
      padding: EdgeInsets.symmetric(horizontal: size * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Padding(
              padding:  EdgeInsets.only(top:5),
              child: Text(
                  widget.product.title,
                  style: TextStyle(
                      color:Colors.white,
                      fontWeight:FontWeight.bold,
                      fontSize: 24,
                      fontFamily: "Montserrat"
                  )
              ),
            ),
          ),
       //   SizedBox(height: 5,),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: size * 0.05),
                child: RichText(
                  //DEO SA CENOM
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Cena - rsd\n", style: TextStyle(color: Colors.white, fontSize: 16,fontFamily: "OpenSansItalic")),
                      TextSpan(
                        text: "${widget.product.priceRsd} din\n",
                        style:  TextStyle(
                          color:Colors.white,
                          fontWeight:FontWeight.bold,
                          fontSize: 20,
                          fontFamily: "Ubuntu"
                      ),
                      ),
                      TextSpan(text: "Cena - eth\n", style: TextStyle(color: Colors.white, fontSize: 16,fontFamily: "OpenSansItalic")),
                      TextSpan(
                        text: "${widget.product.priceEth}".isEmpty?'/':'${widget.product.priceEth} eth\n',
                        style:  TextStyle(
                            color:Colors.white,
                            fontWeight:FontWeight.bold,
                            fontSize: 20,
                            fontFamily: "Ubuntu"
                        ),
                      ),

                      //DATUM
                      TextSpan(text: "Datum objave:\n", style:  TextStyle(color: Colors.white, fontSize: 16,fontFamily: "OpenSansItalic")),
                      TextSpan(
                        //DATUM MORA OVAKO
                        text: "${widget.product.date.day}/${widget.product.date.month}/${widget.product.date.year}"  ,
                        style:  TextStyle(
                            color:Colors.white,
                            fontWeight:FontWeight.bold,
                            fontSize: 20,
                            fontFamily: "Ubuntu"
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: kDefaultPaddin),
              // Container(
              //   child: Expanded(
              //     child: Hero(
              //       tag: "${widget.product.id}",
              //       child: Container(
              //         child: ClipRRect(//---=> za radius slike
              //           borderRadius: BorderRadius.circular(20.0),
              //           /*KORISTI SE ZA SCROLL SLIKA*/
              //           child: GFCarousel(
              //             height: size * 0.5,
              //             items: imageList.map(
              //                   (url) {
              //                 return Container(
              //                    margin: EdgeInsets.all(size * 0.009),
              //                   child: ClipRRect(
              //                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
              //                     child: FutureBuilder(
              //                     future: _loadImage(widget.product.images[0]),
              //                     builder: (context, snapshot) {
              //                       if (snapshot.data != null) {
              //                         return Image(image: snapshot.data);
              //                       } else
              //                         return CircularProgressIndicator();
              //                     }),
              //                     //Image.asset(
              //                     //     url,
              //                     //     fit: BoxFit.cover,
              //                     //   width: size * 1.0,
              //                     // ),
              //                   ),
              //                 );
              //               },
              //             ).toList(),
              //             onPageChanged: (index) {
              //               setState(() {
              //                 _current = index;
              //               });
              //             },
              //           )
              //         )
              //       ),
              //     ),
              //   ),
              // ),


            ],
          ),
          // Container(
          //   margin:EdgeInsets.only(left:size*0.59),
          //   child: Row(
          //     children: map<Widget>(imageList, (index, url) {
          //       return Container(
          //         width: 7.0,
          //         height: 7.0,
          //         margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
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
}



/*
Image.asset(
product.image,
width: 190,
height: 190,
fit: BoxFit.fill,
),*/