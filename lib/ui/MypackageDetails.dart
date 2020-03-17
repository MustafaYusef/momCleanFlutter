import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/blocs/packageBloc.dart';
import 'package:mom_clean/models/myPackageDetailsRes.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:mom_clean/ui/MyCartScreen.dart';
import 'package:mom_clean/ui/category.dart';
import 'package:mom_clean/ui/mapScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MypackageScreen.dart';
import 'custumWidget/customDrawer.dart';

class MypackageDetails extends StatefulWidget {
  final int id;
  final String name;
  final String desc;
  MypackageDetails(this.id, this.name, this.desc);

  @override
  _MypackageDetailsState createState() => new _MypackageDetailsState();
}

class _MypackageDetailsState extends State<MypackageDetails> {
  List<int> itemsId = [];
  List<int> counts = [];
  List<int> Newcounts = [];
  List<PackageItem> packageItems = [];
  int itemsCount = 0;

  int count = 0;

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
         endDrawer: drawar(index: 4,),
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
            child: Text("باقاتي",style: TextStyle(fontSize: 20,color: Colors.black),),
          ),
          
        ),
      ),
        body: BlocProvider(create: (context) {
          return PackageBloc(Repo: MainRepastory())
            ..add(FetchMyPackageDetails(widget.id));
        }, child:
            BlocBuilder<PackageBloc, PackageState>(builder: (context1, state) {
          if (state is PackageLoading) {
            return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(child: circularProgress()));
          }
          if (state is MyPackageDetailsLoaded) {
            if (packageItems.isEmpty) {
              packageItems = state.myPackage.data.packageItems;
            }

            if (counts.isEmpty) {
              for (int i = 0; i < packageItems.length; i++) {
                counts.insert(i, 0);
              }
            }

            if (Newcounts.isEmpty) {
              for (int i = 0; i < packageItems.length; i++) {
                Newcounts.insert(i, packageItems[i].count);
              }
            }
            if (itemsId.isEmpty) {
              for (int i = 0; i < packageItems.length; i++) {
                itemsId.insert(i, 0);
              }
            }
            print("here i am mother fucker");

            //   itemsId.
            //     counts = [];
            //  Newcounts = [];
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            widget.name,
                            style: TextStyle(
                                color: Colors.grey[900], fontSize: 24),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            widget.desc,
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 14),
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (BuildContext context, int index) {
                          return buildCard(
                              state.myPackage.data.packageItems[index], index);
                        },
                        itemCount: state.myPackage.data.packageItems.length,
                      ),
                    ),
                    Container(
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
                          color: Theme.of(context).primaryColor,
                          elevation: 5,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text("حدد مكانك",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                          onPressed: () {
                            int sum = 0;
                            List<String> itemsIdTemp = [];
                            List<String> countsTemp = [];
                            List<String> NewcountsTemp = [];
                            for (int i = 0; i < counts.length; i++) {
                              sum += counts[i];
                              if (counts[i] != 0) {
                                countsTemp.add(counts[i].toString());
                                NewcountsTemp.add(Newcounts[i].toString());
                                itemsIdTemp.add(packageItems[i]
                                    .packageUserDetailsId
                                    .toString());
                              }
                            }
                            // for (int i = 0; i < countsTemp.length; i++) {
                            //   if (int.tryParse(countsTemp[i]) == 0) {
                            //     countsTemp.removeAt(i);
                            //     NewcountsTemp.removeAt(i);
                            //     itemsIdTemp.removeAt(i);
                            //   }
                            // }

                            print(NewcountsTemp);
                            print(itemsIdTemp);
                            print(countsTemp);
                            print(sum);
                            if (sum != 0) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return MapScreen(widget.id, itemsIdTemp,
                                    countsTemp, NewcountsTemp, sum);
                              }));
                            }

                            // print(Newcounts);
                            // print(sum);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is PackageNetworkError) {
            return networkErrorHome("لا يوجد اتصال بالشبكة");
          }
          if (state is PackageError) {
            return networkErrorHome(state.msg.toString());
          }
        })));
  }

  Widget buildCard(PackageItem item, int index) {
    var baseUrlImage = "https://api.maamclean.com/files/";
    return Container(
      margin: EdgeInsets.all(10),
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
                width: 45,
                left: 20,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    height: 50,
                    width: 45,
                    color: Color(0xffFFA200),
                    child: Column(
                      children: <Widget>[
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              "المتبقي",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )),
                        Text(
                          Newcounts[index].toString(),
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 30,
                          height: 30,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: RaisedButton(
                                color: Color(0xffCE4B4B),
                                elevation: 5,
                                child: Text("-",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontFamily: "")),
                                onPressed: () {
                                  setState(() {
                                    if (counts[index] > 0) {
                                      counts[index]--;
                                      Newcounts[index]++;
                                    }
                                  });
                                }),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 30,
                          height: 30,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: RaisedButton(
                                color: Color(0xff063051),
                                elevation: 5,
                                child: Text("+",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: "")),
                                onPressed: () {
                                  print(packageItems[index].count);
                                  print(counts[index]);
                                  setState(() {
                                    if (Newcounts[index] > 0) {
                                      counts[index]++;

                                      Newcounts[index]--;
                                    }
                                  });
                                }),
                          ),
                        ),
                      ],
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
                              counts[index].toString(),
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
}
