import 'package:peer_route_app/configs/importer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

/// ホームのページ
class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NotificationDetails platformChannelSpecifics;
  DatabaseProvider db = DatabaseProvider.instance;

  var result;

  /// 起動時にプッシュ通知をするための設定とBLEを動かせるようにする。
  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocationLocation);
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    serviceEnabled();
  }

  /// 位置情報とBluetoothがONになっていることを確認する
  void serviceEnabled() async {
    logger.d('scanDevices');
    bool bluetoothIsOn = await Bluetooth.flutterBlue.isOn;
    bool locationIsOn = await Bluetooth.location.serviceEnabled();
    if (bluetoothIsOn && locationIsOn) {
      Bluetooth.scanDevices();
    } else if (!bluetoothIsOn && !locationIsOn) {
      WidgetHelper.showTextDialog('bluetoothと位置情報をONにして下さい', '', context);
    } else if (!bluetoothIsOn) {
      WidgetHelper.showTextDialog('bluetoohをONにしてください', '', context);
    } else {
      WidgetHelper.showTextDialog('位置情報をONにしてください', '', context);
    }
  }

  /// 通知をタップしたときに行うイベント
  Future onSelectNotification(String payload) async {
    var data = json.decode(payload);
    if (int.parse(data['coupon']) != 0) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CouponListDetail(id: int.parse(data['coupon'])),
          maintainState: false,
        ),
      );
    } else if (int.parse(data['store']) != 0) {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreDetail(id: int.parse(data['store'])),
            maintainState: false,
          ));
    }
  }

  /// iOS用のイベント
  Future onDidReceiveLocationLocation(
      int id, String title, String body, String payload) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(payload),
            )
          ],
        );
      },
    );
  }

  /// 画面描写
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text('ホーム'),
          ),
          // debug
          actions: <Widget>[
            Popup(),
          ]),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: <Widget>[
            Container(
              height: size.height - 200,
              width: size.width - 80,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: _contents(size),
            ),
          ],
        ),
      ),
    );
  }

  /// ローカルプッシュ通知をする
  /// flutterLocalNotificationsPlugin.show()でプッシュ通知を行っている
  /// クーポンIDを持っている場合は取得したとしてDBに追加する
  Future _onNotification(result) async {
    List list = await result;
    list.asMap().forEach((int index, element) async {
      if (int.parse(element["COUPON_ID"]) != 0) {
        try {
          Map<String, dynamic> row = {'coupon': element["COUPON_ID"]};
          db.insert(row);
          String payload = '{"coupon": "${element["COUPON_ID"]}"}';
          var data = json.decode(payload);
          print(data['coupon']);
          await flutterLocalNotificationsPlugin.show(
            index,
            'STREAM_ID' + element["STREAM_ID"],
            element["URL"],
            platformChannelSpecifics,
            payload: payload,
          );
        } catch (e) {
          logger.e(e);
        }
      } else if (int.parse(element["STORE_ID"]) != 0) {
        String payload = '{"coupon": "0", "store": "${element["STORE_ID"]}"}';
        var data = json.decode(payload);
        print(data['coupon']);
        await flutterLocalNotificationsPlugin.show(
          index,
          'STREAM_ID' + element["STREAM_ID"],
          element["URL"],
          platformChannelSpecifics,
          payload: payload,
        );
      }
    });
  }

  /// ホームに書かれる情報
  Widget _contents(Size size) {
    return Column(children: <Widget>[
      SizedBox(
        width: size.width - 100,
        child: Text(
          "新着情報",
          textAlign: TextAlign.left,
        ),
      ),
      SizedBox(
        width: size.width - 100,
        child: Text(
          '- 11/12',
          textAlign: TextAlign.left,
        ),
      ),
      SizedBox(
        width: size.width - 100,
        child: Text(
          '- 11/13',
          textAlign: TextAlign.left,
        ),
      ),
      SizedBox(
        child: RaisedButton(
          onPressed: () {
            result = Api.postBeacon();
            _onNotification(result);
          },
          child: Text('GET'),
        ),
      ),
    ]);
  }
}
