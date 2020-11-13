import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peer_route_app/coupon.dart';
import 'package:peer_route_app/notification.dart';
import 'package:peer_route_app/store_list.dart';
import 'package:peer_route_app/homepage.dart';

class BottomTabBar extends StatefulWidget {
  @override
  _BottomTabBarState createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('ホーム')),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt), title: Text('店舗')),
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text('クーポン')),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text('お知らせ'),
            ),
          ],
        ),
        // ignore: missing_return
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: HomePage(),
                );
              });
            case 1:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: ListPage(),
                );
              });
            case 2:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: CouponListPage(),
                );
              });
            case 3:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: NotificationPage(),
                );
              });
          }
        });
  }
}
