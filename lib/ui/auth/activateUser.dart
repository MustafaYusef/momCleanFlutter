import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mom_clean/repastory/Authrepasatory.dart';
import 'package:mom_clean/ui/addToCartScreen.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../main.dart';
import 'logInScreen.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String token;
  final bool flage;
  PinCodeVerificationScreen(this.phoneNumber, this.token, this.flage);
  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  var onTapRecognizer;
  bool flage = true;
  TextEditingController PassController = TextEditingController();
  String code = "+964";
  bool isLoading = false;

  /// this [StreamController] will take input of which function should be called

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        AuthRepastory repo = AuthRepastory();
        try {
          final login = await repo.reSendCode(widget.phoneNumber);
        } catch (e) {}
      };

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'التحقق من رقم الهاتف',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
                  fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/placeholder.png',
                  height: MediaQuery.of(context).size.height / 4,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(height: 8),
                
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: RichText(
                    
                      text: TextSpan(
                          text: "أدخل الرمز المرسل إلى ",
                         
                          children: [
                            TextSpan(
                                text: widget.phoneNumber,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ],
                          style:
                              TextStyle( fontWeight: FontWeight.bold,color: Colors.black45, fontSize: 16)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      length: 6,
                      obsecureText: false,
                      animationType: AnimationType.fade,
                      shape: PinCodeFieldShape.underline,
                      animationDuration: Duration(milliseconds: 300),
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      onChanged: (value) {
                        setState(() {
                          if (value.length != 6) {
                            hasError = true;
                          } else {
                            hasError = false;
                          }
                          currentText = value;
                        });
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  // error showing widget
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      hasError ? "*املأ الحقول بشكل صحيح" : "",
                      style:
                          TextStyle(color: Colors.red.shade300, fontSize: 15),
                    ),
                  ),
                ),
                Directionality(
                    child:widget.flage? Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.blueAccent,
                          primaryColorDark: Colors.red,
                        ),
                        child: TextField(
                          controller: PassController,
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
                              labelText: " كلمة المرور الجديدة",
                              hasFloatingPlaceholder: true,
                              labelStyle: TextStyle(
                                  fontSize: 18,
                                  backgroundColor: Colors.transparent,
                                  decorationColor: Colors.transparent),
                              prefixIcon: const Icon(Icons.lock),
                              suffix: Container(
                                height: 40,
                                width: 30,
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
                    ):Container(),
                    textDirection: TextDirection.rtl),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child:isLoading?Container(
                    width: 40,height: 40,
                    child: circularProgress()): Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 30),
                    child: ButtonTheme(
                      height: 50,
                      child: FlatButton(
                        onPressed: () async {
                          // conditions for validating
                          if (currentText.length != 6) {
                            setState(() {
                              hasError = true;
                            });
                          } else {
                            AuthRepastory repo = AuthRepastory();
                            if (widget.flage) {
                              // verification process in forget password
                         
                        AuthRepastory repo = AuthRepastory();
                          setState(() {
                          isLoading=true;
                        });
                        try {
                          var res = await repo.reSetPassword(
                              PassController.text, currentText, widget.phoneNumber);
                          Toast.show("تم تغيير كلمة المرور بنجاح", context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) {
                            return LoginScreen();
                          }));
                        } on SocketException catch (_) {
                          Toast.show("لا يوجد اتصال بالشبكة", context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        } catch (e) {
                          Toast.show("الرمز غير صحيح", context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        }
                        setState(() {
                          isLoading=false;
                        });
                        
                     
                            } else {
                                setState(() {
                          isLoading=true;
                        });
                              // verification process in login
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              try {
                                final login = await repo.verficationUser(
                                    currentText.toString(), widget.phoneNumber);
                                Toast.show("تم  التحقق من الرقم", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                                await prefs.setString('token', widget.token);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (_) {
                                  return MainScreen();
                                }));
                              }on SocketException catch(_){
                                  Toast.show("لا يوجد اتصال بالشبكة", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              }
                               catch (e) {
                                Toast.show(e.toString(), context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              }
                                setState(() {
                          isLoading=false;
                        });
                            }
                          }
                        },
                        child: Center(
                            child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            "تاكيد الرمز",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).primaryColor,
                              offset: Offset(1, -2),
                              blurRadius: 10),
                          BoxShadow(
                              color: Theme.of(context).primaryColor,
                              offset: Offset(-1, 2),
                              blurRadius: 10)
                        ]),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "لم تصلك رسالة؟ ",
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                        children: [
                          TextSpan(
                              text: "إعادة ارسال",
                              recognizer: onTapRecognizer,
                              style: TextStyle(
                                  color: Color(0xFF91D3B3),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18))
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget alert(BuildContext context, String code) {
  //   return AlertDialog(
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //     title: Directionality(
  //       textDirection: TextDirection.rtl,
  //       child: Center(
  //         child: Text(
  //           "كلمة المرور الجديدة",
  //           style:
  //               TextStyle(fontSize: 22, color: Theme.of(context).primaryColor),
  //         ),
  //       ),
  //     ),
  //     titlePadding: EdgeInsets.all(10),
  //     content: Padding(
  //       padding: const EdgeInsets.all(0.0),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         width: 500,
  //         height: 200,
  //         child: Column(
  //           children: <Widget>[
  //             Directionality(
  //                 child: Container(
  //                   margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
  //                   child: Theme(
  //                     data: new ThemeData(
  //                       primaryColor: Colors.blueAccent,
  //                       primaryColorDark: Colors.red,
  //                     ),
  //                     child: TextField(
  //                       controller: PassController,
  //                       keyboardType: TextInputType.visiblePassword,
  //                       style: TextStyle(fontSize: 20),
  //                       decoration: new InputDecoration(
  //                           border: new OutlineInputBorder(
  //                             borderRadius: const BorderRadius.all(
  //                               const Radius.circular(20.0),
  //                             ),
  //                           ),
  //                           hoverColor: Colors.amber,
  //                           filled: true,
  //                           hintStyle: new TextStyle(color: Colors.grey[800]),
  //                           hintText: "",
  //                           alignLabelWithHint: true,
  //                           labelText: " كلمة المرور الجديدة",
  //                           hasFloatingPlaceholder: true,
  //                           labelStyle: TextStyle(
  //                               fontSize: 18,
  //                               backgroundColor: Colors.transparent,
  //                               decorationColor: Colors.transparent),
  //                           prefixIcon: const Icon(Icons.lock),
  //                           suffix: Container(
  //                             height: 40,
  //                             width: 30,
  //                             child: IconButton(
  //                               icon: flage
  //                                   ? Icon(
  //                                       Icons.visibility_off,
  //                                       size: 20,
  //                                     )
  //                                   : Icon(
  //                                       Icons.visibility,
  //                                       size: 20,
  //                                     ),
  //                               color: Colors.blueAccent,
  //                               onPressed: () {
  //                                 setState(() {
  //                                   if (flage) {
  //                                     flage = false;
  //                                   } else {
  //                                     flage = true;
  //                                   }
  //                                 });
  //                               },
  //                             ),
  //                           ),
  //                           helperText: "ادخل كلمة المرور",
  //                           contentPadding: EdgeInsets.only(
  //                               left: 6, right: 6, top: 0, bottom: 15),
  //                           fillColor: Colors.white70),
  //                       obscureText: flage,
  //                     ),
  //                   ),
  //                 ),
  //                 textDirection: TextDirection.rtl),
  //             Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               margin:
  //                   EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
  //               width: MediaQuery.of(context).size.width,
  //               height: 50,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(20),
  //                 child: RaisedButton(
  //                   color: Colors.amber[300],
  //                   elevation: 5,
  //                   child: Directionality(
  //                     textDirection: TextDirection.rtl,
  //                     child: Text("تأكيد",
  //                         style: TextStyle(color: Colors.white, fontSize: 20)),
  //                   ),
  //                   onPressed: () async {
  //                     AuthRepastory repo = AuthRepastory();
  //                     try {
  //                       var res = await repo.reSetPassword(
  //                           PassController.text, code, widget.phoneNumber);
  //                       Toast.show("تم تغيير كلمة المرور بنجاح", context,
  //                           duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

  //                       Navigator.pushReplacement(context,
  //                           MaterialPageRoute(builder: (_) {
  //                         return LoginScreen();
  //                       }));
  //                     } on SocketException catch (_) {
  //                       Toast.show("لا يوجد اتصال بالشبكة", context,
  //                           duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //                     } catch (e) {
  //                       Toast.show("الرمز غير صحيح", context,
  //                           duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //                     }
  //                     Navigator.pop(context);
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
