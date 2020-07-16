import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picker_view/flutter_picker_view.dart';
import 'package:http/http.dart';
import 'package:mom_clean/main.dart';
import 'package:mom_clean/models/city.dart';
import 'package:mom_clean/repastory/Authrepasatory.dart';

import 'package:mom_clean/ui/auth/activateUser.dart';
import 'package:mom_clean/ui/auth/profile.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'CheckPhoneScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool flageBotton = true;
  bool flage = true;
  bool flage1 = true;
  int count = 0;
  final loginPhoneController = TextEditingController();
  final loginPassController = TextEditingController();

  String code = "+964";
  TextEditingController AddressController = TextEditingController();
  int CityId = 0;
  TextEditingController SignPhoneController = TextEditingController();
  TextEditingController SignPassController = TextEditingController();
  TextEditingController SignConfirmPassController = TextEditingController();
  TextEditingController SignFullNameController = TextEditingController();
  String codeSign = "+964";
  String errorMassege;
  String signUpErrorMasseg;
  var onTapRecognizer;

  bool isLoginLoading = false;
  bool isSignUpLoading = false;
  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return CheckPhoneScreen();
        }));
      };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          title: Directionality(
            child: Text(
              "تسجيل الدخول",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            textDirection: TextDirection.rtl,
          ),
          centerTitle: true,
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
              Container(
                color: Theme.of(context).primaryColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 130,
                      height: 60,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: FlatButton(
                          color:
                              flageBotton ? Colors.amberAccent : Colors.white,
                          child: Directionality(
                            child: Text(
                              "دخول",
                              style: TextStyle(
                                  color: flageBotton
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                  fontSize: 20),
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          onPressed: () {
                            setState(() {
                              if (flageBotton) {
                                flageBotton = false;
                              } else {
                                flageBotton = true;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 130,
                      height: 60,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: FlatButton(
                          color:
                              flageBotton ? Colors.white : Colors.amberAccent,
                          child: Directionality(
                            child: Text(
                              "تسجيل",
                              style: TextStyle(
                                  color: flageBotton
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                  fontSize: 20),
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          onPressed: () {
                            setState(() {
                              if (flageBotton) {
                                flageBotton = false;
                              } else {
                                flageBotton = true;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                children: changedColumn(context, flageBotton),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> changedColumn(BuildContext context, bool buttunFlage) {
    if (buttunFlage) {
      return <Widget>[
        Directionality(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Theme(
                data: new ThemeData(
                  primaryColor: Colors.blueAccent,
                  primaryColorDark: Colors.red,
                ),
                child: TextField(
                  controller: loginPhoneController,
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
                      // counter: Text("${count}/${10}"),
                      helperText: "يجب ان يتكون الرقم من 10 مراتب",
                      prefixIcon: const Icon(Icons.phone),
                      suffix: Container(
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(0),
                        height: 40,
                        child: CountryCodePicker(
                          onChanged: (prit) {
                            code = prit.dialCode.toString();
                            print(prit.dialCode.toString());
                          },
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: '+964',

                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                        ),
                      ),
                      // counterText: "${count}/${10}",
                      contentPadding: EdgeInsets.only(
                          left: 6, right: 6, top: 0, bottom: 15),
                      fillColor: Colors.white70),
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
                  controller: loginPassController,
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
                      labelText: "كلمة المرور",
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoginLoading
              ? Container(
                  width: 40,
                  height: 40,
                  child: Container(width: 50, child: circularProgress()))
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: RaisedButton(
                      color: Colors.amber[300],
                      elevation: 5,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text("دخول",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoginLoading = true;
                        });

                        if (checkValidation()) {
                          var playerId = await getuserId();
                          AuthRepastory repo = AuthRepastory();
                          try {
                            final login = await repo.Login(
                                code + loginPhoneController.text,
                                loginPassController.text,
                                playerId);

                            if (login.data.isActive) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              // int counter = (prefs.getInt('counter') ?? 0) + 1;
                              // print('Pressed $counter times.');

                              await prefs.setString('token', login.data.token);
                              print('saved token ${prefs.getString('token')}');
                              Toast.show("تم تسجيل الدخول بنجاح", context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (_) {
                                return MainScreen();
                              }));
                            } else {
                              //go to verifecation page
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return PinCodeVerificationScreen(
                                    code + loginPhoneController.text,
                                    login.data.token,
                                    false);
                              }));
                              try {
                                final login = await repo.reSendCode(
                                    code + loginPhoneController.text);
                              } catch (e) {}
                            }
                          } on SocketException catch (_) {
                            Toast.show("لا يوجد اتصال بالشبكة", context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          } catch (e) {
                            Toast.show("يوجد خطأ في رقم الهاتف او كلمة المرور",
                                context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          }
                        } else {
                          Toast.show(errorMassege, context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        }
                        setState(() {
                          isLoginLoading = false;
                        });
                      },
                    ),
                  ),
                ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "هل نسيت كلمة المرور؟",
                style: TextStyle(color: Colors.black54, fontSize: 16),
                children: [
                  TextSpan(
                      text: "تغيير كلمة المرور ",
                      recognizer: onTapRecognizer,
                      style: TextStyle(
                          color: Color(0xFF91D3B3),
                          fontWeight: FontWeight.bold,
                          fontSize: 14))
                ]),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Directionality(
            textDirection: TextDirection.rtl,
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return MainScreen();
                }));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "تخطي",
                  style: TextStyle(
                      fontSize: 22,
                      textBaseline: TextBaseline.alphabetic,
                      color: Theme.of(context).primaryColor),
                ),
              ),
            )),
      ];
    } else {
      return <Widget>[
        Directionality(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Theme(
                data: new ThemeData(
                  primaryColor: Colors.blueAccent,
                  primaryColorDark: Colors.red,
                ),
                child: TextField(
                  controller: SignFullNameController,
                  keyboardType: TextInputType.text,
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
                      labelText: "الأسم الكامل",
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(
                          fontSize: 18,
                          backgroundColor: Colors.transparent,
                          decorationColor: Colors.transparent),
                      prefixIcon: const Icon(Icons.person),
                      helperText: "يرجى ادخال الأسم الكامل",
                      contentPadding: EdgeInsets.only(
                          left: 6, right: 6, top: 0, bottom: 15),
                      fillColor: Colors.white70),
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
                  controller: SignPhoneController,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  onChanged: (text) {
                    setState(() {
                      count = text.length;
                    });
                  },
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
                      counter: Text("${count}/${10}"),
                      helperText: "يجب ان يتكون الرقم من 10 مراتب",
                      prefixIcon: const Icon(Icons.phone),
                      suffix: Container(
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(0),
                        height: 40,
                        child: CountryCodePicker(
                          onChanged: (prit) {
                            print(prit.dialCode.toString());
                            codeSign = prit.dialCode;
                          },
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: '+964',

                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                        ),
                      ),
                      counterText: "${count}/${10}",
                      contentPadding: EdgeInsets.only(
                          left: 6, right: 6, top: 0, bottom: 15),
                      fillColor: Colors.white70),
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
                      labelText: "كلمة المرور",
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
                      labelText: "تأكيد كلمة المرور",
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
                      helperText: "ادخل نفس كلمة المرور المرور",
                      contentPadding: EdgeInsets.only(
                          left: 6, right: 6, top: 0, bottom: 15),
                      fillColor: Colors.white70),
                  obscureText: flage1,
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
                  controller: AddressController,
                  readOnly: true,
                  onTap: () async {
                    AuthRepastory repo = AuthRepastory();
                    try {
                      final citys = await repo.getCity();
                      _showPicker(citys);
                    } on SocketException catch (_) {
                      Toast.show("لا يوجد اتصال", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    } on Exception catch (_) {
                      Toast.show(_.toString(), context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }
                  },
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
                      labelText: "العنوان",
                      alignLabelWithHint: true,
                      hasFloatingPlaceholder: false,
                      labelStyle: TextStyle(
                          fontSize: 18,
                          backgroundColor: Colors.transparent,
                          decorationColor: Colors.transparent),
                      prefixIcon: const Icon(Icons.location_city),
                      suffixIcon: const Icon(Icons.arrow_drop_down_circle),
                      contentPadding: EdgeInsets.only(
                          left: 6, right: 6, top: 0, bottom: 15),
                      fillColor: Colors.white70),
                ),
              ),
            ),
            textDirection: TextDirection.rtl),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: isSignUpLoading
              ? Container(
                  width: 40,
                  height: 40,
                  child: Container(width: 50, child: circularProgress()))
              : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: RaisedButton(
                color: Colors.amber[300],
                elevation: 5,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text("تسجيل",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                onPressed: () async {
                  setState(() {
                    isSignUpLoading=true;
                  });
                  if (checkSignUpValidation()) {
                    var playerId = await getuserId();
                    AuthRepastory repo = AuthRepastory();
                    try {
                      final Signup = await repo.SignUp(
                          SignFullNameController.text,
                          codeSign + SignPhoneController.text,
                          SignPassController.text,
                          CityId,
                          playerId);

                      //go to verifecation page
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return PinCodeVerificationScreen(
                            codeSign + SignPhoneController.text,
                            Signup.data.token,
                            false);
                      }));
                    } on SocketException catch(_){
                       Toast.show("لا يوجد اتصال بالشبكة", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }
                     catch (e) {
                      Toast.show("هذا الرقم مستخدم سابقاً", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }
                  } else {
                    Toast.show(signUpErrorMasseg, context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                  setState(() {
                    isSignUpLoading=false;
                  });
                },
              ),
            ),
          ),
        ),
      ];
    }
  }

  Future<String> getuserId() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var playerId = status.subscriptionStatus.userId;
    print("plyer id  " + playerId.toString());
    return playerId;
  }

  void _showPicker(CityRes citys) {
    PickerController pickerController =
        PickerController(count: 1, selectedItems: [0]);

    PickerViewPopup.showMode(
        PickerShowMode.AlertDialog, // AlertDialog or BottomSheet
        controller: pickerController,
        context: context,
        title: Text(
          'العنوان',
          style: TextStyle(fontSize: 20),
        ),
        cancel: Text(
          'خروج',
          style: TextStyle(color: Colors.grey),
        ),
        onCancel: () {
          // Scaffold.of(context).showSnackBar(
          //     SnackBar(content: Text('AlertDialogPicker.cancel')));
        },
        confirm: Text(
          'تأكيد',
          style: TextStyle(color: Colors.blue),
        ),
        onConfirm: (controller) {
          List<int> selectedItems = [];
          selectedItems.add(controller.selectedRowAt(section: 0));
          print("city " +
              citys.data.cities[controller.selectedRowAt(section: 0)].name);
          AddressController.value = TextEditingValue(
              text:
                  citys.data.cities[controller.selectedRowAt(section: 0)].name);
          setState(() {
            CityId = citys.data.cities[controller.selectedRowAt(section: 0)].id;
          });
          // print(AddressController.text);
          // Scaffold.of(context).showSnackBar(SnackBar(
          //     content: Text('AlertDialogPicker.selected:$selectedItems')));
        },
        builder: (context, popup) {
          return Container(
            height: 150,
            child: popup,
          );
        },
        itemExtent: 40,
        numberofRowsAtSection: (section) {
          return citys.data.cities.length;
        },
        itemBuilder: (section, row) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              '${citys.data.cities[row].name}',
              style: TextStyle(fontSize: 18),
            ),
          );
        });
  }

  bool checkValidation() {
    print(code + loginPhoneController.text);
    print(loginPassController.text);
    if (loginPhoneController.text.isEmpty || loginPassController.text.isEmpty) {
      setState(() {
        errorMassege = "اكمل جميع الحقول";
      });

      return false;
    } else if (loginPhoneController.text.length != 10) {
      setState(() {
        errorMassege = "يجب ان يتكون رقم الهاتف من عشرة مراتب";
      });

      return false;
    } else {
      return true;
    }
  }

  bool checkSignUpValidation() {
    if (CityId == 0 ||
        SignPhoneController.text.isEmpty ||
        SignPassController.text.isEmpty ||
        SignConfirmPassController.text.isEmpty ||
        SignFullNameController.text.isEmpty) {
      setState(() {
        signUpErrorMasseg = "اكمل جميع الحقول";
      });
      return false;
    } else if (SignPhoneController.text.length < 10) {
      setState(() {
        signUpErrorMasseg = "يجب ان يتكون رقم الهاتف من عشرة مراتب";
      });
      return false;
    } else if (SignConfirmPassController.text != SignPassController.text) {
      setState(() {
        signUpErrorMasseg = "ادخل نفس كلمة المرور في حقل تأكيد كلمة المرور";
      });
      return false;
    } else {
      return true;
    }
  }
}
