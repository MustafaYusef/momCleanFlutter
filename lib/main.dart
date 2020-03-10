import 'dart:async';

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/blocs/homeBloc.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:mom_clean/ui/auth/profile.dart';
import 'package:mom_clean/ui/category.dart';
import 'package:mom_clean/ui/custumWidget/customDrawer.dart';
import 'package:mom_clean/ui/custumWidget/custumAppBar.dart';
import 'package:mom_clean/ui/custumWidget/latestOrder.dart';
import 'package:mom_clean/ui/custumWidget/sliderSection.dart';
import 'package:mom_clean/ui/mapScreen.dart';
import 'package:mom_clean/ui/ordersScreen.dart';
import 'package:mom_clean/ui/packAndMyPackageScreen.dart';
import 'package:mom_clean/ui/packagesScreen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


// For each of the above functions, you can also pass in a
// reference to a function as well:
var baseUrlImage = "https://api.maamclean.com/files/";

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: "Regular",
      primaryColor: Color(0xff3C74C8),
      accentColor: Color(0xFFCA3D),
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return MainScreen();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Image.asset(
          "assets/images/placeholder.png",
          width: 300,
          height: 300,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _current = 0;

  int notifNum=0;
  int cartNum=0;
@override
   initState()  {
    super.initState();
     getNum();
  }
     getNum() async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          notifNum =  prefs.getInt('notification');
     cartNum =  prefs.getInt('cart');
        });
     
 }
  @override
  Widget build(BuildContext context) {
    OneSignal.shared.init("5f0a5368-692a-48b4-8420-95fae35c1ef6", iOSSettings: {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.inAppLaunchUrl: true
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    //OneSignal.shared.promptUserForPushNotificationPermission();
    Future<String> getuserId() async {
      var status = await OneSignal.shared.getPermissionSubscriptionState();
      var playerId = status.subscriptionStatus.userId;
      print("plyer id  " + playerId.toString());
      return playerId;
    }

    var playerId = getuserId();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Colors.lightBlue[900], //or set color with: Color(0xFF0000FF)
    ));
   
    return Scaffold(
      backgroundColor: Colors.grey[200],
      endDrawer: drawar(index: 0,notifNum:notifNum,cartNum:cartNum),
      body: Builder(builder: (cont) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              myAppBar(cont: cont,notifNum:notifNum,cart:cartNum),
              Expanded(
                child: BlocProvider(
                  create: (context) {
                    return HomeBloc(Repo: MainRepastory())..add(FetchHome());
                  },
                  child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                    if (state is HomeLoading) {
                      return Center(
                        child: Container(
                            width: 40, height: 40, child: circularProgress()),
                      );
                    }
                    if (state is HomeLoaded) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  margin:
                                      EdgeInsets.only(right: 10, bottom: 10),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Directionality(
                                        child: Text(
                                          "الباقات",
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.grey[800]),
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                      Directionality(
                                        child: Text(
                                            "تكدر تختار الباقة اللي تعجبك",
                                            style: TextStyle(
                                                color: Colors.grey[800])),
                                        textDirection: TextDirection.rtl,
                                      )
                                    ],
                                  ),
                                ),
                                sliderSection(
                                    packages: state.package.data.banner,
                                    current: _current),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Directionality(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "أطلب هسه",
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return packAndMyPackageScreen();
                                            }));
                                          },
                                          child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Directionality(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                          width: 50,
                                                          height: 50,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .greenAccent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                              gradient:
                                                                  LinearGradient(
                                                                      begin: Alignment
                                                                          .bottomCenter,
                                                                      end: Alignment.topCenter,
                                                                      stops: [
                                                                    0.15,
                                                                    1.0
                                                                  ],
                                                                      colors: [
                                                                    Color(
                                                                        0xff2A815B),
                                                                    Color(
                                                                        0xff35D289)
                                                                  ])),
                                                          child: Icon(
                                                            Icons.local_offer,
                                                            color: Colors.white,
                                                          )),
                                                      Text(
                                                        "خليها \nعلى باقتك",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                textDirection:
                                                    TextDirection.rtl,
                                              )),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return categoty();
                                            }));
                                          },
                                          child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Directionality(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                          width: 50,
                                                          height: 50,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .greenAccent,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  gradient: LinearGradient(
                                                                      begin: Alignment
                                                                          .bottomCenter,
                                                                      end: Alignment
                                                                          .topCenter,
                                                                      stops: [
                                                                        0.15,
                                                                        1.0
                                                                      ],
                                                                      colors: [
                                                                        Color(
                                                                            0xff063051),
                                                                        Color(
                                                                            0xff35D2CD),
                                                                      ])),
                                                          child: Icon(
                                                            Icons.local_atm,
                                                            color: Colors.white,
                                                          )),
                                                      Text(
                                                        "نحاسبك \nعلى القطعة",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                textDirection:
                                                    TextDirection.rtl,
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Directionality(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return OrderScreen();
                                            }));
                                          },
                                          child: Text("عرض الكل",
                                              style: TextStyle(
                                                  color: Colors.deepOrange,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                      Directionality(
                                        child: Text("أخر الطلبات",
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold)),
                                        textDirection: TextDirection.rtl,
                                      )
                                    ],
                                  ),
                                ),
                                latestOrder(state.orders)
                              ]),
                        ),
                      );
                    }
                    if (state is HomeNetworkError) {
                      return networkErrorHome("لا يوجد اتصال");
                    }
                    if (state is HomeError) {
                      return networkErrorHome(state.msg);
                    }
                  }),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

class networkErrorHome extends StatelessWidget {
  String msg;
  networkErrorHome(
    this.msg, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/no_wifi.png",
            width: 150,
          ),
          Text(msg),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.only(top: 10, bottom: 20, left: 60, right: 60),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  elevation: 5,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text("اعادة المحاوله",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                  onPressed: () {
                    BlocProvider.of<HomeBloc>(context).add(FetchHome());
                  }),
            ),
          ),
        ],
      ),
    ));
  }
}
