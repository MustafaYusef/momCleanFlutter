import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:mom_clean/ui/ordersScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'custumWidget/customDrawer.dart';

class MapScreen extends StatefulWidget {
  final int id;
  final List<String> itemsId;
  final List<String> counts;
  final List<String> newcounts;
  final int sum;
  MapScreen([this.id, this.itemsId, this.counts, this.newcounts, this.sum]);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    moveCamera();
  }

  double lat = 0;
  double lon = 0;
  List<Marker> markers = [];
  moveCamera() async {
    LocationData loc = await getLocation();
    lat = loc.latitude;
    lon = loc.longitude;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(loc.latitude, loc.longitude),
        tilt: 59.440717697143555,
        zoom: 16.151926040649414)));
    setState(() {
      markers.add(Marker(
          markerId: MarkerId("1"),
          draggable: true,
          infoWindow: InfoWindow(title: "موقعك الحالي"),
          onDragEnd: ((value) {
            lat = value.latitude;
            lon = value.longitude;
          }),
          position: LatLng(lat, lon)));
    });
getNum();

  }
    int notifNum=0;
  int cartNum=0;

     getNum() async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          notifNum =  prefs.getInt('notification');
     cartNum =  prefs.getInt('cart');
        });
     
 }

  bool mapType = true;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        endDrawer: drawar(index: 0,notifNum:notifNum,cartNum:cartNum ,),
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
            child: Text("تحديد الموقع",style: TextStyle(fontSize: 20,color: Colors.black),),
          ),
          
        ),
      ),
      body: SafeArea(
        child: Stack(children: <Widget>[
          GoogleMap(
            rotateGesturesEnabled: true,
            markers: Set.from(markers),
            mapType: mapType ? MapType.normal : MapType.satellite,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      elevation: 5,
                      child: Icon(
                        Icons.my_location,
                        color: Colors.white,
                      ),
                      onPressed: moveCamera,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      elevation: 5,
                      child: Icon(
                        Icons.map,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          if (mapType) {
                            mapType = false;
                          } else {
                            mapType = true;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: !isLoading
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: RaisedButton(
                          color:Theme.of(context).primaryColor,
                          elevation: 5,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text("أرسال الطلب",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24)),
                          ),
                          onPressed: () async {
                            MainRepastory repo = MainRepastory();
                            setState(() {
                              isLoading = true;
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var token = await prefs.getString('token');

                            if (widget.id == null) {
                              try {
                                final res =
                                    await repo.makeNormalOrder(token, lat, lon);
                                    showAlertDialog(context);
                                    
                              } on SocketException catch (_) {
                                Toast.show("لا يوجد اتصال بالشبكة", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              } catch (_) {
                                Toast.show(_, context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              }
                            } else {
                              try {
                                final res =
                                    await repo.makePackageOrder(token, lat, lon, widget.sum, widget.itemsId
                                    , widget.counts,widget.newcounts, widget.id);
                                     showAlertDialog(context);
                              } on SocketException catch (_) {
                                Toast.show("لا يوجد اتصال بالشبكة", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              } catch (_) {
                                Toast.show(_.toString(), context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              }
                            }

                            setState(() {
                              isLoading = false;
                            });
                              Toast.show("تم ارسال الطلب ينجاح", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              
                            
                          }),
                    ),
                  )
                : Theme(
                    child: CircularProgressIndicator(),
                    data: new ThemeData(
                      primaryColor: Colors.blueAccent,
                      primaryColorDark: Colors.red,
                    ),
                  ),
          )
        ]),
      ),
    );
  }
 showAlertDialog(BuildContext context) {
    // set up the buttons
 
    Widget continueButton = Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 100,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: RaisedButton(
                          color:Theme.of(context).primaryColor,
                          elevation: 5,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text("تم",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                          onPressed: () async {
                           Navigator.of(context).pop();
                           Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) {
                              return OrderScreen();
                            }));
                          }),
                    ),
                  );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      title: Directionality(textDirection: TextDirection.rtl,
        child: Text("شكرا ألك لأنك طلبت من عدنا ")),
      content: Directionality(
        textDirection: TextDirection.rtl,
              child: Text(
            "راح نتصل بيك قريبا",style: TextStyle(color: Color(0xffFFB300),
            fontWeight: FontWeight.bold,fontSize: 18),),
      ),
      actions: [
      
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(CameraUpdate.newCameraPosition( CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(loc.latitude,loc.longitude),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414))));
  // }
  Future<LocationData> getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return null;
      }
    }

    return _locationData = await location.getLocation();
  }
}
