import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/blocs/packageBloc.dart';
import 'package:mom_clean/models/packagesItemsRes.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:mom_clean/ui/MyRequestScreen.dart';
import 'package:mom_clean/ui/auth/logInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'auth/profile.dart';
import 'custumWidget/customDrawer.dart';

class packageDetails extends StatefulWidget {
  int id;
  packageDetails(this.id);

  @override
  _packageDetailsState createState() => new _packageDetailsState();
}

class _packageDetailsState extends State<packageDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       endDrawer: drawar(index: 2),
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
            child: Text("تفاصيل الأشتراك",style: TextStyle(fontSize: 20,color: Colors.black),),
          ),
          
        ),
      ),
        body: BlocProvider(create: (context) {
          return PackageBloc(Repo: MainRepastory())
            ..add(FetchPackageDetails(widget.id));
        }, child:
            BlocBuilder<PackageBloc, PackageState>(builder: (context1, state) {
          if (state is PackageLoading) {
            return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(child: circularProgress()));
          }
          if (state is PackageDetailsLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        state.package.data.packageItems.nameAr,
                        style: TextStyle(color: Colors.grey[900], fontSize: 24),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        state.package.data.packageItems.descriptionAr,
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                      )),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                      primary: false,
                      itemBuilder: (BuildContext context, int index) {
                        return buildCard(state
                            .package.data.packageItems.packageItems[index]);
                      },
                      itemCount:
                          state.package.data.packageItems.packageItems.length,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      elevation: 5,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text("أشترك هسة",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String token = await prefs.getString('token');
                        if (token == null || token == "") {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return LoginScreen();
                          }));
                        } else {
                          showDialog(
                              context: context1,
                              builder: (BuildContext context) {
                                return BuyPackageAlert(
                                    context1, token, widget.id);
                              });
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          if (state is PackageBuySuccessfully) {
            //       Toast.show(state.msg, context,
            // duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

            return Center(
                child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    state.msg,
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.only(
                        top: 10, bottom: 20, left: 60, right: 60),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          elevation: 5,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text("مشاهدة طلب الشراء",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return MyRequestScreen();
                            }));
                          }),
                    ),
                  ),
                ],
              ),
            ));
            // Navigator.push(context,
            //                 MaterialPageRoute(builder: (_) {
            //               return MyRequestScreen();
            //             }));
          }

          if (state is PackageNetworkError) {
            return networkError("لا يوجد اتصال بالشبكة");
          }
          if (state is PackageError) {
            return networkError(state.msg);
          }
        })));
  }

  Widget buildCard(PackageItem item) {
    var baseUrlImage = "https://api.maamclean.com/files/";
    return Container(
      margin: EdgeInsets.all(10),
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                              stops: [0.15, 1.0],
                              colors: [Color(0xff063051), Color(0xff35D2CD)])),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                    ),
                    flex: 1,
                  )
                ],
              ),
              Container(
                child: Center(
                    child: Container(
                        width: 130,
                        height: double.infinity,
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            baseUrlImage + item.item.photo,
                          ),
                          placeholder:
                              AssetImage("assets/images/placeholder.png"),
                        ))),
              ),
              Positioned(
                width: 100,
                right: 0,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            item.item.nameAr,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          )),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: Container(
                        height: 50,
                        width: 30,
                        color: Color(0xffFFA200),
                        child: Column(
                          children: <Widget>[
                            Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  "عدد",
                                  style: TextStyle(color: Colors.white),
                                )),
                            Text(
                              item.count.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget BuyPackageAlert(BuildContext context1, String token, int id) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          width: 500,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "شراء هذه الباقة",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey[900],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin:
                    EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                width: MediaQuery.of(context1).size.width,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: RaisedButton(
                    color: Colors.amber[300],
                    elevation: 5,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text("تأكيد",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                    onPressed: () {
                      //print("clicked");
                      Navigator.pop(context1);
                      BlocProvider.of<PackageBloc>(context1)
                          .add(BuyPackageEvent(id, token));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
