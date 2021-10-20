import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/method.dart';
import 'package:kotarica/constants/style.dart';

class Ocena {
  final String ime ;
  final String odgovor1 ;
  final String odgovor2 ;
  final String odgovor3 ;
  final bool like ;
  // final maxWidth;
  // final maxHeight;

  Ocena({
    this.ime,
    this.odgovor1,
    this.odgovor2,
    this.odgovor3,
    this.like,
    // this.maxHeight,
    // this.maxWidth
  });
  final StyleZaBoxKomentarPozitivan = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: svetloZelena, //Color.fromRGBO(149, 181, 178,1),
  );


   static ocena(String ime, String message1, String message2, String message3, bool like) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: dajBoju(like), //Color.fromRGBO(149, 181, 178,1),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //prvi red u kontejneru
          Row(
            children: [
               Container(child: dajIkonu(like)),
              //   CupertinoIcons.hand_thumbsup_fill,
              //   size: 25,
              //   color: Colors.green[500],
             //  ),
              SizedBox(
                width: 10,
              ),
              Text(
                ime,
                style: TextStyle(
                  fontFamily: "Monserrat",
                  fontWeight: FontWeight.bold,
                  color: plavaTekst,
                  fontSize: 18.0,
                ),
              )
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          //KOMUNIKACIJA
          Row(
            children: [
              Text(
                "Opis iz oglasa tačan: ",
                style: TextStyle(
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Text(
                message1,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    fontFamily: "Ubuntu"),
              ),
            ],
          ),
          //KOMUNIKACIJA
          Row(
            children: [
              Text(
                "Komunikacija protekla dobro: ",
                style: TextStyle(
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Text(
                message2,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    fontFamily: "Ubuntu"),
              ),
            ],
          ),
          //KOMUNIKACIJA
          Row(
            children: [
              Text(
                "Ispoštovan dogovor: ",
                style: TextStyle(
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Text(
                message3,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    fontFamily: "Ubuntu"),
              ),
            ],
          ),

        ],
      ),
    );

  }




}
