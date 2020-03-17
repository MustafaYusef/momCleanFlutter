import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/blocs/homeBloc.dart';
import 'package:mom_clean/models/myRequest.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:mom_clean/ui/auth/profile.dart';
import 'package:mom_clean/ui/packageDetails.dart';
import 'package:mom_clean/ui/packagesScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custumWidget/customDrawer.dart';
import 'custumWidget/custumAppBar.dart';

class MyRequestScreen extends StatefulWidget {
  @override
  _MyRequestScreenState createState() => new _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  Color cancelRed = Color(0xffC50F0F);
  Color green = Color(0xff169E23);
  Color yello = Color(0xffFFA200);

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
      backgroundColor: Colors.grey[200],
      endDrawer: drawar(
        index: 6,
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
              "طلبات الأشتراك بالباقات",
              style: TextStyle(fontSize: 18, color: Colors.black),
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
                      ..add(FetchRequests());
                  },
                  child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                    if (state is HomeLoading) {
                      return Center(
                        child: Container(
                            width: 40, height: 40, child: circularProgress()),
                      );
                    }
                    if (state is RequestsLoaded) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 10, bottom: 5),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Directionality(
                                        child: Text(
                                          "طلبات الباقات",
                                          style: TextStyle(
                                              fontSize: 26,
                                              color: Colors.grey[800]),
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
                                          state.requests.data.myRequest.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return packageDetails(state
                                                  .requests
                                                  .data
                                                  .myRequest[index]
                                                  .package
                                                  .id,true);
                                            }));
                                          },
                                          child: packageCard(state
                                              .requests.data.myRequest[index]),
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

  Widget packageCard(MyRequest pack) {
    var baseUrlImage = "https://api.maamclean.com/files/";
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
                image: NetworkImage(baseUrlImage + pack.package.file),
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
                            color: getColorStatus(pack.status),
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Directionality(
                          child: Text(
                            getStateusRequest(pack.status),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Directionality(
                          child: Text(
                            pack.package.nameAr,
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
                                    pack.package.price.toString() +
                                    " " +
                                    pack.package.currency,
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
                                "عدد الأيام: " + pack.package.days.toString(),
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
                                "عدد الزيارات: " +
                                    pack.package.visitsCount.toString(),
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

  String getStateusRequest(Status status) {
    if (status == Status.ACCEPTED) {
      return "تم القبول";
    } else if (status == Status.PANDING) {
      return "أنتضار";
    } else if (status == Status.CANCELLED) {
      return "مرفوض";
    }
  }

  Color getColorStatus(Status status) {
    if (status == Status.ACCEPTED) {
      return green;
    } else if (status == Status.PANDING) {
      return yello;
    } else if (status == Status.CANCELLED) {
      return cancelRed;
    }
  }
}
