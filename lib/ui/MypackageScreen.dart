import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/blocs/homeBloc.dart';
import 'package:mom_clean/main.dart';
import 'package:mom_clean/models/myPackageRes.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:mom_clean/ui/MypackageDetails.dart';
import 'package:mom_clean/ui/auth/profile.dart';
import 'package:mom_clean/ui/ordersScreen.dart';
import 'package:mom_clean/ui/packageDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'custumWidget/customDrawer.dart';
import 'custumWidget/custumAppBar.dart';

class MypackageScreen extends StatefulWidget {
  @override
  _MypackageScreenState createState() => new _MypackageScreenState();
}

class _MypackageScreenState extends State<MypackageScreen> {
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
      endDrawer: drawar(
        index: 4,
    
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
          backgroundColor: Colors.grey[200],
          elevation: 0,
          centerTitle: true,
          title: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              "باقاتي",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Builder(builder: (cont) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: BlocProvider(
                  create: (context) {
                    return HomeBloc(Repo: MainRepastory())
                      ..add(FetchMyPackages());
                  },
                  child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                    if (state is HomeLoading) {
                      return Center(
                        child: Container(
                            width: 40, height: 40, child: circularProgress()),
                      );
                    }
                    if (state is MyPackageLoaded) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: state.myPackage == null
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height - 100,
                                child: Center(
                                  child: Directionality(
                                    child: Text(
                                      "لا يوجد لديك باقات",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[800]),
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              )
                            : Container(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 10, bottom: 5),
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                            itemCount: state
                                                .myPackage.data.packages.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return InkWell(
                                                onTap: () {
                                                  if(state
                                                .myPackage.data.packages[index].sameArea&&
                                                state
                                                .myPackage.data.packages[index].isActive){
Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (_) {
                                                    return MypackageDetails(
                                                        state
                                                            .myPackage
                                                            .data
                                                            .packages[index]
                                                            .userPackageId,
                                                        state
                                                            .myPackage
                                                            .data
                                                            .packages[index]
                                                            .packageDetails
                                                            .nameAr,
                                                        state
                                                            .myPackage
                                                            .data
                                                            .packages[index]
                                                            .packageDetails
                                                            .descriptionAr);
                                                  }));
                                                  }else{
                                                Toast.show("هذه الباقة منتهية الصلاحية او غير فعالة", context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                                                  }
                                                  
                                                },
                                                child: packageCard(state
                                                    .myPackage
                                                    .data
                                                    .packages[index]),
                                              );
                                            },
                                          )),
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

  Widget packageCard(myPackage pack) {
    return Container(
        margin: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                placeholder: AssetImage("assets/images/placeholder.png"),
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: 240,
                image: NetworkImage(baseUrlImage + pack.packageDetails.file),
              ),
            ),
            Container(
              height: 240,
              padding: EdgeInsets.only(right: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: getColor(pack.isActive, pack.sameArea),
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Directionality(
                          child: Text(
                            getStatus(pack.isActive, pack.sameArea),
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(5),
                        child: Directionality(
                          child: Text(
                            pack.packageDetails.nameAr,
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
                                    pack.packageDetails.price.toString() +
                                    " " +
                                    pack.packageDetails.currency,
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
                            child: Text(
                                "عدد الأيام: " +
                                    pack.packageDetails.days.toString(),
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

  String getStatus(bool isActive, bool sameArea) {
    if (isActive && sameArea) {
      return "فعال";
    } else if (isActive && !sameArea) {
      return "غير فعال";
    } else {
      return "منتهي الصلاحية";
    }
  }

  Color getColor(bool isActive, bool sameArea) {
    Color cancelRed = Color(0xffC50F0F);
    Color green = Color(0xff169E23);
    Color yello = Color(0xffFFA200);
    if (isActive && sameArea) {
      return green;
    } else if (isActive && !sameArea) {
      return yello;
    } else {
      return cancelRed;
    }
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
