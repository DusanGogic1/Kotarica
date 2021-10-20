import 'package:flutter/material.dart';

import 'Product.dart';


class CartWeb {
  final Product product;
  final int numOfItem;

  CartWeb({@required this.product, @required this.numOfItem});
}

// Demo data for our cart

List<CartWeb> demoCarts = [
  CartWeb(product: demoProducts[0], numOfItem: 2),
  CartWeb(product: demoProducts[1], numOfItem: 1),
  CartWeb(product: demoProducts[3], numOfItem: 1),
];