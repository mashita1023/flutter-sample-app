import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'package:peer_route_app/bottom_tab_bar.dart';

class ConfirmTeamsOfService extends StatefulWidget {
  @override
  _ConfirmTeamsOfServiceState createState() => _ConfirmTeamsOfServiceState();
}

class _ConfirmTeamsOfServiceState extends State<ConfirmTeamsOfService> {
  bool _read = false;
  final String _text =
      "あああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ\nあああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ";

  void _pushHome() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _read = true;
    await prefs.setBool('read', _read);
    if (_read) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return BottomTabBar();
      }));
    } else
      print('_read is false');
  }

// debug
  void switchRead() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _read = !prefs.getBool('read');
      if (_read == null) {
        _read = false;
      }
    });
    await prefs.setBool('read', _read);
    print('set _read:$_read');
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
                height: size.height - 300,
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
              SizedBox(height: 30),
              /*
                ボタンを画面サイズからpadding分だけ引いた値: (size.width-80)/2
                ボタン間の間も欲しいのでおおよそ20のmarginをとるとすると間の線が1なのでSizedBoxの幅は18
               */
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
                        onPressed: () => _pushHome(),
                        // SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                        child: Text("同意しません"),
                      )),
                ],
              ),
              RaisedButton(onPressed: switchRead)
            ],
          ),
        ),
      ),
    );
  }
}
