import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/ads/MyAds/DetailsScreenMyAds.dart';
import 'package:kotarica/product/Product.dart';
import 'package:kotarica/web/ads/MyAds/DetailsScreenMyAdsWeb.dart';
import 'MojiProizvodiWeb.dart';
import 'item_cardMyAdsWeb.dart';

class ItemCardListMyAdsWeb extends StatefulWidget {
  List<Product> products;
  int count;

  var size;

  ItemCardListMyAdsWeb(this.products, this.count, this.size);

  @override
  _ItemCardListState createState() => _ItemCardListState(products, count, size);
}

class _ItemCardListState extends State<ItemCardListMyAdsWeb> {
  List<Product> _products;
  int _count;

  var _size;

  _ItemCardListState(this._products, this._count, this._size);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _count,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //BROJ ELEMENATA U VRSTI
        mainAxisSpacing: _size * 0.03,
        crossAxisSpacing: _size * 0.03,
      ),
      itemBuilder: (context, index) => ItemCardMyAdsWeb(
        product: _products[index],
        press: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreenMyAdsWeb(
              product: _products[index],
            ),
          ),
        ),
      ),
    );
  }
}
