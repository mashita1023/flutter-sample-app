import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peer_route_app/confirm_teams_of_service.dart';
import 'package:peer_route_app/bottom_tab_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => print('splashState'));
  }

  Future<bool> getPrefRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isRead = prefs.getBool('read');
    print('isRead:$isRead');
    if (isRead == null) {
      print("isRead is null");
      isRead = false;
    }
    print('return _splashstate');
    return isRead;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPrefRead(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        print(snapshot);

        final hasData = snapshot.hasData;
        print('hasData:$hasData');
        if (hasData == false) {
          return CircularProgressIndicator();
        }

        final isRead = snapshot.data;
        print('isRead:$isRead');
        var homeWidget;
        if (isRead) {
          print('navigate home');
          homeWidget = new BottomTabBar();
        } else {
          print('navigate tutorial');
          homeWidget = new ConfirmTeamsOfService();
        }

        var app = new MaterialApp(
          title: "Splash",
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          home: homeWidget,
        );
        return app;
      },
    );
  }
}
