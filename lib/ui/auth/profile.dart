import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/blocs/profilBloc.dart';
import 'package:mom_clean/models/profileRes.dart';
import 'package:mom_clean/repastory/Authrepasatory.dart';
import 'package:mom_clean/ui/auth/changePassword.dart';
import 'package:mom_clean/ui/auth/logInScreen.dart';
import 'package:mom_clean/ui/auth/updatePhoto.dart';
import 'package:mom_clean/ui/auth/updateProfile.dart';
import 'package:mom_clean/ui/custumWidget/customDrawer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../main.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => new _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawar(index: 8),
      appBar: AppBar(
        centerTitle: true,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            "معلومات الحساب",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            ProfileBloc(Repo: AuthRepastory())..add(FetchProfile()),
        child:
            BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          if (state is ProfileNetworkError) {
            return networkError("لا يوجد اتصال بالشبكة");
          }
          if (state is ProfileLoading) {
            return Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[circularProgress()],
            ));
          }
          if (state is ProfileLoaded) {
            return BuildContentState(state, context);
          }
          if (state is ProfileError) {
            return networkError(state.string);
          }
        }),
      ),
    );
  }
}

class networkError extends StatelessWidget {
  final msg;
  networkError(
    this.msg, {
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
          Text(msg),
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
                    BlocProvider.of<ProfileBloc>(context).add(FetchProfile());
                  }),
            ),
          ),
        ],
      ),
    ));
  }
}

class circularProgress extends StatelessWidget {
  const circularProgress({
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

class BuildContentState extends StatefulWidget {
  final state;
  final context;
  BuildContentState(this.state, this.context);

  @override
  _BuildContentStateState createState() => _BuildContentStateState();
}

class _BuildContentStateState extends State<BuildContentState> {
  ProfileBloc _postBloc;
  @override
  void initState() {
    super.initState();

    _postBloc = BlocProvider.of<ProfileBloc>(widget.context);
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    if (widget.state is ProfileLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (widget.state is ProfileLoaded) {
      return SmartRefresher(
        child: SingleChildScrollView(
            child: buildProfileBody(widget.state.profile)),
        enablePullDown: true,
        header: WaterDropMaterialHeader(),
        controller: _refreshController,
        onRefresh: () {
          BlocProvider.of<ProfileBloc>(widget.context).add(FetchProfile());
        },
      );
    }
  }
}

class buildProfileBody extends StatelessWidget {
  final profileRes data;
  const buildProfileBody(
    this.data, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        Container(
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: baseUrlImage + data.data.profile.photo,
                placeholder: (context, url) =>
                    Image.asset("assets/images/placeholder.png"),
                errorWidget: (context, url, error) =>
                    Image.asset("assets/images/placeholder.png"),
              ),
              // FadeInImage(
              //   placeholder: AssetImage("assets/images/placeholder.png"),
              //   fit: BoxFit.cover,
              //   image: NetworkImage(baseUrlImage + data.data.profile.photo),
              // ),
              InkWell(
                onTap: () {
                  // showGeneralDialog(
                  //   context: context,
                  //   barrierColor:
                  //       Colors.black12.withOpacity(0.6), // background color
                  //   barrierDismissible:
                  //       false, // should dialog be dismissed when tapped outside
                  //   barrierLabel: "Dialog", // label for barrier
                  //   transitionDuration: Duration(
                  //       milliseconds:
                  //           400), // how long it takes to popup dialog after button click
                  //   pageBuilder: (_, __, ___) {
                  //     // your widget implementation
                  //     return SizedBox.expand(
                  //       // makes widget fullscreen
                  //       child: FadeInImage(
                  //         placeholder:
                  //             AssetImage("assets/images/placeholder.png"),
                  //         fit: BoxFit.cover,
                  //         image: NetworkImage(
                  //             baseUrlImage + data.data.profile.photo),
                  //       ),
                  //     );
                  //   },
                  // );
                },
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [
                        0.15,
                        0.5
                      ],
                          colors: [
                        Colors.grey[600].withOpacity(0.7),
                        Colors.transparent
                      ])),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return ImageInput();
                      }));
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                    color: Colors.transparent,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Text("معلومات الحساب",
                style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        buildProfileRow(
          data.data.profile.name,
          Icon(Icons.person, color: Theme.of(context).primaryColor),
        ),
        Divider(
          height: 10,
        ),
        buildProfileRow(
          data.data.profile.phone,
          Icon(Icons.phone, color: Theme.of(context).primaryColor),
        ),
        Divider(
          height: 10,
        ),
        buildProfileRow(
          data.data.profile.city,
          Icon(Icons.location_on, color: Theme.of(context).primaryColor),
        ),
        Divider(
          height: 10,
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Text("إعدادات الحساب",
                style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          ),
        ),
        Divider(
          height: 10,
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return updateProfile(
                  data.data.profile.name, data.data.profile.city);
            }));
          },
          child: buildProfileRow(
            "تعديل المعلومات",
            Icon(Icons.settings_applications,
                color: Theme.of(context).primaryColor),
          ),
        ),
        Divider(
          height: 10,
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return changePassword();
            }));
          },
          child: buildProfileRow(
            "تغيير  كلمة المرور",
            Icon(Icons.lock_open, color: Theme.of(context).primaryColor),
          ),
        ),
        Divider(
          height: 10,
        ),
        InkWell(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', "");
            await prefs.setInt('notification', 0);
            await prefs.setInt('cart', 0);
            await prefs.setString('name', "");
            await prefs.setString('image', "");
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return LoginScreen();
            }));
          },
          child: buildProfileRow(
            "تسجيل الخروج",
            Icon(Icons.exit_to_app,
                textDirection: TextDirection.rtl,
                color: Theme.of(context).primaryColor),
          ),
        ),
        Divider(
          height: 10,
        ),
        SizedBox(
          height: 10,
        ),
      ]),
    );
  }
}

Widget buildProfileRow(String data, Widget icon) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        icon,
        SizedBox(
          width: 10,
        ),
        Text(data, style: TextStyle(fontSize: 18, color: Colors.grey[600])),
      ]),
    ),
  );
}
