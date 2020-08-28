import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/blocs/homeBloc.dart';
import 'package:mom_clean/main.dart';
import 'package:mom_clean/models/packagesRes.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:mom_clean/ui/packageDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/profile.dart';
import 'custumWidget/customDrawer.dart';
import 'custumWidget/custumAppBar.dart';

class packageScreen extends StatefulWidget {
  @override
  _packageScreenState createState() => new _packageScreenState();
}

class _packageScreenState extends State<packageScreen> {
  int notifNum = 0;
  int cartNum = 0;

  @override
  initState() {
    super.initState();
    getNum();
  }

  getNum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notifNum = prefs.getInt('notification');
      cartNum = prefs.getInt('cart');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: drawar(index: 2),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
          elevation: 0,
          centerTitle: true,
          title: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              "الأشتراكات",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ),
      ),
      body: Builder(builder: (cont) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: BlocProvider(
                  create: (context) {
                    return HomeBloc(Repo: MainRepastory())
                      ..add(FetchAllPackages());
                  },
                  child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                    if (state is HomeLoading) {
                      return Center(
                        child: Container(
                            width: 40, height: 40, child: circularProgress()),
                      );
                    }
                    if (state is AllPackagesLoaded) {
                      if (state.packages.data.packages.length == 0) {
                        return Center(
                          child: Container(
                              child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                    "لا يوجد باقات",
                                    style: TextStyle(fontSize: 24),
                                  ))),
                        );
                      } else {
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: 10, bottom: 5),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Directionality(
                                          child: Text(
                                            "أحدث الباقات",
                                            style: TextStyle(
                                                fontSize: 26,
                                                color: Colors.grey[800]),
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                        Directionality(
                                          child: Text(
                                            "تكدر تشترك بالباقة اللي تناسبك",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600]),
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        primary: false,
                                        itemCount:
                                            state.packages.data.packages.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (_) {
                                                return packageDetails(state
                                                    .packages
                                                    .data
                                                    .packages[index]
                                                    .id);
                                              }));
                                            },
                                            child: packageCard(state
                                                .packages.data.packages[index]),
                                          );
                                        },
                                      )),
                                ]),
                          ),
                        );
                      }
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

  Widget packageCard(Package pack) {
    return Container(
        margin: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 240,
                  imageUrl: baseUrlImage + pack.file,
                  placeholder: (context, url) =>
                      Image.asset("assets/images/placeholder.png"),
                  errorWidget: (context, url, error) =>
                      Image.asset("assets/images/placeholder.png"),
                )),
            Container(
              height: 240,
              padding: EdgeInsets.only(right: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(5),
                        child: Directionality(
                          child: Text(
                            pack.nameAr,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Icon(
                            Icons.monetization_on,
                            color: Colors.white,
                          ),
                          Directionality(
                            child: Text(
                                "السعر: " +
                                    pack.price.toString() +
                                    " " +
                                    pack.currency,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(
                            Icons.date_range,
                            color: Colors.white,
                          ),
                          Directionality(
                            child: Text("عدد الأيام: " + pack.days.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(
                            Icons.visibility,
                            color: Colors.white,
                          ),
                          Directionality(
                            child: Text(
                                "عدد الزيارات: " + pack.visitsCount.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [
                        0.15,
                        0.8
                      ],
                      colors: [
                        Colors.black26.withOpacity(0.7),
                        Colors.transparent
                      ])),
            ),
          ],
        ));
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
