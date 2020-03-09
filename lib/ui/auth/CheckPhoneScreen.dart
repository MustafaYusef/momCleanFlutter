import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mom_clean/repastory/Authrepasatory.dart';
import 'package:mom_clean/ui/auth/activateUser.dart';
import 'package:mom_clean/ui/auth/profile.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../main.dart';

class CheckPhoneScreen extends StatefulWidget {
  @override
  _CheckPhoneScreenState createState() => _CheckPhoneScreenState();
}

class _CheckPhoneScreenState extends State<CheckPhoneScreen> {
  var onTapRecognizer;

  /// this [StreamController] will take input of which function should be called

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String code = "+964";
  TextEditingController SignPhoneController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
        backgroundColor: Colors.white,
        elevation: 0,

      ),
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
                  child: Container(
            height: MediaQuery.of(context).size.height,
            
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Image.asset(
                  'assets/images/placeholder.png',
                  height: MediaQuery.of(context).size.height / 4,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      'التحقق من رقم الهاتف',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Directionality(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Theme(
                          data: new ThemeData(
                            primaryColor: Colors.blueAccent,
                            primaryColorDark: Colors.red,
                          ),
                          child: TextField(
                            controller: SignPhoneController,
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
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
                                hintText: "7712345678",
                                alignLabelWithHint: true,
                                labelText: "رقم الهاتف",
                                hasFloatingPlaceholder: true,
                                labelStyle: TextStyle(
                                    fontSize: 18,
                                    backgroundColor: Colors.transparent,
                                    decorationColor: Colors.transparent),
                                helperText: "يجب ان يتكون الرقم من 10 مراتب",
                                prefixIcon: const Icon(Icons.phone),
                                suffix: Container(
                                  padding: EdgeInsets.all(0),
                                  margin: EdgeInsets.all(0),
                                  height: 40,
                                  child: CountryCodePicker(
                                    onChanged: (prit) {
                                      print(prit.dialCode.toString());
                                      code = prit.dialCode;
                                    },
                                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                    initialSelection: '+964',

                                    // optional. Shows only country name and flag
                                    showCountryOnly: false,
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 6, right: 6, top: 0, bottom: 15),
                                fillColor: Colors.white70),
                          ),
                        ),
                      ),
                      textDirection: TextDirection.rtl),
                ),
                SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isLoading
                      ? Container(
                          width: 50, height: 50, child: Container(width: 50,
                            child: circularProgress()))
                      : Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                    child: FlatButton(
                            onPressed: () async {
                              // conditions for validating
                              if (SignPhoneController.text.isEmpty) {
                                Toast.show("اكتب رقم الهاتف", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              } else if (SignPhoneController.text.length < 10) {
                                Toast.show("يجب ان يتكون رقم الهاتف من عشرة مراتب",
                                    context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              } else {
                                AuthRepastory repo = AuthRepastory();
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  final login = await repo
                                      .reSendCode(code + SignPhoneController.text);

                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (_) {
                                    return PinCodeVerificationScreen(
                                        code + SignPhoneController.text,
                                        "token",
                                        true);
                                  }));
                                } on SocketException catch (_) {
                                  Toast.show("لا يوجد اتصال بالشبكة", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                } catch (e) {
                                  Toast.show("رقم الهاتف غير صالح", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: Center(
                                child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                "تاكيد الرقم",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
