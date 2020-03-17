import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/blocs/CategoryBloc.dart';
import 'package:mom_clean/models/categoryItemsRes.dart';
import 'package:mom_clean/models/categoryRes.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:mom_clean/ui/addToCartScreen.dart';
import 'package:mom_clean/ui/auth/logInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'custumWidget/customDrawer.dart';
import 'custumWidget/custumAppBar.dart';

class categoty extends StatefulWidget {
  @override
  _categotyState createState() => new _categotyState();
}

class _categotyState extends State<categoty> {
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

  categoryRes catRes;
  int indexSelected = 0;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: drawar(index: 3),
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
              child: Text(
                "الأقسام",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
        ),
        body: BlocProvider(create: (context) {
          return CategoryBloc(Repo: MainRepastory())..add(FetchCategory(-1));
        }, child:
            BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
          if (state is CategoryLoading) {
            return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(child: circularProgressCategory()));
          }
          if (state is CategoryLoaded) {
            return Column(
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  indexSelected = index;
                                });

                                BlocProvider.of<CategoryBloc>(context).add(
                                    FetchCategory(state
                                        .category.data.categories[index].id));
                              },
                              child: Chip(
                                backgroundColor: indexSelected != index
                                    ? Colors.grey[300]
                                    : Color(0xff2498A1),
                                label: Container(
                                  margin: EdgeInsets.all(0),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    state
                                        .category.data.categories[index].nameAr,
                                    style: TextStyle(
                                        color: indexSelected != index
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                        itemCount: state.category.data.categories.length,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SizedBox(
                    height: 500,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return buildCard(state.categoryItems.data.items[index]);
                      },
                      itemCount: state.categoryItems.data.items.length,
                    ),
                  ),
                )
              ],
            );
          }
          if (state is CategoryItemsLoaded) {
            //print(state.categoryItem);

            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 2,
                          child: Wrap(
                            spacing: 10,
                            children: catRes != null
                                ? buldTags(catRes.data.categories, context)
                                : Container(
                                    child: Text(" "),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return buildCard(
                              state.categoryItem.data.items[index]);
                        },
                        itemCount: state.categoryItem.data.items.length,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          if (state is CategoryNetworkError) {
            return networkError();
          }
          if (state is CategoryError) {
            return networkError();
          }
        })));
  }

  Widget buildCard(Item item) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = await prefs.getString('token');
          if (token == "" || token == null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return LoginScreen();
            }));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return AddToCartScreen(item);
            }));
          }
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
                          child:CachedNetworkImage(
                          fit: BoxFit.cover,
                         
                          
                          imageUrl:
                              baseUrlImage + item.photo,
                          placeholder: (context, url) =>
                              Image.asset("assets/images/placeholder.png"),
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/images/placeholder.png"),
                        ),
                           )),
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
                        padding: EdgeInsets.all(10),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(item.nameAr,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, right: 2, left: 2),
                        child: item.washPrice != 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text: item.washPrice.toString(),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14),
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
                              )
                            : Container(),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 2, right: 2, bottom: 20),
                        child: item.dwPrice != 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text: item.dwPrice.toString(),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14),
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
                              )
                            : Container(),
                      ),
//              ClipRRect(
//                borderRadius: BorderRadius.only(
//                    topLeft: Radius.circular(20),
//                    topRight: Radius.circular(20)),
//                child:
//                Container(
//                  height: 50,
//                  width: 30,
//                  color: Color(0xffFFA200),
//                  child: Column(
//                    children: <Widget>[
//                      Directionality(
//                          textDirection: TextDirection.rtl,
//                          child: Text(
//                            "عدد",
//                            style: TextStyle(color: Colors.white),
//                          )),
//                      Text(
//                        "5",
//                        style: TextStyle(
//                            color: Colors.white, fontSize: 18),
//                      )
//                    ],
//                  ),
//                ),
//              )
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

class networkError extends StatelessWidget {
  const networkError({
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
          Text("لا يوجد اتصال"),
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
                    BlocProvider.of<CategoryBloc>(context)
                        .add(FetchCategory(-1));
                  }),
            ),
          ),
        ],
      ),
    ));
  }
}

List<Widget> buldTags(List<Category> tags, BuildContext context) {
  return tags.map((tag) {
    return Chip(
      label: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(tag.nameAr),
      ),
    );
  }).toList();
}

class circularProgressCategory extends StatelessWidget {
  const circularProgressCategory({
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
