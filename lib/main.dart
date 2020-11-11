import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peer_route_app/teams_of_service.dart';
import 'package:peer_route_app/homepage.dart';
import 'package:peer_route_app/register_user.dart';

void main() {
  runApp(Splash());
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
        () => print('splashState')
    );
  }
  Future<bool> getPrefRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isRead = prefs.getBool('read');
    print('isRead:$isRead');
    if(isRead == null){
      print("isRead is null");
      isRead = false;
    }
    print('return _splashstate');
    return isRead;
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future: getPrefRead(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        print (snapshot);

        final hasData = snapshot.hasData;
        print('hasData:$hasData');
        if (hasData == false) {
          return CircularProgressIndicator();
        }

        final isRead = snapshot.data;
        print('isRead:$isRead');
        var homeWidget;
        if(isRead) {
          print('navigate home');
          homeWidget = new HomePage();
          //Navigator.of(context).pushReplacementNamed('/home');
        } else {
          print('navigate tutorial');
          homeWidget = new TeamsOfService();
          //Navigator.of(context).pushReplacementNamed('/tutorial');
        }

        var app = new MaterialApp (
          title: "Splash",
          home: homeWidget,
          routes: <String, WidgetBuilder> {
            '/homepage': (_) => new HomePage(),
            '/tutorial': (_) => new TeamsOfService(),
            '/register_user': (_) => new RegisterUser(),
            '/home': (_) => new Home(),
          },
        );
        return app;
      },
    );
  }

}

