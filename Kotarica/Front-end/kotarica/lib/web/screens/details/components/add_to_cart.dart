import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/ad_rating/rating.dart';
import 'package:kotarica/ads/MyAds/bodyMyAds.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/home/components/body.dart' show NovaAdresa;
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/screens/details/components/cart_counter.dart';
import 'package:kotarica/web/WebModels/BuyingModelWeb.dart';
import 'package:kotarica/web/WebModels/MarksProductModelWeb.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:kotarica/web/chat/ChatDetailPage.dart';
import 'package:kotarica/web/home/HomeScreen.dart';
import 'package:kotarica/web/screens/details/components/cart_counter.dart';
import 'package:provider/provider.dart';
import 'package:kotarica/models/BuyingModel.dart';
import 'package:kotarica/models/MarksProductModel.dart';
import 'package:shared_preferences/shared_preferences.dart';




class AddToCartWeb extends StatefulWidget {
  const AddToCartWeb({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCartWeb> {

  Future<String> _getFirstnameLastname(int otherId) async {
    String _otherUsername = await Provider.of<UserModelWeb>(context, listen: false)
        .getFirstnameLastname(otherId);

    return _otherUsername;
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size.width;
    var buyingModelWeb = Provider.of<BuyingModelWeb>(context, listen: false);
    var productMarksModel = Provider.of<MarksProductModelWeb>(context, listen: false);
    var productModel = Provider.of<ProductModelWeb>(context);

    Future<bool> isItRatable(int productId) async {

      print("Id proizvoda: " + productId.toString());
      var numOfBought = await buyingModelWeb.numberOfConfirmed(productId);
      var numOfRated = await productMarksModel.numberOfMarksPerUser(productId);
      return numOfBought > numOfRated;

    }

    Future<void> _PopUpPlacanje(int amount) async {
      var size = MediaQuery.of(context).size.width;

      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: SingleChildScrollView(
              child: ListBody(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "Izaberite način plaćanja",
                            style: TextStyle(color: zelena1, fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    RadioButton(priceEth: widget.product.priceEth),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "Izaberite adresu dostavljanja",
                            style: TextStyle(color: zelena1, fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    RadioButtonAdresa(),
                    FutureBuilder(
                        future: buyingModelWeb.getBalance(),
                        builder: (context, snapshot) {
                          if(snapshot.data != null)
                            return Container(
                                padding: EdgeInsets.fromLTRB(0, 17, 0, 0),
                                child:Text(
                                    "Stanje na vašem računu: " + snapshot.data.toStringAsFixed(6) + " ETH",
                                    style: TextStyle(color: Tema.dark?bela:Colors.black)
                                )
                            );
                          else return SizedBox(height: 1, width: 1);
                        }
                    )
                  ]
              ),
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: zelena1,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Odustani".toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: belaGlavna,
                  ),
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: zelena1,
                onPressed: () {
                  if(_AdresaControler.text != "") _adresa1= _AdresaControler.text;
                  if(RadioButtonState.character == Currency.Ether)
                  {
                    buyingModelWeb.sendEther(amount, widget.product.priceEth,  widget.product.ownerUsername, context);
                    buyingModelWeb.addToPending(widget.product.ownerId, widget.product.id, amount, _adresa1, widget.product.measuringUnit, "ETH");
                  }
                  else
                    buyingModelWeb.addToPending(widget.product.ownerId, widget.product.id, amount, _adresa1, widget.product.measuringUnit, "RSD");
                  _adresaControler.text = "";
                  _uspesnKupovina(amount);
                },
                child: Text(
                  "Kupi".toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: belaGlavna,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    Future<void> popUpDodatoUKorpu() {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Proizvod je dodat u korpu!'),
                ],
              ),
            ),
            actions: <Widget>[

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: zelena1,
                  onPrimary: Colors.white,
                ),
                child: Text(
                  'Potvrdi ',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigator.of(context).pop();
                  // Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //--DUGME ZA CET--
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Tema.dark ? svetloZelena : zelena1,
              ),
            ),
            child:IconButton(
              icon: Icon(Icons.chat),
              //uzima boju oglasa na pocetnoj strani
              color: Tema.dark ? svetloZelena : zelena1,
              //DA ODE NA CET, TREBA DA SE DODA
              onPressed: () async {
                String _otherUsername = await _getFirstnameLastname(widget.product.ownerId);

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChatDetailPageWeb(widget.product.id, widget.product.ownerId, _otherUsername);
                }));
              },
            ),
          ),
          SizedBox(width:10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Tema.dark?darken(widget.product.color):widget.product.color,
              ),
            ),
            child: IconButton(
              icon: Image.asset("images/icons/add_to_cart.png"),
              //uzima boju oglasa na pocetnoj strani
              // color: widget.product.color,
              onPressed: () {
                print(widget.product.title);
                Product p = widget.product;
                p.amount = CartCounterState.numOfItems;
                productModel.addToCart(p);
                popUpDodatoUKorpu();
              //  popUpDodatoUKorpu();
              },
            ),
          ),
          SizedBox(width:10),

          //---DUGME PORUCI---
          Expanded(
            flex: 4,
            child:FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              color: Tema.dark? darken(widget.product.color):widget.product.color,
              onPressed: () {
                _PopUpPlacanje(CartCounterStateWeb.numOfItems);
              },
              child: Text(
                "Poruči".toUpperCase(),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: belaGlavna,
                ),
              ),
            ),
          ),
          FutureBuilder(
              future: isItRatable(widget.product.id),
              builder: (context, snapshot){
                if(snapshot.data == true)
                {
                  return Expanded(
                    flex: 4,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      color: Tema.dark? darken(widget.product.color):widget.product.color,
                      onPressed: () {
                         Navigator.of(context).pushAndRemoveUntil(
                             MaterialPageRoute(builder: (context) => RatingPage(
                                 username: widget.product.ownerId,
                                 ID: widget.product.id)),
                                 (Route<dynamic> route) => false);
                        Navigator.push(context,
                         MaterialPageRoute(
                        builder: (context) => RatingPage(
                        username: widget.product.ownerId,
                        ID: widget.product.id)
                        )
                        );
                      },
                      child: Text(
                        "Oceni".toUpperCase(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: belaGlavna,
                        ),
                      ),
                    ),
                  );
                } else return Container(width: 0, height: 0);
              }
          )
          //ovde dodati ako je kupljen dugme oceni
        ],
      ),
    );
  }

  //Funkcija za alert -- brisanje naloga
  Future<void> _uspesnKupovina(int amount) async {
    var userModel = Provider.of<UserModelWeb>(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Uspešna kupovina ',
            style: TextStyle(
              color: zelena1,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Flexible(
                      child: Text("Adresa: ",
                          style:TextStyle(
                            // fontFamily: "Montserrat",
                              fontWeight:FontWeight.bold,
                              color: zelena1)
                      ),
                    ),
                    Flexible(
                      child: Text(_adresa1,style:TextStyle(
                        // fontFamily: "Montserrat",
                      )),
                    ),
                  ],
                ),
                SizedBox(height:3),
                Row(
                  children: [
                    Flexible(
                      child: Text("Proizvod: ",
                          style:TextStyle(
                              fontWeight:FontWeight.bold,
                              color: zelena1)
                      ),
                    ),
                    Flexible(
                      child: Text(widget.product.title,style:TextStyle(
                      )),
                    ),
                  ],
                ),
                SizedBox(height:3),
                Row(
                  children: [
                    Flexible(
                      child: Text("Količina: ",
                          style:TextStyle(
                            // fontFamily: "Montserrat",
                              fontWeight:FontWeight.bold,
                              color: zelena1)
                      ),
                    ),
                    Flexible(
                      child: Text(amount.toString(),style:TextStyle(
                        // fontFamily: "Montserrat",
                      )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: zelena1,
                onPrimary: Colors.white,
              ),
              child: Text(
                'Potvrdi ',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                //mislim da je bolje da se vrati na pocetnu --proveri!
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreenWeb(),
                  ),
                );
                //  Navigator.of(context).pop();
                //  Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}


var _adresaControler = TextEditingController();
var _AdresaControler = TextEditingController();
String adresa;
String _adresa = adresa;
String _adresa1;             //////OVDE JE SACUVANA ADRESA

/*=============KLASA ZA RADIOBUTTON ZA ADRESU=================*/
class RadioButtonAdresa extends StatefulWidget {
  const RadioButtonAdresa({Key key}) : super(key: key);

  @override
  RadioButtonStateAdresa createState() => RadioButtonStateAdresa();
}

class RadioButtonStateAdresa extends State<RadioButtonAdresa> {
  bool _disable = false; // set this to false initially

  Future<String> _loadAdresa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _name = prefs.getString("personalAddress");
    //print(_name);
    setState(() {
      adresa = _name + ", "+ prefs.getString("city");
      _adresaControler.text = adresa;
    });
    return _name;
  }
  Future<String> _loadData(String dataNeeded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = prefs.getString(dataNeeded);
    return data;
  }

  Future<void> setData() async {
    _adresa1 = await _loadAdresa() + ", " + await _loadData("city");
    _adresa = _adresa1;
  }

  void initState() {
    super.initState();
    setData().whenComplete((){setState((){_adresa1= _adresa1;_adresa=_adresa;});});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          selectedTileColor: zelenaGlavna,
          focusColor: zelenaGlavna,
          title: FutureBuilder(
            future: _loadAdresa(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return FutureBuilder(
                    future: _loadData("city"),
                    builder: (context, snap){
                      if(snap.data != null)
                        return Text(
                          snapshot.data + ", " + snap.data,
                          style: TextStyle(color: Tema.dark ? bela : crnaGlavna),
                        );
                      else return Text("");
                    }
                );
              } else
                return Text("");
            },
          ),
          leading: Radio<String>(
            activeColor: zelenaGlavna,
            focusColor: zelenaGlavna,
            value: adresa,
            groupValue: _adresa,
            onChanged: (String value) {
              setState(() {
                _adresa = value;
                _adresa1 = value; //stara
                print(_adresa1);
                _AdresaControler.text = "";
                _adresaControler.text = "";
                _disable = false;
              });
            },
          ),
        ),
        ListTile(
          selectedTileColor: zelenaGlavna,
          focusColor: zelenaGlavna,
          title: Text("Druga adresa",
              style: TextStyle(
                color: Tema.dark ? bela : crnaGlavna,
              )),
          leading: Radio<String>(
            activeColor: zelenaGlavna,
            focusColor: zelenaGlavna,
            value: NovaAdresa,
            groupValue: _adresa,
            onChanged: (String value) {
              setState(() {
                _adresa=value;
                _adresa1 = _adresaControler.text; //nova
                print(_adresa1);
                _disable = true;
              });
            },
          ),
        ),
        TextFormField(
          enabled: _disable,
          style: TextStyle(color: Colors.black87),
          controller: _AdresaControler,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Unesite novu adresu',
            fillColor: Tema.dark ? bela : siva,
            labelStyle: TextStyle(fontFamily: "OpenSansItalic"),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: zelena1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RadioButton extends StatefulWidget {
  final priceEth;
  const RadioButton({Key key, @required this.priceEth}) : super(key: key);

  @override
  RadioButtonState createState() => RadioButtonState(priceEth);
}

class RadioButtonState extends State<RadioButton> {
  static var character = Currency.RSD;
  final priceEth;

  RadioButtonState(this.priceEth);
  void initState() {
    super.initState();
    setState(() {
      character = Currency.RSD;
    });
  }

  Widget build(BuildContext context) {
    var buyingModel = Provider.of<BuyingModelWeb>(context);
    return Column(
      children: <Widget>[
        ListTile(
          selectedTileColor: zelenaGlavna,
          focusColor: zelenaGlavna,
          title: Text(
            'RSD - pouzećem',
            style: TextStyle(color: Tema.dark ? bela : crnaGlavna),
          ),
          leading: Radio<Currency>(
            activeColor: zelenaGlavna,
            focusColor: zelenaGlavna,
            value: Currency.RSD,
            groupValue: character,
            onChanged: (Currency value) {
              setState(() {
                print(value);
                character = Currency.RSD;
              });
            },
          ),
        ),
        FutureBuilder(
            future: buyingModel.isItBoughtable(priceEth),
            builder: (context, snapshot) {
              print(priceEth);
              if(snapshot.data == true || snapshot.data == null)
              {
                return ListTile(
                  selectedTileColor: zelenaGlavna,
                  focusColor: zelenaGlavna,
                  title: Text('Ether - online',
                      style: TextStyle(color: Tema.dark ? bela : crnaGlavna)),
                  leading: Radio<Currency>(
                    activeColor: zelenaGlavna,
                    value: Currency.Ether,
                    groupValue: character,
                    onChanged: (Currency value) {
                      setState(() {
                        print(value);
                        character = Currency.Ether;
                      });
                    },
                  ),
                );
              }
              else return Container(
                alignment: Alignment.center,
                child: Text("Nemate dovoljno novca da bi kupovali u kriptovalutama.\n", style: TextStyle(color:Tema.dark?bela:Colors.black)),);
            }
        ),
      ],
    );
  }
}