import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:mom_clean/main.dart';
import 'package:mom_clean/ui/MyCartScreen.dart';
import 'package:mom_clean/ui/MyNotification.dart';
import 'package:mom_clean/ui/MypackageScreen.dart';
import 'package:mom_clean/ui/auth/logInScreen.dart';
import 'package:mom_clean/ui/auth/profile.dart';
import 'package:mom_clean/ui/auth/updatePhoto.dart';
import 'package:mom_clean/ui/packagesScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MyRequestScreen.dart';
import '../category.dart';
import '../ordersScreen.dart';

class drawar extends StatefulWidget {
  int index;
  // int notifNum=0;
  //  int cartNum=0;
  drawar({Key key, @required this.index}) : super(key: key);

  @override
  _drawarState createState() => _drawarState();
}

class _drawarState extends State<drawar> {
  String name = "";

  String image = "";

  int notifNum = 0;
  int cartNum = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
  }

  getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      image = prefs.getString('image');
      name = prefs.getString('name');
      notifNum = prefs.getInt('notification');
      cartNum = prefs.getInt('cart');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (cont) {
      return Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              height: 160,
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // CircleAvatar(
                    //   radius: 40,
                    //   backgroundImage: NetworkImage(
                    //       image == null ? " " : baseUrlImage + image),
                    // ),
                    Container(
                      margin: EdgeInsets.only(right: 5, top: 5),
                      child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            name == null ? "أسم المستخدم" : name,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[900],
                  image: DecorationImage(
                      image: AssetImage("assets/images/placeholder.png"),
                      fit: BoxFit.contain),
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                onTap: () {
                  Scaffold.of(cont).openDrawer();
                  if (widget.index == 0) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) {
                      return MainScreen();
                    }));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return MainScreen();
                    }));
                  }
                },
                selected: widget.index == 0 ? true : false,
                title: Text("الرئيسية", style: TextStyle(fontSize: 16)),
                leading: Icon(Icons.home),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String token = await prefs.getString("token");
                  Scaffold.of(cont).openDrawer();
                  if (widget.index == 1) {
                    if (token == null || token == "") {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) {
                        return LoginScreen();
                      }));
                    } else {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) {
                        return MyNotificationScreen();
                      }));
                    }
                  } else {
                    if (token == null || token == "") {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return LoginScreen();
                      }));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return MyNotificationScreen();
                      }));
                    }
                  }
                },
                selected: widget.index == 1 ? true : false,
                title: Text("الأشعارات", style: TextStyle(fontSize: 16)),
                leading: Container(
                  child: notifNum == 0 || notifNum == null
                      ? Icon(Icons.notifications)
                      : Badge(
                          badgeContent: Text(
                            notifNum == 0 || notifNum == null
                                ? ""
                                : notifNum.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          badgeColor: Colors.deepOrange,
                          child: Icon(Icons.notifications)),
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                onTap: () {
                  Scaffold.of(cont).openDrawer();
                  if (widget.index == 2) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) {
                      return packageScreen();
                    }));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return packageScreen();
                    }));
                  }
                },
                selected: widget.index == 2 ? true : false,
                title: Text("الباقات", style: TextStyle(fontSize: 16)),
                leading: Icon(Icons.local_offer),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                onTap: () {
                  Scaffold.of(cont).openDrawer();
                  if (widget.index == 3) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) {
                      return categoty();
                    }));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return categoty();
                    }));
                  }
                },
                selected: widget.index == 3 ? true : false,
                title: Text(
                  "الأقسام",
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(Icons.category),
              ),
            ),
            Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  onTap: () {
                    Scaffold.of(cont).openDrawer();
                    if (widget.index == 4) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) {
                        return MypackageScreen();
                      }));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return MypackageScreen();
                      }));
                    }
                  },
                  selected: widget.index == 4 ? true : false,
                  title: Text("باقاتي", style: TextStyle(fontSize: 16)),
                  leading: Icon(
                    Icons.card_giftcard,
                  ),
                )),
            Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  onTap: () {
                    Scaffold.of(cont).openDrawer();
                    if (widget.index == 5) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) {
                        return OrderScreen();
                      }));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return OrderScreen();
                      }));
                    }
                  },
                  selected: widget.index == 5 ? true : false,
                  title: Text("طلباتي", style: TextStyle(fontSize: 16)),
                  leading: Icon(
                    Icons.card_travel,
                  ),
                )),
            Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  onTap: () {
                    Scaffold.of(cont).openDrawer();
                    if (widget.index == 6) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) {
                        return MyRequestScreen();
                      }));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return MyRequestScreen();
                      }));
                    }
                  },
                  selected: widget.index == 6 ? true : false,
                  title: Text("طلبات الأشتراك بالباقات",
                      style: TextStyle(fontSize: 16)),
                  leading: Icon(Icons.playlist_add_check),
                )),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String token = await prefs.getString("token");

                  Scaffold.of(cont).openDrawer();
                  if (widget.index == 7) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) {
                      if (token == null || token == "") {
                        return LoginScreen();
                      } else {
                        return MyCartScreen();
                      }
                    }));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      if (token == null || token == "") {
                        return LoginScreen();
                      } else {
                        return MyCartScreen();
                      }
                    }));
                  }
                },
                selected: widget.index == 7 ? true : false,
                title: Text("سلة المشتريات", style: TextStyle(fontSize: 16)),
                leading: Container(
                  child: cartNum == 0 || cartNum == null
                      ? Icon(Icons.shopping_cart)
                      : Badge(
                          badgeContent: Text(
                            cartNum == 0 || cartNum == null
                                ? ""
                                : cartNum.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          badgeColor: Colors.deepOrange,
                          child: Icon(Icons.shopping_cart)),
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String token = await prefs.getString("token");

                  Scaffold.of(cont).openDrawer();
                  if (widget.index == 8) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) {
                      if (token == null || token == "") {
                        return LoginScreen();
                      } else {
                        return ProfileScreen();
                      }
                    }));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      if (token == null || token == "") {
                        return LoginScreen();
                      } else {
                        return ProfileScreen();
                      }
                    }));
                  }
                },
                selected: widget.index == 8 ? true : false,
                title: Text("الأعدادات", style: TextStyle(fontSize: 16)),
                leading: Icon(Icons.settings),
              ),
            ),
          ],
        ),
      );
    });
  }
}
