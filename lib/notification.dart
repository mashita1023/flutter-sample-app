import 'package:flutter/material.dart';
import 'package:peer_route_app/popup_menu.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('お知らせ'),
        ),
        actions: <Widget>[
          Popup(),
        ],
      ),
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
                    "お知らせをひょうじ",
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
