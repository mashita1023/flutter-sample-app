import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peer_route_app/bottom_tab_bar.dart';

class TeamsOfService extends StatefulWidget {
  @override
  _TeamsOfServiceState createState() => _TeamsOfServiceState();
}

class _TeamsOfServiceState extends State<TeamsOfService> {
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
                height: size.height - 200,
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
              RaisedButton(
                onPressed: switchRead,
                child: Text('change and confirm read?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
