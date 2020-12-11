import 'package:flutter/cupertino.dart';
import 'package:peer_route_app/configs/importer.dart';

class BottomTabBar extends StatefulWidget {
  @override
  _BottomTabBarState createState() => _BottomTabBarState();
}

/// footerのタブバーの表示
// それぞれのタブにスタックされていくため、Popupなどもスタックされてしまう
// その場合サイズに注意できればTabControllerをBottomTabBarに設定するといいかもしれない
// またはBottomTabBarをページごとに呼び出す
class _BottomTabBarState extends State<BottomTabBar> {
  /// 最初に呼び出されたときにBluetoothのスキャンを行う
  @override
  void initState() {
    super.initState();
  }

  /// 画面への表示
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      /// バックキー無効
      onWillPop: () async => false,
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          /// loggerのためのontap、[value]を受け取ってswitch
          onTap: (value) {
            switch (value) {
              case 0:
                logger.i('navigated HomePage.');
                break;
              case 1:
                logger.i('navigated StoreList.');
                break;
              case 2:
                logger.i('navigated CouponList.');
                break;
              case 3:
                logger.i('navigated Notification.');
                break;
            }
          },

          /// 左詰めで表示するもの
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('ホーム'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              title: Text('店舗'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('クーポン'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text('お知らせ'),
            ),
          ],
        ),

        /// タブの変更先と遷移。[value]を受け取ってswitch
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
        },
      ),
    );
  }
}
