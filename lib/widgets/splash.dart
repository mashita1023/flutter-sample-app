import 'package:peer_route_app/configs/importer.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

/// 最初に起動する画面
/// 利用規約を表示するかホームを表示するかを制御する
class _SplashState extends State<Splash> {
  /// 読み込み処理
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => logger.w('progress duration.'));
  }

  /// 起動画面のbool値[store.isAgree]を取得して返す
  Future<bool> getPrefRead() async {
    PermanentStore store = PermanentStore.getInstance();
    bool _read;
    await store.load();
    _read = store.isAgree;

    logger.d('prefs.isAgree: $_read');
    return _read;
  }

  /// 画面の構成
  /// futureでasync処理を指定しその結果がsnapshotとなる
  /// snapshotがデータを保持しているかを[hasData]に代入し、
  /// されていた場合データを[isRead]に代入し、結果によって[homeWidget]を変更する
  @override
  Widget build(BuildContext context) {
    logger.i('navigated Splash.');
    return FutureBuilder(
      future: getPrefRead(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        var hasData = snapshot.hasData;
        if (hasData == false) {
          logger.w('can`t find snapshot data.');
          return CircularProgressIndicator();
        }

        var isRead = snapshot.data;
        var homeWidget;
        if (isRead) {
          logger.i('navigated BottomTabBar.');
          homeWidget = new BottomTabBar();
        } else {
          logger.i('navigated ConfirmTeamsOfSevice.');
          homeWidget = new TeamsOfService();
        }
        var app = new MaterialApp(
          title: constant.appName,

          /// 遷移した時の画面の表示のアニメーションを変更する
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
