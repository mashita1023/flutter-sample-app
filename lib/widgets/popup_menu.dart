import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:peer_route_app/pages/register_user.dart';
import 'package:peer_route_app/pages/teams_of_service.dart';
import 'package:peer_route_app/pages/bluetooth.dart';
import 'package:peer_route_app/widgets/logger.dart';
import 'package:peer_route_app/pages/read_file.dart';

class Popup extends StatefulWidget {
  //BlueTooth画面に渡すためのList (debug)
  List<ScanResult> devicesList = new List();
  Popup({this.devicesList});

  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  var _selectedValue = '0';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: _selectedValue,
      onSelected: (String s) {
        setState(() {
          _selectedValue = s;
        });
        switch (_selectedValue) {
          // 利用者情報画面へ遷移
          case '0':
            logger.i('navigated RegisterUser.');
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
              return RegisterUser();
            }));
            break;
          // 利用規約画面へ遷移
          case '1':
            logger.i('navigated TeamsOfService.');
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
              return TeamsOfService(isRead: true);
            }));
            break;
          // BlueTooth一覧画面へ遷移(debug)
          case '2':
            logger.i('navigated BlueTooth.');
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
              return Bluetooth(devicesList: widget.devicesList);
            }));
            break;
          // 出力表示画面へ遷移(debug)
          case '3':
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
              return ReadFile();
            }));
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: Text('利用者情報登録'),
          value: '0',
        ),
        PopupMenuItem<String>(
          child: Text('利用規約'),
          value: '1',
        ),
        PopupMenuItem(
          child: Text('Search'),
          value: '2',
        ),
        PopupMenuItem(
          child: Text('readFile'),
          value: '3',
        ),
      ],
    );
  }
}
