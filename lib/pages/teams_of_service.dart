import 'package:peer_route_app/configs/importer.dart';

class TeamsOfService extends StatefulWidget {
  @override
  _TeamsOfServiceState createState() => _TeamsOfServiceState();
}

/// 利用規約を表示する
/// [store.isAgree]の値によって[cardHeight]の値を変更する
/// 取得した規約を[_text]に代入して表示する
class _TeamsOfServiceState extends State<TeamsOfService> {
  double cardHeight;
  final String _text =
      "あああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ\nあああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ";

  /// [store.isAgree]の値によって[cardHeight]を変更する
  void initState() {
    super.initState();
    if (_getAgree()) {
      setState(() {
        cardHeight = 200.0;
      });
    } else {
      setState(() {
        // 250に変更(debug)
        cardHeight = 300.0;
      });
    }
  }

  /// [store.isAgree]を取得する
  bool _getAgree() {
    PermanentStore store = PermanentStore.getInstance();
    store.load();
    return store.isAgree;
  }

  /// 同意した時の処理
  /// [store.isAgree]をtrueにして[HelpPage]を表示
  void _pushHelp() async {
    PermanentStore store = PermanentStore.getInstance();
    store.isAgree = true;
    await store.save();
    if (store.isAgree) {
      logger.i('navigated HelpPage.');
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return Helppage();
      }));
    } else {
      logger.e('prefs read can`t change true');
    }
  }

  /// 同意しなかったときの処理
  void _refuseConfirm() {
    logger.i('refuse confirm.');
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  /// [store.isAgree]をスイッチする処理(debug)
  void switchRead() async {
    PermanentStore store = PermanentStore.getInstance();
    store.isAgree = !store.isAgree;
    store.save();
    logger.d('change prefs read = ${store.isAgree}');
  }

  /// 画面描写
  /// 画面のサイズを[size]に取得する
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('利用規約'),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: size.height - cardHeight,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1)),
                child: Scrollbar(
                  isAlwaysShown: false,
                  child: SingleChildScrollView(
                    child: Text("$_text"),
                  ),
                ),
              ),
              confirm(size),
              /*
                ボタンを画面サイズからpadding分だけ引いた値: (size.width-80)/2
                ボタン間の間も欲しいのでおおよそ20のmarginをとるとすると間の線が1なのでSizedBoxの幅は18
               */
              RaisedButton(
                child: Text('change prefs read value'),
                onPressed: switchRead,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 同意ボタンを[store.isAgree]の値によって表示する
  Widget confirm(Size size) {
    if (!_getAgree()) {
      return Column(children: <Widget>[
        SizedBox(height: 30),
        Row(
          children: <Widget>[
            SizedBox(
              width: (size.width - 100) / 2,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () => _pushHelp(),
                child: Text('同意します'),
              ),
            ),
            SizedBox(width: 18),
            SizedBox(
                width: (size.width - 100) / 2,
                child: RaisedButton(
                  onPressed: () => _refuseConfirm(),
                  child: Text("同意しません"),
                )),
          ],
        )
      ]);
    }
    return SizedBox(height: 10);
  }
}
