import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget{
@override
_NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notification'),
      ),
      body: Text('notification'),
    );
  }
}