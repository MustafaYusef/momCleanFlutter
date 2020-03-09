import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class signUp extends StatefulWidget {
  BuildContext context;
  bool flage;
  signUp(bool flage, BuildContext context){
    this.flage=flage;
    this.context=context;
  }

  @override
  _signUpState createState() => new _signUpState(flage,context);
}

class _signUpState extends State<signUp> {
  BuildContext context;
  bool flage;
  _signUpState(this.flage, this.context);

  @override
  Widget build(BuildContext context) {
    return new Column(children:<Widget>[
    Directionality(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Theme(
            data: new ThemeData(
              primaryColor: Colors.blueAccent,
              primaryColorDark: Colors.red,
            ),
            child: TextField(
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
                      },
                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      initialSelection: '+964',

                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                    ),
                  ),
                 
                  contentPadding:
                      EdgeInsets.only(left: 6, right: 6, top: 0, bottom: 15),
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
                  contentPadding:
                      EdgeInsets.only(left: 6, right: 6, top: 0, bottom: 15),
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
                  contentPadding:
                      EdgeInsets.only(left: 6, right: 6, top: 0, bottom: 15),
                  fillColor: Colors.white70),
              obscureText: flage,
            ),
          ),
        ),
        textDirection: TextDirection.rtl),
        
    Container(
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
            child: Text("دخول",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          onPressed: () {},
        ),
      ),
    )
  ]);
  }
}
