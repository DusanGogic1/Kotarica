import 'package:flutter/material.dart';

class CompanyName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'K',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ),
                Text(
                  'otarica',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.white70,
                    fontSize: 28.0,
                  ),
                ),
              ],
            ),
            //Icon(Icons.shopping_basket_outlined)
            //new Image.asset("images/logo.png")
          ],
        ),
      ),
    );
  }
}