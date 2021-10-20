import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/ad_rating/rating.dart';
import 'package:kotarica/ads/MyAds/bodyMyAds.dart';
import 'package:kotarica/chat/ChatDetailPage.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/method.dart';

import 'package:kotarica/constants/style.dart';
import 'package:kotarica/home/HomeScreen.dart';
import 'package:kotarica/home/components/body.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/screens/details/components/cart_counter.dart';
import 'package:provider/provider.dart';
import 'package:kotarica/models/BuyingModel.dart';
import 'package:kotarica/models/MarksProductModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/ProductModel.dart';




class AddToCart extends StatefulWidget {
  const AddToCart({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  AddToCartState createState() => AddToCartState();
}

class AddToCartState extends State<AddToCart> {
  Future<String> _getFirstnameLastname(int otherId) async {
    String _otherUsername = await Provider.of<UserModel>(context, listen: false)
        .getFirstnameLastname(otherId);

    return _otherUsername;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var buyingModel = Provider.of<BuyingModel>(context);
    var productMarksModel = Provider.of<MarksProductModel>(context, listen: false);
    var productModel = Provider.of<ProductModel>(context);

    Future<bool> isItRatable(int productId) async {

      print("Id proizvoda: " + productId.toString());
      var numOfBought = await buyingModel.numberOfConfirmed(productId);
      var numOfRated = await productMarksModel.numberOfMarksPerUser(productId);
      return numOfBought > numOfRated;

    }

    Future<void> _PopUpPlacanje(int amount) async {
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
                        future: buyingModel.getBalance(),
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
                  if(_AdresaControler.text != "") _adresa1= _AdresaControler.text;
                  if(RadioButtonState.character == Currency.Ether) {
                    buyingModel.sendEther(amount, widget.product.priceEth,
                        widget.product.ownerUsername, context);
                    buyingModel.addToPending(
                        widget.product.ownerId, widget.product.id, amount,
                        _adresa1, widget.product.measuringUnit, "ETH");
                  }
                  else buyingModel.addToPending(
                      widget.product.ownerId, widget.product.id, amount,
                      _adresa1, widget.product.measuringUnit, "RSD");
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
              )
            ]
          );
        }
      );
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
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
              onPressed: () async {
                String _otherUsername = await _getFirstnameLastname(widget.product.ownerId);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChatDetailPage(widget.product.id, widget.product.ownerId, _otherUsername);
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
                p.amount = 1;
                productModel.addToCart(p);
                popUpDodatoUKorpu();
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
                _PopUpPlacanje(CartCounterState.numOfItems);
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
    var userModel = Provider.of<UserModel>(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Uspešno ste naručili proizvod ',
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
                       child: Text(_adresa1,
                           style:TextStyle(
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
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen()),
                        (Route<dynamic> route) => false);
                }
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

}

var _adresaControler = TextEditingController();
var _AdresaControler = TextEditingController();
String adresa;
String _adresa = adresa;
String _adresa1 = "";             //////OVDE JE SACUVANA ADRESA

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
    print(_name);
    setState(() {
      adresa = _name + ", "+ prefs.getString("city");
      _adresa1 = _name + ", " + prefs.getString("city");
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
      children:<Widget>[
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
