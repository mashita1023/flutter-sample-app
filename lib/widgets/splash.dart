import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peer_route_app/pages/teams_of_service.dart';
import 'package:peer_route_app/widgets/bottom_tab_bar.dart';
import 'package:peer_route_app/widgets/logger.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => logger.w('progress duration.'));
  }

// 起動画面のbool値をshaed preferenceからgetする
  Future<bool> getPrefRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isRead = prefs.getBool('read');
    if (isRead == null) {
      logger.w('prefs.read is null.');
      isRead = false;
    }
    logger.d('prefs.read: $isRead');
    return isRead;
  }

  @override
  Widget build(BuildContext context) {
    logger.i('navigated Splash.');
    return FutureBuilder(
      future: getPrefRead(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        final hasData = snapshot.hasData;
        if (hasData == false) {
          logger.w('can`t find snapshot data.');
          return CircularProgressIndicator();
        }

        final isRead = snapshot.data;
        var homeWidget;
        if (isRead) {
          logger.i('navigated BottomTabBar.');
          homeWidget = new BottomTabBar();
        } else {
          logger.i('navigated ConfirmTeamsOfSevice.');
          homeWidget = new TeamsOfService(isRead: isRead);
        }
        var app = new MaterialApp(
          title: "新潟",
          // 遷移した時の画面の表示の仕方を変更する
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
