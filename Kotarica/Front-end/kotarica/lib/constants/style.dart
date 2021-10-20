//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/method.dart';

import 'Tema.dart';

//userInfo

/* ----- BOJE ---- */
final zelena1 = Color.fromRGBO(45, 106, 79, 1);
final zelenaDark = Color.fromRGBO(24,44,37, 1);
final svetloZelena = Color.fromRGBO(162, 195, 164, 1);
final svetloZelena2 = Color.fromRGBO(239, 235, 206, 1);
final bela = Colors.white;
final siva = Colors.grey[800];
final siva2 = Colors.grey[900];

/* ---- STAJLOVI ZA TEKST ------ */
final StyleZaInformacijeTextLight = TextStyle(
    color: bela, fontFamily: "Ubuntu", fontSize: 18.0, letterSpacing: 1.0);

final StyleZaInformacijeTextDark = TextStyle(
    color: bela, fontFamily: "Ubuntu", fontSize: 18.0, letterSpacing: 1.0);

final StyleZaInformacijeText2= TextStyle(
    color: zelenaGlavna, fontFamily: "Ubuntu", fontSize: 18.0, letterSpacing: 1.0);

final StyleZaInformacijeProfila = BoxDecoration(
  borderRadius: BorderRadius.circular(30),
  color: zelena1,
);

/* ---- TEKST HEADER----*/
final StyleTextZaHeaderOglas = TextStyle(
    fontFamily: 'Ubuntu',
    letterSpacing: 2.0,
    color:  Tema.dark ? bela : crnaGlavna,
    fontSize: 20.0,
    fontWeight: FontWeight.bold);
final StyleTextZaHeaderOglasLight = TextStyle(
    fontFamily: 'Ubuntu',
    letterSpacing: 2.0,
    color:  crnaGlavna,
    fontSize: 20.0,
    fontWeight: FontWeight.bold);
final StyleTextZaHeaderOglasDark = TextStyle(
    fontFamily: 'Ubuntu',
    letterSpacing: 2.0,
    color:  bela ,
    fontSize: 20.0,
    fontWeight: FontWeight.bold);
//addAds
final hintTextTextField =
    TextStyle(color: plavaTekst, fontFamily: "OpenSansItalic"); //addAds
final hintTextTextField2 =
    TextStyle(color: Colors.grey[900], fontFamily: "Montserrat");
//za dropdown
final StyleZaDropDown = TextStyle(color: svetlaBoja, fontFamily: 'Montserrat');
//Opis i Naslov
final StyleZaHeader1 = TextStyle(
  color: svetlaBoja,
  fontFamily: "Montserrat",
  fontSize: 20.0,
);

//Style za cenu
final StyleZaCenu = TextStyle(
  color: plavaTekst,
  fontFamily: "Montserrat",
  fontSize: 16.0,
);
final StyleZaCenu2 = TextStyle(
  color: plavaTekst,
  fontFamily: "Montserrat",
  fontSize: 16.0,
);
//NOVO
var svetloZuta = Color.fromRGBO(255, 239, 186, 1);
const plavaGlavna = Color.fromRGBO(83, 109, 254, 1);
var proba = Color.fromRGBO(214, 210, 195, 1);
var pozadinaHomePage = Color.fromRGBO(255, 239, 186, 1);
var tamnoplava = Color.fromRGBO(33, 30, 167, 1);
var svetloPlava3 = Color.fromRGBO(186, 202, 240, 1);
var plavaTekst = Color.fromRGBO(47, 51, 64, 1);
var tamnoplava2 = Color.fromRGBO(55, 56, 128, 1);
final svetlaBoja = Color.fromRGBO(239, 235, 206, 1);

//HOME PAGE 2
const kTextColor = Color(0xFF535353);
var kNaslovOglasa = plavaTekst;

const kDefaultPaddin = 20.0;


//OCENE

final StyleZaBoxOglase = BoxDecoration(
  borderRadius: BorderRadius.circular(15),
  color: svetloPlava3,
);
final StyleZaBoxKomentar_1 = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: svetloPlava3,
);


//HOMEPAGE BOJE

const HP_plava = Color(0xFF3D82AE);
const HP_bez = Color(0xFFD3A984);
const HP_siva = Color(0xFF989493);
const HP_roza = Color(0xFFFB7883);
const HP_siva2 = Color(0xFFAEAEAE);

const roza=Color.fromRGBO(232, 180, 206, 1);

//addAds
final StyleZaGlavniContainer= BoxDecoration(
  borderRadius: BorderRadius.circular(30),
  color: svetloZelena,
);

final StyleZaGlavniContainer2= BoxDecoration(
  borderRadius: BorderRadius.circular(30),
  color: zelena1//svetloPlava3,
);

//  color: Tema.dark? zelena1 : svetloZelena//svetloPlava3,
//NOVE BOJE ZA APP
const zelenaGlavna = Color(0xFF00BF6D);
const narandzasta = Color(0xFFFE9901);
const crnaGlavna = Color(0xFF1D1D35);
const belaGlavna = Color(0xFFF5FCF9);
const narandzasta2 = Color(0xFFF3BB1C);
const ErrorColor = Color(0xFFF03738);
const crvenaGlavna = Color.fromRGBO(202, 59, 50, 1);

const disabled = Color(0xFFA6E5AB);
const disabledDark = Color(0xFF4F6D51);

const kDefaultPadding = 20.0;

TextStyle titleStyleWhite = new TextStyle(
    color: plavaTekst,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
    fontSize: 20);
TextStyle titleStyleDarkk = new TextStyle(
    color: siva2,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
    fontSize: 20);
Color lightBlueIsh = Color(0xFF33BBB5);
Color lightGreen = Color(0xFF95E08E);
Color backgroundColor = Color(0xFFEFEEF5);

//--BOKSEVI ZA KOMENTARE--

final StyleZaBoxKomentar = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Tema.dark ? zelena1 : svetloZelena,
);
//pozitivni
final StyleZaBoxKomentarDark = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color:  zelena1 ,
);
final StyleZaBoxKomentarLight = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color:  svetloZelena,
);

final StyleZaBoxKomentarDarkNegative = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: crvenaGlavna ,
);
final StyleZaBoxKomentarLightNegative = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color:  darken(HP_roza) ,
);

final StyleZaBoxKomentarWeb = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Tema.dark ? zelena1 : svetloZelena,
);
// ignore: non_constant_identifier_names
final StyleZaBoxKomentar_2 = BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  color:Tema.dark ? crvenaGlavna :  Color.fromRGBO(250, 129, 107, 1),
);

final StyleZaLike1 =TextStyle(
    color: plavaTekst,
    fontFamily: "Ubuntu",
    fontWeight: FontWeight.bold);
final StyleZaLike2 =TextStyle(
    color:  svetloZelena,
    fontFamily: "Ubuntu",
    fontWeight: FontWeight.bold);


//boje za hp
const boja1=Color.fromRGBO(174, 139, 112, 1);
const boja2=Color.fromRGBO(48, 52, 55, 1);
const boja3=Color.fromRGBO(79, 0, 0, 1);
const boja4=Color.fromRGBO(47, 70, 96, 1);
// const boja5=Color.fromRGBO(138, 158, 161, 1);
const boja6=Color.fromRGBO(151, 12, 16, 1);
const boja5=Color.fromRGBO(84, 56, 85, 1);


//nove boje
const b0=Color.fromRGBO(174, 139, 112, 1);
const b1=Color.fromRGBO(48, 52, 55, 1);
const b2=Color.fromRGBO(142, 157, 204, 1);
const b3=Color.fromRGBO(	119, 51, 68, 1);
const b4=Color.fromRGBO(	42, 111, 151, 1);
const b5=Color.fromRGBO(84, 56, 85, 1);


//dark

const b6=Color.fromRGBO(27,38,44,1);
const b7=Color.fromRGBO(65,61,101,1);




//ZA TEMU

const darkPozadina = Color.fromRGBO(44, 44, 44, 1);