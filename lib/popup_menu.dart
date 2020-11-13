import 'package:flutter/material.dart';
import 'package:peer_route_app/register_user.dart';
import 'package:peer_route_app/teams_of_service.dart';

class Popup extends StatefulWidget {
  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  var _selectedValue = '0';
  var _usStates = ["利用者情報登録", "利用規約", "2"];
  List _status = ['利用者情報登録', '利用規約'];

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
      ],
    );
  }
}
