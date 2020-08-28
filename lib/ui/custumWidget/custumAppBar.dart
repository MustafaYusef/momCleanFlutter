import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mom_clean/ui/auth/logInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MyCartScreen.dart';

class myAppBar extends StatefulWidget {
  final cont;
  //  final int notifNum;
  //   final int cart;
  const myAppBar({Key key, @required this.cont}) : super(key: key);

  @override
  _myAppBarState createState() => _myAppBarState();
}

class _myAppBarState extends State<myAppBar> {
  int notifNum = 0;
  int cart = 0;

  @override
  void initState() {
    super.initState();
    getImage();
  }

  getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notifNum = prefs.getInt('notification');
      cart = prefs.getInt('cart');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 15, bottom: 10),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var token = await prefs.getString('token');

              Navigator.push(context, MaterialPageRoute(builder: (_) {
                if (token == null || token == "") {
                  return LoginScreen();
                } else {
                  return MyCartScreen();
                }
              }));
            },
            child: Container(
              child: cart == 0 || cart == null
                  ? Icon(Icons.shopping_cart, color: Colors.lightBlue[900])
                  : Badge(
                      badgeContent: Text(
                        cart == 0 || cart == null ? "" : cart.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      badgeColor: Colors.deepOrange,
                      child: Icon(Icons.shopping_cart,
                          color: Colors.lightBlue[900]),
                    ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 80,
          ),
          InkWell(
            onTap: () {
              Scaffold.of(widget.cont).openEndDrawer();
            },
            child: Container(
              child: notifNum == 0 || notifNum == null
                  ? Icon(Icons.menu, color: Colors.lightBlue[900])
                  : Badge(
                      badgeContent: Text(
                        notifNum == 0 || notifNum == null
                            ? ""
                            : notifNum.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      position: BadgePosition.topLeft(),
                      badgeColor: Colors.deepOrange,
                      child: Icon(Icons.menu, color: Colors.lightBlue[900]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
