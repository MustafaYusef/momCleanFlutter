import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/blocs/OrdersBloc.dart';
import 'package:mom_clean/models/normalOrderDetails.dart';
import 'package:mom_clean/models/packageOrdersDetails.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:mom_clean/ui/auth/profile.dart';
import 'package:mom_clean/ui/ordersScreen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'custumWidget/customDrawer.dart';

class OrderDetailsScreen extends StatefulWidget {
  int id;
  String type;
  String status;
  OrderDetailsScreen(this.id, this.type, this.status);

  @override
  _OrderDetailsScreenState createState() => new _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
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
        endDrawer: drawar(
          index: 5,
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: AppBar(
            iconTheme: IconThemeData(
              color: Theme.of(context).primaryColor, //change your color here
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        body: BlocProvider(create: (context) {
          if (widget.type == "items") {
            return OrdersBloc(Repo: MainRepastory())
              ..add(FetchOrdersDetails(widget.id));
          } else {
            return OrdersBloc(Repo: MainRepastory())
              ..add(FetchPackageOrdersDetails(widget.id));
          }
        }, child:
            BlocBuilder<OrdersBloc, OrdersState>(builder: (context, state) {
          if (state is OrdersLoading) {
            return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(child: circularProgress()));
          }
          if (state is OrdersLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        "تفاصيل الطلب",
                        style: TextStyle(color: Colors.grey[900], fontSize: 24),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        "تاريخ الأستلام: " + state.orders.data.order.receivedAt,
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                      )),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Expanded(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return buildCard(
                            state.orders.data.order.orderItmes[index]);
                      },
                      itemCount: state.orders.data.order.orderItmes.length,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: widget.status != "watting"
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: RaisedButton(
                              color: Colors.red,
                              elevation: 5,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text("ألغاء الطلب",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String token = await prefs.getString('token');
                                showAlert(context, widget.id, token, false);
                              },
                            ),
                          ),
                        ),
                ),
              ],
            );
          }
          if (state is OrdersPackageLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        "تفاصيل الطلب",
                        style: TextStyle(color: Colors.grey[900], fontSize: 24),
                      )),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Directionality(
                //       textDirection: TextDirection.rtl,
                //       child: Text(
                //         "تاريخ الأستلام: "+state.orders.data.orderItems. .receivedAt,
                //         style: TextStyle(color: Colors.grey[800], fontSize: 14),
                //       )),
                // ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Expanded(
                    child: ListView.builder(
                      primary: true,
                      itemBuilder: (BuildContext context, int index) {
                        return buildCardPackage(
                            state.orders.data.orderItems[index]);
                      },
                      itemCount: state.orders.data.orderItems.length,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: widget.status != "watting"
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: RaisedButton(
                              color: Colors.red,
                              elevation: 5,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text("ألغاء الطلب",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String token = await prefs.getString('token');
                                showAlert(context, widget.id, token, true);
                              },
                            ),
                          ),
                        ),
                ),
              ],
            );
          }
          if (state is OrdersNetworkError) {
            return networkError("لا يوجد اتصال بالشبكة");
          }
          if (state is OrdersError) {
            return networkError(state.msg);
          }
        })));
  }

  Widget buildCard(OrderItme item) {
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
                          borderRadius: BorderRadius.circular(20),
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
                        child:CachedNetworkImage(
                  fit: BoxFit.cover,
               
                  imageUrl: baseUrlImage +item.item.photo,
                  placeholder: (context, url) =>
                      Image.asset("assets/images/placeholder.png"),
                  errorWidget: (context, url, error) =>
                      Image.asset("assets/images/placeholder.png"),
                )
                         )),
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

  Widget buildCardPackage(OrderItem item) {
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
                          borderRadius: BorderRadius.circular(20),
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
                        child:CachedNetworkImage(
                  fit: BoxFit.cover,
             
                  imageUrl: baseUrlImage +item.item.photo,
                  placeholder: (context, url) =>
                      Image.asset("assets/images/placeholder.png"),
                  errorWidget: (context, url, error) =>
                      Image.asset("assets/images/placeholder.png"),
                )
                      )),
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

  showAlert(BuildContext context1, int id, String token, bool flage) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromBottom,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 300),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
    );
    Alert(
      context: context,
      type: AlertType.warning,
      title: "هل تريد الغاء هذا الطلب",
      desc: "",
      style: alertStyle,
      buttons: [
        DialogButton(
          child: Text(
            "خروج",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.red,
          // gradient: LinearGradient(colors: [
          //   Color.fromRGBO(116, 116, 191, 1.0),
          //   Color.fromRGBO(52, 138, 199, 1.0)
          // ]),
        ),
        DialogButton(
          child: Text(
            "تأكيد",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            MainRepastory repo = MainRepastory();
            try {
              if (flage) {
                await repo.cancelPackageOrder(token, widget.id);
                Navigator.pop(context1);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
                  return OrderScreen();
                }));
              } else {
                await repo.cancelNormalOrder(token, widget.id);
                Navigator.pop(context1);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
                  return OrderScreen();
                }));
              }

              Toast.show("تم الغاء الطلب بنجاح", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            } on SocketException catch (_) {
              Navigator.pop(context1);

              Toast.show("لا يوجداتصال", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            } catch (_) {
              Navigator.pop(context1);
              Toast.show("حدث خطأ ما ", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            }
          },
          color: Theme.of(context).primaryColor,
        ),
      ],
    ).show();
  }
}
