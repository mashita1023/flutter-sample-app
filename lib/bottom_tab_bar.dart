import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:peer_route_app/coupon.dart';
import 'package:peer_route_app/notification.dart';
import 'package:peer_route_app/store_list.dart';
import 'package:peer_route_app/homepage.dart';

class BottomTabBar extends StatefulWidget {
  @override
  _BottomTabBarState createState() => _BottomTabBarState();
}

class Bluetooth with ChangeNotifier {}

class _BottomTabBarState extends State<BottomTabBar> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<ScanResult> devicesList = new List<ScanResult>();
  List deviceDetail = new List();

  _addDeviceTolist(final ScanResult device) {
    if (!devicesList.contains(device)) {
      setState(() {
        devicesList.add(device);
      });
    }
  }

  // ここでifなどの処理をする
  _sendData() {
    var data = _detail();
    print(data);
    for (var result in data) {
      if (result[2] == '000000-017c-1001-b000-001c4db7979b') {
        print('result: $result');
      }
    }
  }

  void scanDevices() {
    flutterBlue
        .scan(
      timeout: Duration(seconds: 20),
    )
        .listen((result) {
      if (result.device.name != '') {
        _addDeviceTolist(result);
        _sendData();
      }
    });
  }

  List _detail() {
    List returnData = new List();
    for (var device in devicesList) {
      var data =
          device.advertisementData.manufacturerData.values.first.toList();
      var uuid = '';
      var major = '';
      var minor = '';
      var txpower = '';

      uuid += data[3].toRadixString(16).padLeft(2, "0");
      uuid += data[4].toRadixString(16).padLeft(2, "0");
      uuid += data[5].toRadixString(16).padLeft(2, "0");
      uuid += '-';
      uuid += data[6].toRadixString(16).padLeft(2, "0");
      uuid += data[7].toRadixString(16).padLeft(2, "0");
      uuid += '-';
      uuid += data[8].toRadixString(16).padLeft(2, "0");
      uuid += data[9].toRadixString(16).padLeft(2, "0");
      uuid += '-';
      uuid += data[10].toRadixString(16).padLeft(2, "0");
      uuid += data[11].toRadixString(16).padLeft(2, "0");
      uuid += '-';
      uuid += data[12].toRadixString(16).padLeft(2, "0");
      uuid += data[13].toRadixString(16).padLeft(2, "0");
      uuid += data[14].toRadixString(16).padLeft(2, "0");
      uuid += data[15].toRadixString(16).padLeft(2, "0");
      uuid += data[16].toRadixString(16).padLeft(2, "0");
      uuid += data[17].toRadixString(16).padLeft(2, "0");

      major = data[18].toRadixString(16).padLeft(2, "0") +
          data[19].toRadixString(16).padLeft(2, "0");
      major = int.parse(major, radix: 16).toString();
      minor = data[20].toRadixString(16).padLeft(2, "0") +
          data[21].toRadixString(16).padLeft(2, "0");
      minor = int.parse(minor, radix: 16).toString();

      txpower = data[22].toSigned(8).toString();

      returnData.add(
          [device.device.name, device.device.id, uuid, major, minor, txpower]);
    }

    return returnData;
  }

  @override
  void initState() {
    super.initState();
    scanDevices();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // バックキー無効
      onWillPop: () async => false,
      child: CupertinoTabScaffold(
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
                  child: HomePage(devicesList: devicesList),
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
