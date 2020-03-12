import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mom_clean/ui/MypackageScreen.dart';
import 'package:mom_clean/ui/auth/logInScreen.dart';
import 'package:mom_clean/ui/packagesScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custumWidget/customDrawer.dart';
import 'custumWidget/custumAppBar.dart';

class packAndMyPackageScreen extends StatefulWidget {
  @override
  _packAndMyPackageScreenState createState() => _packAndMyPackageScreenState();
}

class _packAndMyPackageScreenState extends State<packAndMyPackageScreen> {
      int notifNum=0;
  int cartNum=0;

@override
   initState()  {
    super.initState();
   //  getNum();
  }

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      endDrawer: drawar(index: 0,),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              "أختر من الباقات",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ),
      ),
      body: Builder(builder: (cont) {
        return Column(
          children: <Widget>[
            Stack(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 69,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        "assets/images/www.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        "assets/images/wwsw.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 69,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [
                      0.1,
                      0.6
                    ],
                        colors: [
                      Colors.black26.withOpacity(0.7),
                      Colors.transparent
                    ])),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 69,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return packageScreen();
                            }));
                          },
                          child: Container()),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var token = await prefs.getString('token');
                            if (token == null || token == "") {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return LoginScreen();
                              }));
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return MypackageScreen();
                              }));
                            }
                          },
                          child: Container()),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  "تصفح الباقات",
                                  style: TextStyle(
                                      fontSize: 26, color: Colors.grey[800]),
                                ),
                              ),
                            ),
                            Center(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  "تصفح واختار جديدنا",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[800]),
                                ),
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  "باقاتي",
                                  style: TextStyle(
                                      fontSize: 26, color: Colors.grey[800]),
                                ),
                              ),
                            ),
                            Center(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  "أختار من باقاتك",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[800]),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              )
            ]),
          ],
        );
      }),
    );
  }
}
