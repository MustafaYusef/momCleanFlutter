import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/blocs/CartBloc.dart';
import 'package:mom_clean/models/categoryItemsRes.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:mom_clean/ui/MyCartScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../main.dart';
import 'auth/profile.dart';

class AddToCartScreen extends StatefulWidget {
  final Item item;
  AddToCartScreen(this.item);

  @override
  _AddToCartScreenState createState() => new _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  int dishWachNum = 0;
  int wachNum = 0;
  int totalPrice = 0;


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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15, top: 10),
              child: Badge(
                badgeContent: Text(
                  cartNum==0||cartNum==null?"":cartNum.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                badgeColor: Colors.deepOrange,
                child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return MyCartScreen();
                      }));
                    },
                    child: Icon(Icons.shopping_cart,
                        color: Colors.lightBlue[900])),
              ),
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) {
          return CartBloc(Repo: MainRepastory());
        },
        child: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
          if (state is CartLoading) {
            return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(child: circularProgress()));
          }
          if (state is CartUninitial) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildCardOnce(widget.item),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: RaisedButton(
                              color: Color(0xffCE4B4B),
                              elevation: 5,
                              child: Text("-",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 34,
                                      fontFamily: "")),
                              onPressed: () {
                                setState(() {
                                  if (dishWachNum != 0) {
                                    dishWachNum--;
                                    totalPrice =
                                        (widget.item.dwPrice * dishWachNum) +
                                            (widget.item.washPrice * wachNum);
                                  }
                                });
                              }),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: RaisedButton(
                              color: Color(0xff063051),
                              elevation: 5,
                              child: Text("+",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontFamily: "")),
                              onPressed: () {
                                setState(() {
                                  dishWachNum++;
                                  totalPrice =
                                      (widget.item.dwPrice * dishWachNum) +
                                          (widget.item.washPrice * wachNum);
                                });
                              }),
                        ),
                      ),
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                           widget.item.washPrice==0?"غسل": "غسل وكوي",
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[800]),
                          )),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: RaisedButton(
                              color: Color(0xff7DADB2),
                              elevation: 5,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(dishWachNum.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24)),
                              ),
                              onPressed: () {}),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                                      child:widget.item.washPrice==0?
                                      Container():
                                       Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: RaisedButton(
                                color: Color(0xffCE4B4B),
                                elevation: 5,
                                child: Text("-",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 34,
                                        fontFamily: "")),
                                onPressed: () {
                                  setState(() {
                                    if (wachNum != 0) {
                                      wachNum--;
                                      totalPrice =
                                          (widget.item.dwPrice * dishWachNum) +
                                              (widget.item.washPrice * wachNum);
                                    }
                                  });
                                }),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: RaisedButton(
                                color: Color(0xff063051),
                                elevation: 5,
                                child: Text("+",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontFamily: "")),
                                onPressed: () {
                                  setState(() {
                                    wachNum++;
                                    totalPrice =
                                        (widget.item.dwPrice * dishWachNum) +
                                            (widget.item.washPrice * wachNum);
                                  });
                                }),
                          ),
                        ),
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              "بس كوي",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[800]),
                            )),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 70,
                          height: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: RaisedButton(
                                color: Color(0xff7DADB2),
                                elevation: 5,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(wachNum.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24)),
                                ),
                                onPressed: () {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: totalPrice.toString(),
                            style: TextStyle(
                                color: Color(0xFFFFA200), fontSize: 20),
                            children: [
                              TextSpan(
                                  text: widget.item.currency.toString(),
                                  style: TextStyle(
                                      color: Color(0xFFFFA200),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))
                            ]),
                      ),
                      Text("السعر الكلي",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 26)),
                    ],
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: RaisedButton(
                          color: Color(0xff2498A1),
                          elevation: 5,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text("خليها بالسلة",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24)),
                          ),
                          onPressed: () async{
                            if (wachNum == 0 && dishWachNum == 0) {
                              Toast.show("حدد العدد الذي تريده", context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            } else {
                              int status;
                              if (wachNum != 0 && dishWachNum == 0) {
                                status = 1;
                              } else if (wachNum == 0 && dishWachNum != 0) {
                                status = 2;
                              } else if (wachNum != 0 && dishWachNum != 0) {
                                status = 3;
                              }
                             await BlocProvider.of<CartBloc>(context).add(
                                  AddItemToCart(
                                      item_id: widget.item.id,
                                      countWach: wachNum,
                                      countdryWash: dishWachNum,
                                      status: status));
                                       Toast.show("تمت الأضافة الى السلة", context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
//                                        Navigator.push(context, MaterialPageRoute(builder: (_) {
//                        return MyCartScreen();
//                      }));
                            }
                          }),
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is ItemAddedSuccusfully) {
           
     return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildCardOnce(widget.item),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: RaisedButton(
                              color: Color(0xffCE4B4B),
                              elevation: 5,
                              child: Text("-",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 34,
                                      fontFamily: "")),
                              onPressed: () {
                                setState(() {
                                  if (dishWachNum != 0) {
                                    dishWachNum--;
                                    totalPrice =
                                        (widget.item.dwPrice * dishWachNum) +
                                            (widget.item.washPrice * wachNum);
                                  }
                                });
                              }),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: RaisedButton(
                              color: Color(0xff063051),
                              elevation: 5,
                              child: Text("+",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontFamily: "")),
                              onPressed: () {
                                setState(() {
                                  dishWachNum++;
                                  totalPrice =
                                      (widget.item.dwPrice * dishWachNum) +
                                          (widget.item.washPrice * wachNum);
                                });
                              }),
                        ),
                      ),
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                           widget.item.washPrice==0?"غسل": "غسل وكوي",
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[800]),
                          )),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: RaisedButton(
                              color: Color(0xff7DADB2),
                              elevation: 5,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(dishWachNum.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24)),
                              ),
                              onPressed: () {}),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                                      child:widget.item.washPrice==0?
                                      Container():
                                       Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: RaisedButton(
                                color: Color(0xffCE4B4B),
                                elevation: 5,
                                child: Text("-",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 34,
                                        fontFamily: "")),
                                onPressed: () {
                                  setState(() {
                                    if (wachNum != 0) {
                                      wachNum--;
                                      totalPrice =
                                          (widget.item.dwPrice * dishWachNum) +
                                              (widget.item.washPrice * wachNum);
                                    }
                                  });
                                }),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: RaisedButton(
                                color: Color(0xff063051),
                                elevation: 5,
                                child: Text("+",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontFamily: "")),
                                onPressed: () {
                                  setState(() {
                                    wachNum++;
                                    totalPrice =
                                        (widget.item.dwPrice * dishWachNum) +
                                            (widget.item.washPrice * wachNum);
                                  });
                                }),
                          ),
                        ),
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              "بس كوي",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[800]),
                            )),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 70,
                          height: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: RaisedButton(
                                color: Color(0xff7DADB2),
                                elevation: 5,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(wachNum.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24)),
                                ),
                                onPressed: () {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: totalPrice.toString(),
                            style: TextStyle(
                                color: Color(0xFFFFA200), fontSize: 20),
                            children: [
                              TextSpan(
                                  text: widget.item.currency.toString(),
                                  style: TextStyle(
                                      color: Color(0xFFFFA200),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))
                            ]),
                      ),
                      Text("السعر الكلي",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 26)),
                    ],
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: RaisedButton(
                          color: Color(0xff2498A1),
                          elevation: 5,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text("خليها بالسلة",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24)),
                          ),
                          onPressed: () async{
                            if (wachNum == 0 && dishWachNum == 0) {
                              Toast.show("حدد العدد الذي تريده", context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            } else {
                              int status;
                              if (wachNum != 0 && dishWachNum == 0) {
                                status = 1;
                              } else if (wachNum == 0 && dishWachNum != 0) {
                                status = 2;
                              } else if (wachNum != 0 && dishWachNum != 0) {
                                status = 3;
                              }
                             await BlocProvider.of<CartBloc>(context).add(
                                  AddItemToCart(
                                      item_id: widget.item.id,
                                      countWach: wachNum,
                                      countdryWash: dishWachNum,
                                      status: status));
                                       Toast.show("تمت الأضافة الى السلة", context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
//                                        Navigator.push(context, MaterialPageRoute(builder: (_) {
//                        return MyCartScreen();
//                      }));
                            }
                          }),
                    ),
                  ),
                ],
              ),
            );
            // BlocProvider.of<CartBloc>(context).add(ReturnToInitial());
          }
          if (state is CartNetworkError) {
            return networkError("لا يوجد اتصال");
          }
          if (state is CartError) {
            return networkError(state.string);
          }
        }),
      ),
    );
  }

  Widget buildCardOnce(Item item) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (_) {
          //   return AddToCartScreen(item);
          // }));
        },
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                                stops: [
                                  0.15,
                                  1.0
                                ],
                                colors: [
                                  Color(0xff063051),
                                  Color(0xff35D2CD)
                                ])),
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
                              baseUrlImage + item.photo,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 0, left: 0),
                        child:item.washPrice==0?
                        Container():Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: item.washPrice.toString(),
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 14),
                                  children: [
                                    TextSpan(
                                        text: item.currency,
                                        style: TextStyle(
                                            color: Color(0xFFFFA200),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12))
                                  ]),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Image.asset(
                              "assets/images/Page-1.png",
                              width: 25,
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: item.dwPrice.toString(),
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 14),
                                  children: [
                                    TextSpan(
                                        text: item.currency,
                                        style: TextStyle(
                                            color: Color(0xFFFFA200),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12))
                                  ]),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Image.asset(
                              "assets/images/5.png",
                              width: 25,
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                     
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class circularProgress extends StatelessWidget {
  const circularProgress({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: CircularProgressIndicator(),
      data: new ThemeData(
        primaryColor: Colors.blueAccent,
        primaryColorDark: Colors.red,
      ),
    );
  }
}
