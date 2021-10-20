import 'package:flutter/material.dart';

import 'package:kotarica/cart/size/size_config.dart';
import 'package:kotarica/cart/size/constants.dart';

//--DUGME--

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: getProportionateScreenHeight(56),
      height: 10,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: kPrimaryColor,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            // fontSize: getProportionateScreenWidth(18),
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}