import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mom_clean/repastory/Authrepasatory.dart';
import 'package:mom_clean/ui/auth/profile.dart';
import 'package:flutter/material.dart';
import 'package:mom_clean/ui/custumWidget/customDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class changePassword extends StatefulWidget {
  @override
  _changePasswordState createState() => new _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  bool flage = true;
  bool isLoading = false;
  bool flage1 = true;
  final TextEditingController SignPassController = TextEditingController();
  final TextEditingController SignConfirmPassController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawar(index: 8),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            "تغيير كلمة المرور",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
              child: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    image: DecorationImage(
                        image: AssetImage("assets/images/placeholder.png"),
                        fit: BoxFit.scaleDown)),
                width: MediaQuery.of(context).size.width,
                height: 120,
              ),
              SizedBox(height: 10,),
              Directionality(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Theme(
                      data: new ThemeData(
                        primaryColor: Colors.blueAccent,
                        primaryColorDark: Colors.red,
                      ),
                      child: TextField(
                        controller: SignPassController,
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(fontSize: 20),
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(20.0),
                              ),
                            ),
                            hoverColor: Colors.amber,
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[800]),
                            hintText: "",
                            alignLabelWithHint: true,
                            labelText: "كلمة المرور القديمة",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(
                                fontSize: 18,
                                backgroundColor: Colors.transparent,
                                decorationColor: Colors.transparent),
                            prefixIcon: const Icon(Icons.lock),
                            suffix: Container(
                              height: 40,
                              child: IconButton(
                                icon: flage
                                    ? Icon(
                                        Icons.visibility_off,
                                        size: 20,
                                      )
                                    : Icon(
                                        Icons.visibility,
                                        size: 20,
                                      ),
                                color: Colors.blueAccent,
                                onPressed: () {
                                  setState(() {
                                    if (flage) {
                                      flage = false;
                                    } else {
                                      flage = true;
                                    }
                                  });
                                },
                              ),
                            ),
                            helperText: "ادخل كلمة المرور",
                            contentPadding: EdgeInsets.only(
                                left: 6, right: 6, top: 0, bottom: 15),
                            fillColor: Colors.white70),
                        obscureText: flage,
                      ),
                    ),
                  ),
                  textDirection: TextDirection.rtl),
              Directionality(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Theme(
                      data: new ThemeData(
                        primaryColor: Colors.blueAccent,
                        primaryColorDark: Colors.red,
                      ),
                      child: TextField(
                        controller: SignConfirmPassController,
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(fontSize: 20),
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(20.0),
                              ),
                            ),
                            hoverColor: Colors.amber,
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[800]),
                            hintText: "",
                            alignLabelWithHint: true,
                            labelText: "كلمة المرور الجديدة",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(
                                fontSize: 18,
                                backgroundColor: Colors.transparent,
                                decorationColor: Colors.transparent),
                            prefixIcon: const Icon(Icons.lock),
                            suffix: Container(
                              height: 40,
                              child: IconButton(
                                icon: flage1
                                    ? Icon(
                                        Icons.visibility_off,
                                        size: 20,
                                      )
                                    : Icon(
                                        Icons.visibility,
                                        size: 20,
                                      ),
                                color: Colors.blueAccent,
                                onPressed: () {
                                  setState(() {
                                    if (flage1) {
                                      flage1 = false;
                                    } else {
                                      flage1 = true;
                                    }
                                  });
                                },
                              ),
                            ),
                            helperText: "ادخل كلمة المرور الجديدة",
                            contentPadding: EdgeInsets.only(
                                left: 6, right: 6, top: 0, bottom: 15),
                            fillColor: Colors.white70),
                        obscureText: flage1,
                      ),
                    ),
                  ),
                  textDirection: TextDirection.rtl),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: isLoading
                    ? circularProgress()
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
                            color: Colors.amber[300],
                            elevation: 5,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text("تعديل",
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 20)),
                            ),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              if (checkValidation()) {
                                SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              var token = await prefs.getString('token');

                              AuthRepastory repo = AuthRepastory();
                              try {
                                final login = await repo.changePassword(
                                    token,
                                    SignPassController.text,
                                    SignConfirmPassController.text);

                                //  print('saved token ${prefs.getString('token')}');
                                Toast.show("تم تغيير كلمة المرور بنجاح", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);

                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (_) {
                                  return ProfileScreen();
                                }));
                              } on SocketException {
                                Toast.show("لا يوجد اتصال", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              } catch (e) {
                                Toast.show("ادخل كلمة المرور الصحيحة", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              }
                              }else{
                                 Toast.show("اكمل جميع الحقول", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              }
                              

                              setState(() {
                                isLoading = false;
                              });
                            },
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkValidation() {
    if(SignPassController.text.isEmpty||
       SignConfirmPassController.text.isEmpty){
         return false;
       }else{
         return true;
       }
  }
}
