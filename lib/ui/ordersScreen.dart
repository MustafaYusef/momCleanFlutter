
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/blocs/homeBloc.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:mom_clean/ui/auth/profile.dart';

import 'custumWidget/customDrawer.dart';
import 'custumWidget/custumAppBar.dart';
import 'custumWidget/latestOrder.dart';
class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => new _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
     endDrawer: drawar(index: 5),
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
            child: Text("الطلبات السابقة",style: TextStyle(fontSize: 20,color: Colors.black),),
          ),
          
        ),
      ),
      body: Builder(builder: (cont) {
        return Column(
          children: <Widget>[
           
            Expanded(
              child: BlocProvider(
                create: (context) {
                  return HomeBloc(Repo: MainRepastory())..add(FetchAllOrders());
                },
                child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                  if (state is HomeLoading) {
                    return Center(
                      child: Container(
                          width: 40, height: 40, child: circularProgress()),
                    );
                  }
                  if (state is AllOrdersLoaded) {
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Directionality(
                                      child: Text(
                                        "الطلبات",
                                        style: TextStyle(
                                            fontSize: 26,
                                            color: Colors.grey[800]),
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                
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