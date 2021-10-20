
import 'package:flutter/cupertino.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/constants/icons/milk_subcategories_icons.dart';

class StringConstants {

  // list of cities used for dropdown button
  static const cities = '["Ada", "Aleksandrovac", "Aleksinac", "Alibunar", "Apatin", "Aranđelovac", "Arilje", "Babušnica", "Bač", "Bačka Palanka", "Bačka Topola", "Bački Petrovac", "Bajina Bašta", "Batočina", "Bečej", "Bela Crkva", "Bela Palanka", "Beočin", "Beograd", "Blace", "Bogatić", "Bojnik", "Boljevac", "Bor", "Bosilegrad", "Brus", "Bujanovac", "Čačak", "Čajetina", "Ćićevac", "Čoka", "Crna Trava", "Ćuprija", "Despotovac", "Dimitrovgrad", "Doljevac", "Gadžin Han", "Gnjilane", "Golubac", "Gornji Milanovac", "Inđija", "Irig", "Istok", "Ivanjica", "Jagodina", "Kanjiža", "Kikinda", "Kladovo", "Knić", "Knjaževac", "Koceljeva", "Kosjerić", "Kosovo Polje", "Kosovska Kamenica", "Kosovska Mitrovica", "Kostolac", "Kovačica", "Kovin", "Kragujevac", "Kraljevo", "Krupanj", "Kruševac", "Kučevo", "Kula", "Kuršumlija", "Lajkovac", "Lapovo", "Lebane", "Leposavić", "Leskovac", "Lipljan", "Ljig", "Ljubovija", "Loznica", "Lučani", "Majdanpek", "Mali Iđoš", "Mali Zvornik", "Malo Crniće", "Medveđa", "Merošina", "Mionica", "Negotin", "Niš", "Nova Crnja", "Nova Varoš", "Novi Bečej", "Novi Kneževac", "Novi Pazar", "Novi Sad", "Obilić", "Odžaci", "Opovo", "Osečina", "Pančevo", "Paraćin", "Pećinci", "Petrovac na Mlavi", "Pirot", "Plandište", "Požarevac", "Požega", "Preševo", "Priboj", "Prijepolje", "Priština", "Prokuplje", "Rača (Kragujevačka)", "Raška", "Ražanj", "Rekovac", "Ruma", "Šabac", "Sečanj", "Senta", "Šid", "Sjenica", "Smederevo", "Smederevska Palanka", "Sokobanja", "Sombor", "Srbobran", "Sremska Mitrovica", "Sremski Karlovci", "Stara Pazova", "Štrpce", "Subotica", "Surdulica", "Svilajnac", "Svrljig", "Temerin", "Titel", "Topola", "Trgovište", "Trstenik", "Tutin", "Ub", "Užice", "Valjevo", "Varvarin", "Velika Plana", "Veliko Gradište", "Vitina", "Vladičin Han", "Vladimirci", "Vlasotince", "Vranje", "Vrbas", "Vrnjačka Banja", "Vršac", "Vučitrn", "Žabalj", "Žabari", "Žagubica", "Zaječar", "Žitište", "Žitorađa", "Zrenjanin", "Zubin Potok", "Zvečan"]';

  // categories
  static const kategorije = '["Sve kategorije","Mlečni proizvodi","Suhomesnato","Slani špajz","Slatki špajz","Piće","Mlin","Med","Vegan","Voće","Povrće","Ostalo"]';
  static const kategorije2 = '["Mlečni proizvodi","Suhomesnato","Slani špajz","Slatki špajz","Piće","Mlin","Med","Vegan","Voće","Povrće","Ostalo"]';

  // subcategories
 // static const mlecniProizvodi = '["Proizvodi od kravljeg mleka", "Proizvodi od kozijeg mleka", "Proizvodi od ovčijeg mleka", "Kajmak", "Puter", "Mlečni namazi"]';
  static const mlecniProizvodi = '["Mleko", "Jogurt","Sir","Kačkavalj","Kiselo mleko","Kefir" ,"Surutka", "Kajmak", "Puter", "Mlečni namazi", "Ostalo"]';
  static const suhomesnato = '["Pršuta",  "Kobasice", "Kulen", "Slanina" ,"Šunka","Ovčije prerađevine", "Goveđi program","Prerađevine od mangulice" ,"Ostalo"]';
  static const slaniSpajz = '["Turšija", "Sosovi", "Sokovi od povrća", "Ajvar", "Slani namazi"]';
  static const slatkiSpajz = '["Kolači","Torte" ,"Slatki namazi", "Džemovi"]';
  static const pica = '["Crveno vino", "Belo vino", "Rose vino",  "Voćna vina", "Domaće rakije", "Voćni sokovi", "Sirupi"]';
  static const mlin = '["Brašna", "Testenine"]';
  static const med = '["Med", "Proizvodi od meda"]';
  static const vegan = '[ "Suncokretova ulja","Maslinova ulja","Jabukovo sirće", "Začini", "Čajevi"]';
  static const voce = '[ "Jabuka","Kruška","Šljiva", "Grožđe", "Trešnja","Višnja","Dunja","Kajsija","Breskva"]';
  static const povrce = '[ "Kupus","Krompir","Šargarepa", "Luk", "Lubenica","Paradajz","Krastavac","Paprika","Karfiol","Boranija","Grašak","Pasulj"]';
  static const ostalo = '[]';


  // niz boja za homepage
  //static const List<Color> colors = [HP_siva, narandzasta, HP_bez, HP_plava, narandzasta, HP_bez];
  // static const List<Color> colors = [boja1, boja2, boja3, HP_bez,boja5, boja6];
  static const List<Color> colors = [b0, b1, b2, b3,b4, b5];
  static const List<Color> colorsDark = [b0, crnaGlavna, b6, b3,b7, b5];

//  static const mlecniProizvodi = '["Mleko", "Jogurt","Sir","Kačkavalj",
//  "Kiselo mleko","Kefir" ,"Surutka", "Kajmak", "Puter", "Mlečni namazi", "Ostalo"]';
  //ikone
  static const mlecniIcone=
  [
    AssetImage("images/potkategorije/MlecniProizvodi/mleko.jpeg"),
    AssetImage("images/potkategorije/MlecniProizvodi/jogurt.jpg"),
    AssetImage("images/potkategorije/MlecniProizvodi/sir.jpg"),
    AssetImage("images/potkategorije/MlecniProizvodi/kackavalj.jpg"),
    AssetImage("images/potkategorije/MlecniProizvodi/kiselo_mleko.jpg"),
    AssetImage("images/potkategorije/MlecniProizvodi/kefir.jpg"),
    AssetImage("images/potkategorije/MlecniProizvodi/surutka.jpg"),
    AssetImage("images/potkategorije/MlecniProizvodi/Kajmak.jpg"),
    AssetImage("images/potkategorije/MlecniProizvodi/puter.jpg"),
    AssetImage("images/potkategorije/MlecniProizvodi/mlecni_namazi1.png"),
    AssetImage("images/potkategorije/MlecniProizvodi/ostalo.jpg"),

  ];

  static const suhomesnatoIkone=
  [

    AssetImage("images/potkategorije/suhomesnato/prsuta.jpg"),
    AssetImage("images/potkategorije/suhomesnato/kobasica.jpg"),
    AssetImage("images/potkategorije/suhomesnato/kulen.jpg"),
    AssetImage("images/potkategorije/suhomesnato/slanina.jpg"),
    AssetImage("images/potkategorije/suhomesnato/sunka.jpg"),
    AssetImage("images/potkategorije/suhomesnato/ovca.jpg"),
    AssetImage("images/potkategorije/suhomesnato/krava.jpg"),
    AssetImage("images/potkategorije/suhomesnato/mangulica.jpg"),
    AssetImage("images/potkategorije/suhomesnato/ostalo.jpg"),
  ];

  //  static const slaniSpajz = '["Turšija", "Sosovi", "Sokovi od povrća", "Ajvar", "Slani namazi"]';
  static const SlaniSpajzIkone=
  [

    AssetImage("images/potkategorije/SlaniSpajz/tursija.jpg"),
    AssetImage("images/potkategorije/SlaniSpajz/sosovi.jpg"),
    AssetImage("images/potkategorije/SlaniSpajz/sokoviPovrce.jpg"),
    AssetImage("images/potkategorije/SlaniSpajz/ajvar.jpg"),
    AssetImage("images/potkategorije/SlaniSpajz/slaniNamazi.jpg"),

  ];
  static const SlatkiSpajzIkone=
  [

    AssetImage("images/potkategorije/slatkiSpajz/kolaci.jpg"),
    AssetImage("images/potkategorije/slatkiSpajz/torte.jpg"),
    AssetImage("images/potkategorije/slatkiSpajz/slatkiNamaz.jpg"),
    AssetImage("images/potkategorije/slatkiSpajz/dzem.jpg"),
  ];
//  static const pica = '["Crveno vino", "Belo vino", "Rose vino",  "Voćna vina",
//  "Domaće rakije", "Voćni sokovi", "Sirupi"]';

  static const picaIkone=
  [

    AssetImage("images/potkategorije/pica/crvenoVino.jpg"),
    AssetImage("images/potkategorije/pica/beloVino.jpg"),
    AssetImage("images/potkategorije/pica/roseVino.jpg"),
    AssetImage("images/potkategorije/pica/vocnaVina.jpg"),
    AssetImage("images/potkategorije/pica/rakija.jpg"),
    AssetImage("images/potkategorije/pica/vocniSokovi.jpg"),
    AssetImage("images/potkategorije/pica/sirup.jpg"),

  ];
  static const mlinIkone=
  [

    AssetImage("images/potkategorije/mlin/brasno.jpg"),
    AssetImage("images/potkategorije/mlin/testenine.jpg"),
  ];


  static const medIkone=
  [

    AssetImage("images/potkategorije/med/med.jpg"),
    AssetImage("images/potkategorije/med/proizvodiMed.jpg"),
  ];
  static const veganIkone=
  [

    AssetImage("images/potkategorije/vegan/suncokretovoUlje.jpg"),
    AssetImage("images/potkategorije/vegan/maslinovoUlje.jpg"),
    AssetImage("images/potkategorije/vegan/jabukovoSirce.jpg"),
    AssetImage("images/potkategorije/vegan/zacini.jpg"),
    AssetImage("images/potkategorije/vegan/cajevi.jpg"),
  ];

  static const voceIkone= //"Jabuka","Kruška","Šljiva", "Grožđe", "Trešnja","Višnja","Dunja","Kajsija","Breskva"
  [

    AssetImage("images/potkategorije/voce/jabuka.jpg"),
    AssetImage("images/potkategorije/voce/kruska.jpg"),
    AssetImage("images/potkategorije/voce/sljiva.jpg"),
    AssetImage("images/potkategorije/voce/grozdje.jpg"),
    AssetImage("images/potkategorije/voce/tresnja.png"),
    AssetImage("images/potkategorije/voce/visnja.jpg"),
    AssetImage("images/potkategorije/voce/dunja.jpg"),
    AssetImage("images/potkategorije/voce/kajsija.jpg"),
    AssetImage("images/potkategorije/voce/breskva.jpg"),

  ];

  static const povrceIkone= //"Kupus","Krompir","Šargarepa", "Luk", "Lubenica","Paradajz","Krastavac","Paprika","Karfiol","Boranija","Grašak","Pasulj"
  [

    AssetImage("images/potkategorije/povrce/kupus.jpg"),
    AssetImage("images/potkategorije/povrce/krompir.jpg"),
    AssetImage("images/potkategorije/povrce/sargarepa.jpg"),
    AssetImage("images/potkategorije/povrce/luk.jpg"),
    AssetImage("images/potkategorije/povrce/lubenica.jpg"),
    AssetImage("images/potkategorije/povrce/paradajz.jpg"),
    AssetImage("images/potkategorije/povrce/krastavac.jpg"),
    AssetImage("images/potkategorije/povrce/paprika.jpg"),
    AssetImage("images/potkategorije/povrce/karfiol.jpg"),
    AssetImage("images/potkategorije/povrce/boranija.jpg"),
    AssetImage("images/potkategorije/povrce/grasak.jpg"),
    AssetImage("images/potkategorije/povrce/pasulj.jpg"),
  ];


  static double valueOfEth = 0.0000042; // privremeno
}