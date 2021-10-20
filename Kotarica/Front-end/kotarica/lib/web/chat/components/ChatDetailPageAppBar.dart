import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/constants/Tema.dart';
import 'package:kotarica/constants/style.dart';
import 'package:kotarica/util/helper_functions.dart';
import 'package:kotarica/web/WebModels/ProductModelWeb.dart';
import 'package:provider/provider.dart';

class ChatDetailPageAppBarWeb extends StatelessWidget
    implements PreferredSizeWidget {
  String otherUsername;
  int advertId;

  ChatDetailPageAppBarWeb(this.otherUsername, this.advertId);

  @override
  Widget build(BuildContext context) {
    Future<ImageProvider> getFirstImage() async {
      var productModel = Provider.of<ProductModelWeb>(context, listen: false);
      var productImage = (await productModel.getProductById(advertId)).images[0];
      return loadIpfsImage(productImage);
    }
    return SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 12, top: 5),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Tema.dark?Colors.white:Colors.black,
                ),
              ),
              SizedBox(
                width: 2,
              ),
              FutureBuilder(
                future: getFirstImage(),
                builder: (context, snapshot) {
                  if(snapshot.data != null)
                    return  Image(image: snapshot.data, width: 80,);
                  else return CircularProgressIndicator();
                },
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      otherUsername,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Tema.dark ? bela : siva2,
                          fontSize: 13.5),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
