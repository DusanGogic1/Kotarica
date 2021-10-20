import 'package:flutter/material.dart';
import 'package:kotarica/ads/MyAds/bodyMyAds.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/web/WebModels/BuyingModelWeb.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/WebModels/UserModelWeb.dart';
import 'package:kotarica/web/home/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kotarica/web/screens/details/components/add_to_cart.dart';
import 'package:kotarica/home/components/body.dart' show NovaAdresa;

var _adresaControler = TextEditingController();
var _AdresaControler = TextEditingController();
String adresa;
String _adresa = adresa;
String _adresa1 = "";
class CheckoutCardWeb extends StatelessWidget {
  const CheckoutCardWeb({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var buyingModel = Provider.of<BuyingModelWeb>(context);

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
                        itemCount: ProductModelWeb.cart.length,
                        itemBuilder: (context, index)
                        {
                          return Row(
                              children: [
                                Text("Proizvod: " , style: TextStyle(color: Tema.dark?bela:Colors.black),),
                                Flexible(
                                  child: Text(ProductModelWeb.cart[index].title),
                                ),
                                Text(", Kolicina: " , style: TextStyle(color: Tema.dark?bela:Colors.black),),
                                Flexible(
                                  child: Text(ProductModelWeb.cart[index].amount.toString(),style:TextStyle(
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
                  ProductModelWeb.cart.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => HomeScreenWeb()), (Route<dynamic> route) => false
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
      var userModel = Provider.of<UserModelWeb>(context, listen: false);

      double cartSum()
      {
        double sum = 0;
        for(var i = 0; i < ProductModelWeb.cart.length;i++)
        {
          sum+=ProductModelWeb.cart[i].amount*ProductModelWeb.cart[i].priceEth;
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
                  for(var i = 0; i < ProductModelWeb.cart.length; i++) {
                    if(RadioButtonState.character == Currency.Ether) {
                      await buyingModel.sendEther(ProductModelWeb.cart[i].amount,
                          ProductModelWeb.cart[i].priceEth,
                          ProductModelWeb.cart[i].ownerUsername, context);
                      await buyingModel.addToPending(ProductModelWeb.cart[i].ownerId,
                          ProductModelWeb.cart[i].id,
                          ProductModelWeb.cart[i].amount, _adresa1,
                          ProductModelWeb.cart[i].measuringUnit, "ETH");
                    }
                    else
                    {
                      await buyingModel.addToPending(
                          ProductModelWeb.cart[i].ownerId,
                          ProductModelWeb.cart[i].id,
                          ProductModelWeb.cart[i].amount, _adresa1,
                          ProductModelWeb.cart[i].measuringUnit, "RSD");
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
      width: size.width * 0.65,
      padding: EdgeInsets.symmetric(
        vertical: size.width * 0.01,
        horizontal: size.width * 0.2,
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
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Ukupno:\n",
                    style: TextStyle( color: Tema.dark ? svetloZelena : Colors.black,),
                    children: [
                      TextSpan(
                        text: ProductModelWeb.getCartPriceSumRsd() +" RSD\n",
                        style: TextStyle(fontSize: 16,  color: Tema.dark ? svetloZelena : Colors.black),
                      ),
                      TextSpan(
                        text: ProductModelWeb.getCartPriceSumEth() +" ETH\n",
                        style: TextStyle(fontSize: 16,  color: Tema.dark ? svetloZelena : Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  //margin: EdgeInsets.only(bottom: size * 0.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.1,
                    //height: size * 0.04,
                    //width: size * 0.14,
                    child: ProductModelWeb.cart.length!=0?FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      color: crvenaGlavna,
                      onPressed: () {
                        _PopUpPlacanje();
                      },
                      child: Text(
                        "Završi kupovinu",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ):SizedBox()
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