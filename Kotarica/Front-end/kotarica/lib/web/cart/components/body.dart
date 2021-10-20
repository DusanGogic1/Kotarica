import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/models/ProductModel.dart';
import 'package:kotarica/web/WebModels/BuyingModelWeb.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:kotarica/web/cart/cart_screenWeb.dart';
import 'package:kotarica/web/cart/components/cart_card.dart';
import 'package:provider/provider.dart';


class BodyWeb extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<BodyWeb> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var productModel = Provider.of<ProductModelWeb>(context);
    var buyingModel = Provider.of<BuyingModelWeb>(context);
    return Container(
      margin: EdgeInsets.only(left: size * 0.17),
      width: size * 0.65,
      color: Tema.dark ? siva : bela,
      child: Padding(
        padding:
        // EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        EdgeInsets.symmetric(horizontal: 5),
        child: ListView.builder(
          itemCount: ProductModelWeb.cart.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Dismissible(
              key: Key(ProductModelWeb.cart[index].id.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                  productModel.removeFromCart(ProductModelWeb.cart[index]);
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreenWeb()));
              },
              background: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Tema.dark ? Color.fromRGBO(24,44,37,1) :Color(0xFFFFE6E6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Spacer(),
                    //--KANTA KAD SE PREVUCE ZA BRISANJE--
                    Image.asset("images/icons/Trash.png"),
                  ],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                    color: Tema.dark ? siva2 : svetloZelena2,
                    child: CartCardWeb(product: ProductModelWeb.cart[index])),
              ),
            ),
          ),
        ),
      ),
    );
  }
}