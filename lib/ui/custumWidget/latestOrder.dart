import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mom_clean/models/orders.dart';
import 'package:mom_clean/ui/custumWidget/time.dart';
import 'package:mom_clean/ui/orderDetailsScreen.dart';

class latestOrder extends StatefulWidget {
  final OrdersRes myorders;
  latestOrder(this.myorders);

  @override
  _latestOrderState createState() => new _latestOrderState();
}

class _latestOrderState extends State<latestOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 10),
              child: widget.myorders == null
                  ? Container(
                      height: 150,
                      child: Center(
                        child: Text("لا توجد طلبات",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600])),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: widget.myorders.data.myorders.length,
                      itemBuilder: (BuildContext context, int index) {
                        return orderListCard(
                            widget.myorders.data.myorders[index]);
                      },
                    )),
        ],
      ),
    );
  }
}

class orderListCard extends StatelessWidget {
  Color cancelDark = Color(0xff5B3939);
  Color cancelLight = Color(0xffC82D2D);

  Color waitingDark = Color(0xffD89906);
  Color waitingtLight = Color(0xffE6EC2C);

  Color acceptedLight = Color(0xff2D6BC8);
  Color acceptedDark = Color(0xff394C5B);

  Color withOfficeLight = Color(0xff71CFDE);
  Color withOfficeDark = Color(0xff219A96);

  Color inProgressLight = Color(0xffA5E3A0);
  Color inProgressDark = Color(0xff3E7849);

  Color recivedDark = Color(0xff006E28);
  Color recivedLight = Color(0xff23D429);

  final Myorder myorder;
  orderListCard(this.myorder, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: Container(
                      width: 60,
                      height: 60,
                      margin: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [0.15, 1.0],
                              colors: getListColor(myorder.status))),
                      child: Icon(
                        myorder.type == "items"
                            ? Icons.local_laundry_service
                            : Icons.local_offer,
                        color: Colors.white,
                      )),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        getDate(myorder.createAt),
                        style: TextStyle(
                            fontSize: 20,
                            color: getListColor(myorder.status)[0]),
                      ),
                      Text("الحالة:${getStatus(myorder.status)}")
                    ],
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: Colors.white,
                    splashColor: Colors.grey[500],
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return OrderDetailsScreen(myorder.id, myorder.type);
                      }));
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          "التفاصيل",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 17,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> getListColor(String status) {
    if (status == "watting") {
      return [waitingDark, waitingtLight];
    } else if (status == "delivered") {
      return [recivedDark, recivedLight];
    } else if (status == "with MOMClean") {
      return [withOfficeDark, withOfficeLight];
    } else if (status == "cancelled") {
      return [cancelDark, cancelLight];
    } else if (status == "cleaning") {
      return [inProgressDark, inProgressLight];
    } else if (status == "accepted") {
      return [acceptedDark, acceptedLight];
    }
  }

 String getStatus(String status) {
 if (status == "watting") {
      return "أنتظار";
    } else if (status == "delivered") {
      return "تم التسليم";
    } else if (status == "with MOMClean") {
      return "في المكتب";
    } else if (status == "cancelled") {
      return "ملغي";
    } else if (status == "cleaning") {
      return "قيد التحضير";
    } else if (status == "accepted") {
      return "تم قبول الطلب";
    }
  }
}
