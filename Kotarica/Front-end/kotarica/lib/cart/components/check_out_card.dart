import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/models/UserModel.dart';
import 'package:kotarica/models/BuyingModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ads/MyAds/bodyMyAds.dart';
import '../../home/HomeScreen.dart';
import '../../home/components/body.dart';

var _adresaControler = TextEditingController();
var _AdresaControler = TextEditingController();
String adresa;
String _adresa = adresa;
String _adresa1 = "";

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Future<void> _uspesnKupovina() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(

            title: Text(
              'Uspešno ste naručili proizvode ',
              style: TextStyle(
                color: zelena1,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
                child: Container(
                  width : size.width*2/5,
                  height: size.height*2/5,
                  child: ListView.builder(
                    itemCount: ProductModel.cart.length,
                    itemBuilder: (context, index)
                    {
                      return Row(
                        children: [
                          Text("Proizvod: " , style: TextStyle(color: Tema.dark?bela:Colors.black),),
                          Flexible(
                            child: Text(ProductModel.cart[index].title),
                            ),
                          Text(",\n Kolicina: " , style: TextStyle(color: Tema.dark?bela:Colors.black),),
                          Flexible(
                            child: Text(ProductModel.cart[index].amount.toString(),style:TextStyle(
                              )
                            ),
                          ),
                        ]
                      );
                    }
                )
            )),
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
                  ProductModel.cart.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen()), (Route<dynamic> route) => false
                    );
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _PopUpPlacanje() async {
      var size = MediaQuery.of(context).size.width;
      var userModel = Provider.of<UserModel>(context, listen: false);
      var buyingModel = Provider.of<BuyingModel>(context, listen: false);
      double cartSum()
      {
        double sum = 0;
        for(var i = 0; i < ProductModel.cart.length;i++)
        {
          sum+=ProductModel.cart[i].amount*ProductModel.cart[i].priceEth;
        }
        return sum;
      }
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
                    RadioButton(priceEth: cartSum()),
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
                onPressed: () async {
                  if(_AdresaControler.text != "") _adresa1= _AdresaControler.text;
                    for(var i = 0; i < ProductModel.cart.length; i++) {
                      if(RadioButtonState.character == Currency.Ether) {
                        await buyingModel.sendEther(ProductModel.cart[i].amount,
                            ProductModel.cart[i].priceEth,
                            ProductModel.cart[i].ownerUsername, context);
                        await buyingModel.addToPending(ProductModel.cart[i].ownerId,
                            ProductModel.cart[i].id,
                            ProductModel.cart[i].amount, _adresa1,
                            ProductModel.cart[i].measuringUnit, "ETH");
                      }
                      else
                        {
                          await buyingModel.addToPending(
                              ProductModel.cart[i].ownerId,
                              ProductModel.cart[i].id,
                              ProductModel.cart[i].amount, _adresa1,
                              ProductModel.cart[i].measuringUnit, "RSD");
                        }
                    }
                  _adresaControler.text = "";
                  Future(() => _uspesnKupovina());
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
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 30,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Tema.dark ? siva2 : svetloZelena2,
        borderRadius: BorderRadius.only(
         // topLeft: Radius.circular(30),
         // topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: getProportionateScreenHeight(20)),
            SizedBox(height: (5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Ukupno:\n",
                    style: TextStyle( color: Tema.dark ? svetloZelena : Colors.black,),
                    children: [
                      TextSpan(
                        text: ProductModel.getCartPriceSumRsd() +" RSD\n",
                        style: TextStyle(fontSize: 16,  color: Tema.dark ? svetloZelena : Colors.black),
                      ),
                      TextSpan(
                        text: ProductModel.getCartPriceSumEth() +" ETH",
                        style: TextStyle(fontSize: 16,  color: Tema.dark ? svetloZelena : Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                  width: size.width * 0.45,
                  child:FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    color: crvenaGlavna,
                    onPressed: () {
                      _PopUpPlacanje();
                    },
                    child: Text(
                      "Završi kupovinu",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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