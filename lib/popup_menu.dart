import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:peer_route_app/register_user.dart';
import 'package:peer_route_app/teams_of_service.dart';
import 'package:peer_route_app/bluetooth.dart';
import 'package:peer_route_app/scan_beacon.dart';

class Popup extends StatefulWidget {
  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  var _selectedValue = '0';
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
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
              return ScanBeacon();
            }));

            break;
          case '3':
//            scanDevices();
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
              return Bluetooth();
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
          child: Text('final'),
          value: '3',
        )
      ],
    );
  }

  void scanDevices() {
    _flutterBlue
        .scan(
      timeout: Duration(seconds: 3),
    )
        .listen((scanResult) {
      if (scanResult.device.name.isNotEmpty) {
        print("${scanResult.toString()}");
      }
    }, onDone: _flutterBlue.stopScan);
  }
}
