import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker_view/picker_view.dart';
import 'package:flutter_picker_view/picker_view_popup.dart';
import 'package:mom_clean/models/city.dart';
import 'package:mom_clean/repastory/Authrepasatory.dart';
import 'package:mom_clean/ui/auth/profile.dart';
import 'package:mom_clean/ui/custumWidget/customDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class updateProfile extends StatefulWidget {
  final String name;
  final String city;
  updateProfile(this.name, this.city);

  @override
  _updateProfileState createState() => new _updateProfileState();
}

class _updateProfileState extends State<updateProfile> {
  int CityId = 0;
  
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool isLoading = false;
@override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    nameController.text=widget.name;
     addressController.text=widget.city;
  }
  @override
  Widget build(BuildContext context) {
    // nameController.value = TextEditingValue(text: name);
    // addressController.value = TextEditingValue(text: city);
    //nameController.text=widget.name;
    //  addressController.text=widget.city;
    return Scaffold(
      endDrawer: drawar(index: 8),
      appBar: AppBar(
        centerTitle: true,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            "تعديل الحساب",
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
                height: 150,
              ),
              SizedBox(
                height: 10,
              ),
              Directionality(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Theme(
                      data: new ThemeData(
                        primaryColor: Colors.blueAccent,
                        primaryColorDark: Colors.red,
                      ),
                      child: TextField(
                        controller: nameController,
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
                            helperText: "يرجى ادخال السم الكامل",
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
                        enabled: !isLoading,
                        controller: addressController,
                        readOnly: true,
                        onTap: () async {
                          setState(() {
                                isLoading = true;
                              });
                          AuthRepastory repo = AuthRepastory();
                          try {
                            final citys = await repo.getCity();
                            _showPicker(citys);
                          } on SocketException catch (_) {
                            Toast.show("لا يوجد اتصال", context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          } on Exception catch (_) {
                            Toast.show(_.toString(), context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          }
                          setState(() {
                                isLoading = false;
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
                            labelText: "العنوان",
                            alignLabelWithHint: true,
                            hasFloatingPlaceholder: false,
                            labelStyle: TextStyle(
                                fontSize: 18,
                                backgroundColor: Colors.transparent,
                                decorationColor: Colors.transparent),
                            prefixIcon: const Icon(Icons.location_city),
                            suffixIcon:
                                const Icon(Icons.arrow_drop_down_circle),
                            contentPadding: EdgeInsets.only(
                                left: 6, right: 6, top: 0, bottom: 15),
                            fillColor: Colors.white70),
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                             
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              var token = await prefs.getString('token');

                              AuthRepastory repo = AuthRepastory();
                              try {
                                print("city id    "+CityId.toString());
                                final login = await repo.UpdateProfile(
                                    token, nameController.text, CityId);

                                //  print('saved token ${prefs.getString('token')}');
                                Toast.show("تم تحديث المعلومات", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);

                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (_) {
                                  return ProfileScreen();
                                }));
                              } on SocketDirection {
                                Toast.show("لا يوجد اتصال", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              } catch (e) {
                                Toast.show(e.toString(), context,
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
          addressController.value = TextEditingValue(
              text:
                  citys.data.cities[controller.selectedRowAt(section: 0)].name);

         
            CityId = citys.data.cities[controller.selectedRowAt(section: 0)].id;
        print(CityId);
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
}
