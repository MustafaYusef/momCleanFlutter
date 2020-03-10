

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mom_clean/ui/auth/logInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MyCartScreen.dart';

class myAppBar extends StatelessWidget {
  final  cont;
   final int notifNum;
    final int cart;
  const myAppBar({
    Key key,@required this.cont, this. cart, this. notifNum
  }) : super(key: key);

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
              if(token==null||token==""){
 return LoginScreen();
              }else{
 return MyCartScreen();
              }
             
            }));
                },
                      child: Badge(
              badgeContent: Text(
               cart==0||cart==null?"": cart.toString(),
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              badgeColor: Colors.deepOrange,
              child: Icon(Icons.shopping_cart,
                    color: Colors.lightBlue[900]),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 80,
          ),
          InkWell(
             onTap: () {
                  Scaffold.of(cont).openEndDrawer();
                },
                      child: Badge(
              badgeContent: Text(
               notifNum==0||notifNum==null?"": notifNum.toString(),
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              position: BadgePosition.topLeft(),
              badgeColor: Colors.deepOrange,
              child: 
                 Icon(Icons.menu, color: Colors.lightBlue[900]),
               
              
            ),
          ),
        ],
      ),
    );
  }
}