import 'package:flutter/material.dart';
import 'package:kotarica/constants/style.dart';

class NavBarItem extends StatefulWidget {
  final IconData icon;
  final Function touched;
  final bool active;
  final String name;
  NavBarItem({
    this.icon,
    this.touched,
    this.active,
    this.name
  });
  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  @override
  Widget build(BuildContext context) {
    var Sheight= MediaQuery.of(context).size.height;
    var Swidth = MediaQuery.of(context).size.width ;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          //print(widget.icon);
          widget.touched();
        },
        splashColor: Colors.white,
        hoverColor: Colors.white12,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: [
              Container(
                height: 50.0,
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 475),
                      height: 35.0,
                      width: 5.0,
                      decoration: BoxDecoration(
                        color: widget.active ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:10.0),
                      child: Row(
                        children: [
                          Icon(
                            widget.icon,
                            color: widget.active ? Colors.white : Colors.white54,
                            size: 19.0,
                          ),
                          SizedBox(width: 5,),
                          Text(
                            ""+ widget.name,style: TextStyle(color:bela, fontFamily: "Montserrat",fontSize: Swidth*0.009),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}