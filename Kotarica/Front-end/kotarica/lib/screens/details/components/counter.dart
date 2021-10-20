import 'package:flutter/material.dart';
import 'package:kotarica/constants/style.dart';
import 'package:provider/provider.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/models/ProductModel.dart';


//brojac na oglasnoj strani, koliko proizvoda zeli da doda u korpu

class CartCounter extends StatefulWidget {
  final Product product;

  const CartCounter({Key key, this.product}) : super(key: key);


  @override
  _CartCounterState createState() => _CartCounterState(product);
}

class _CartCounterState extends State<CartCounter> {
  int numOfItems;
  Product product;
  _CartCounterState(Product p) {product = p; numOfItems = p.amount;}
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var productModel = Provider.of<ProductModel>(context);
    return Row(
      children: <Widget>[
        buildOutlineButton(
          icon: Icons.remove,
          press: () {
            if (numOfItems > 1) {
              setState(() {
                Product p = widget.product;
                print(numOfItems);
                p.priceEth = p.priceEth/numOfItems;
                p.priceRsd = (p.priceRsd/numOfItems).toInt();
                numOfItems--;
                print(numOfItems);
                p.amount = numOfItems;
                p.priceRsd*=numOfItems;
                p.priceEth*=numOfItems;
                productModel.addToCart(p);
              });
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
          child: Text(
            numOfItems.toString().padLeft(2, "0"),
            style: TextStyle(fontSize: 20),
          ),
        ),
        buildOutlineButton(
            icon: Icons.add,
            press: () {
              setState(() {
                Product p = widget.product;
                print(p.priceEth);
                print(p.priceRsd);
                print(p.amount);
                p.priceEth = p.priceEth/p.amount;
                p.priceRsd = (p.priceRsd/p.amount).toInt();
                numOfItems++;
                p.amount = numOfItems;
                p.priceRsd*=p.amount;
                p.priceEth*=p.amount;
                print(p.priceEth);
                print(p.priceRsd);
                print(p.amount);
                productModel.addToCart(p);
              });
            }),
      ],
    );
  }

  SizedBox buildOutlineButton({IconData icon, Function press}) {
    var size = MediaQuery.of(context).size.width;
    return SizedBox(
      width: size * 0.08,
      height: size * 0.08,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }
}
