import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/blocs/notificationBloc.dart';
import 'package:mom_clean/models/notificationRes.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'auth/profile.dart';
import 'custumWidget/customDrawer.dart';
import 'custumWidget/time.dart';
// class MyNotificationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new Container();
//   }
// }

// class MyNotificationScreen extends StatefulWidget {
//   @override
//   _MyNotificationScreenState createState() => new _MyNotificationScreenState();
// }

class MyNotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: drawar(index: 1),
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
            child: Text("الأشعارات",style: TextStyle(fontSize: 20,color: Colors.black),),
          ),
          
        ),
      ),
        body: BlocProvider(create: (context) {
          return NotificationBloc(Repo: MainRepastory())
            ..add(FetchNotification());
        }, child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
          if (state is NotificationLoading) {
            return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(child: circularProgress()));
          }
          if (state is NotificationLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        "الأشعارات",
                        style: TextStyle(color: Colors.grey[900], fontSize: 24),
                      )),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: SizedBox(
                    height: 500,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return buildCard(
                            state.notification.data.myNotifications[index],context);
                      },
                      itemCount: state.notification.data.myNotifications.length,
                    ),
                  ),
                ),
              ],
            );
          }
          if (state is NotificationError) {
         return networkError(state.string);
          }
          if (state is NotificationNetworkError) {
            return networkError("لا يوجد اتصال بالشبكة");
          }
          if (state is NotificationDeleted) {
            Toast.show("تم حذف الأشعار بنجاح", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            BlocProvider.of<NotificationBloc>(context).add(FetchNotification());
          }
        })));
  }

  Widget buildCard(MyNotification myNotification,BuildContext context1) {
    return Container(
      margin: EdgeInsets.all(5),
      width: MediaQuery.of(context1).size.width,
      height: 180,
      child: InkWell(
        onTap: () {},
        child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Directionality(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              width: 80,
                              height: 80,
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  borderRadius: BorderRadius.circular(40),
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      stops: [
                                        0.15,
                                        1.0
                                      ],
                                      colors: [
                                        Color(0xff1E314E),
                                        Color(0xff4DA2EC)
                                      ])),
                              child: Icon(
                                Icons.notifications,
                                size: 40,
                                color: Colors.white,
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              getDate(myNotification.createAt.split(" ")[0] +
                                  "/" +
                                  myNotification.createAt.split(" ")[1]),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[900],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            myNotification.titleAr,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey[900],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: Text(
                              myNotification.descriptionAr,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context1,
                                          builder: (BuildContext context) {
                                            return DeleteAlert(
                                                context1, myNotification.id);
                                          });
                                    },
                                    child: Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    )),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              textDirection: TextDirection.rtl,
            )),
      ),
    );
  }

  Widget DeleteAlert(BuildContext context1, int id) {
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
                "هل تريد حذف هذا الأشعار",
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
                      BlocProvider.of<NotificationBloc>(context1)
                          .add(CancelNotification(id));
                          
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
