import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/blocs/CartBloc.dart';
import 'package:mom_clean/models/cartRes.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:mom_clean/ui/mapScreen.dart';
import 'package:toast/toast.dart';

import '../main.dart';
import 'category.dart';
import 'custumWidget/customDrawer.dart';

class MyCartScreen extends StatefulWidget {
  @override
  _MyCartScreenState createState() => new _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawar(index: 7),
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
            child: Text("سلة المشتريات",style: TextStyle(fontSize: 20,color: Colors.black),),
          ),
          
        ),
      ),
      body: BlocProvider(
        create: (context) {
          return CartBloc(Repo: MainRepastory())..add(FetchCart());
        },
        child: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
          if (state is CartLoading) {
            return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(child: circularProgress()));
          }
          if (state is CartLoaded) {
            return Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: ListView.builder(
                        itemCount: state.cart.data.myCart.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildCardOnce(state.cart.data.myCart[index]);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: getTotalPrice(state.cart.data.myCart),
                            style: TextStyle(
                                color: Color(0xFFFFA200), fontSize: 20),
                            children: [
                              TextSpan(
                                  text: "IQ",
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
                    height: 15,
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
                            child: Text("حدد مكانك",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24)),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) {
                              return MapScreen();
                            }));
                          }),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is CartNetworkError) {
            return networkError();
          }
          if (state is CartError) {
            return networkError();
          }
          if(state is CartIsEmpty){
               return Center(
        child: Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.remove_shopping_cart ,size: 100,color: Theme.of(context).primaryColor,),
          SizedBox(height: 10,),
          Text("السلة فارغة",style: TextStyle(fontSize: 20),),
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
                    child: Text("رجوع",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                  onPressed: () {
                 
                   Navigator.of(context).pop();
                  }),
            ),
          ),
        ],
      ),
    ));
          }
        }),
      ),
    );
  }

  Widget buildCardOnce(MyCart item) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 180,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
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
                                  text: item.price.toString(),
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
                              item.type == "wash"
                                  ? "assets/images/Page-1.png"
                                  : "assets/images/5.png",
                              width: 25,
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                      Text(item.nameAr,style: TextStyle(fontSize: 15,color: Colors.grey[800]),),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
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
      ),
    );
  }

  String getTotalPrice(List<MyCart> myCart) {
    int sum = 0;
    for (MyCart i in myCart) {
      sum += i.price;
    }
    return sum.toString();
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
