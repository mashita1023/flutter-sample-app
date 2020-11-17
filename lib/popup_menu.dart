import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:peer_route_app/register_user.dart';
import 'package:peer_route_app/teams_of_service.dart';
import 'package:peer_route_app/bluetooth.dart';

class Popup extends StatefulWidget {
  //debug
  List<ScanResult> devicesList = new List();
  Popup({this.devicesList});

  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  var _selectedValue = '0';
  //debug
  final FlutterBlue _flutterBlue = FlutterBlue.instance;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: _selectedValue,
      onSelected: (String s) {
        setState(() {
          _selectedValue = s;
        });
        switch (_selectedValue) {
          case '0':
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
              return RegisterUser();
            }));
            break;
          case '1':
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
              return TeamsOfService();
            }));
            break;
          case '2':
// debug
            print(widget.devicesList);
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
              return Bluetooth(devicesList: widget.devicesList);
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
      ],
    );
  }
}
