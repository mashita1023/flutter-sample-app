import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peer_route_app/widgets/bottom_tab_bar.dart';
import 'package:peer_route_app/widgets/logger.dart';

class TeamsOfService extends StatefulWidget {
  bool isRead;
  TeamsOfService({this.isRead});

  @override
  _TeamsOfServiceState createState() => _TeamsOfServiceState();
}

class _TeamsOfServiceState extends State<TeamsOfService> {
  bool _read = false;
  double cardHeight;
  final String _text =
      "あああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ\nあああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ";

  void initState() {
    super.initState();
    if (widget.isRead) {
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

// 同意した時の処理
  void _pushHome() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _read = true;
    await prefs.setBool('read', _read);
    if (_read) {
      logger.i('navigated BottomTabBar.');
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return BottomTabBar();
      }));
    } else {
      logger.e('prefs read can`t change true');
    }
  }

// 同意しなかったときの処理
  void _refuseConfirm() {
    logger.i('refuse confirm.');
    _pushHome();
//    SystemChannels.platform.invokeMethod('SystemNavigator.pop')
  }

// shared preferencesのread値のスイッチ(debug)
  void switchRead() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _read = !prefs.getBool('read');
      if (_read == null) {
        _read = false;
      }
    });
    await prefs.setBool('read', _read);
    logger.d('change prefs read = $_read');
  }

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

  Widget confirm(Size size) {
    if (!widget.isRead) {
      return Column(children: <Widget>[
        SizedBox(height: 30),
        Row(
          children: <Widget>[
            SizedBox(
              width: (size.width - 100) / 2,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () => _pushHome(),
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
