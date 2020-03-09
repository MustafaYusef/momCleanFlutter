import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:mom_clean/ui/auth/profile.dart';
import 'package:mom_clean/ui/custumWidget/customDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageInput();
  }
}

class _ImageInput extends State<ImageInput> {
  // To store the file provided by the image_picker
  File _imageFile;
  // To track the file uploading state
  bool _isUploading = false;
  String baseUrl = 'https://maamclean.com/auth/photo';

  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = image;
    });
    // Closes the bottom sheet
    Navigator.pop(context);
  }

  Future<bool> _uploadImage(File image) async {
    setState(() {
      _isUploading = true;
    });
    // Find the mime type of the selected file by looking at the header bytes of the file
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('PUT', Uri.parse(baseUrl));
    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    // Explicitly pass the extension of the image with request body
    // Since image_picker has some bugs due which it mixes up
    // image extension with file name like this filenamejpge
    // Which creates some problem at the server side to manage
    // or verify the file extension

    //imageUploadRequest.fields['ext'] = mimeTypeData[1];
    imageUploadRequest.files.add(file);
    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
          var token= await prefs.getString('token');
    imageUploadRequest.headers.addAll({
      "Authorization":token
    });
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 ||response.statusCode == 201)
       {
          final Map<String, dynamic> responseData = json.decode(response.body);
          print(responseData);
       return true;
      }else{
        return false;
      }
      print("response " + response.body);

    } catch (e) {
      print(e);
      return false;
    }
  }

  void _startUploading() async {
    final bool response = await _uploadImage(_imageFile);
    print(response);
    // Check if any error occured
    if (response) {
      Toast.show("تم تحديث الصورة بنجاح", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
                      return ProfileScreen();
                    }));
    } else {
      _resetState();
     Toast.show("فشل في الأرسال", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _resetState() {
    setState(() {
      _isUploading = false;
      _imageFile = null;
    });
  }

  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    print('Image Picker Modal Called');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 180.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Directionality(
                    child: Text(
                      'أختر صورة',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Divider(
                  height: 3,
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Directionality(
                    child: Text('ألتقاط صورة', style: TextStyle(fontSize: 16)),
                    textDirection: TextDirection.rtl,
                  ),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                Divider(
                  height: 3,
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Directionality(
                    child: Text('من المعرض', style: TextStyle(fontSize: 16)),
                    textDirection: TextDirection.rtl,
                  ),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget _buildUploadBtn() {
    Widget btnWidget = Container();
    if (_isUploading) {
      // File is being uploaded then show a progress indicator
      btnWidget = Container(
          margin: EdgeInsets.only(top: 10.0),
          child: circularProgress());
    } else if (!_isUploading && _imageFile != null) {
      // If image is picked by the user then show a upload btn
      btnWidget = Container(
        margin: EdgeInsets.only(top: 10.0),
        child: RaisedButton(
          
          child: Directionality(textDirection: TextDirection.rtl,
            child: Text('أرسال',style: TextStyle(fontSize: 18),)),
          onPressed: () {
            _startUploading();
          },
          color:Theme.of(context).primaryColor,
          textColor: Colors.white,
        ),
      );
    }
    return btnWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       endDrawer: drawar(index: 8),
      appBar: AppBar(
        centerTitle: true,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            "تغيير الصورة الشخصية",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
     
    
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
            child: OutlineButton(
              onPressed: () => _openImagePickerModal(context),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.camera_alt),
                  SizedBox(
                    width: 5.0,
                  ),
                  Directionality(
                    child: Text('أختر صورة'),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ),
          _imageFile == null
              ? Directionality(
                  child: Text('يرجى اختير صوره'),
                  textDirection: TextDirection.rtl,
                )
              : Image.file(
                  _imageFile,
                  fit: BoxFit.cover,
                  height: 300.0,
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width,
                ),
          _buildUploadBtn(),
        ],
      ),
    );
  }
}
