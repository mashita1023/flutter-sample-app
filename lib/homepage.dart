import 'package:flutter/material.dart';
import 'package:peer_route_app/popup_menu.dart';
import 'package:flutter_blue/flutter_blue.dart';

class HomePage extends StatefulWidget {
  //debug
  List<ScanResult> devicesList = new List();
  HomePage({this.devicesList});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            Popup(devicesList: widget.devicesList),
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
              child: Column(children: <Widget>[
                SizedBox(
                  width: size.width - 100,
                  child: Text(
                    "お知らせ\n",
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
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
