import 'package:flutter/material.dart';
import 'package:peer_route_app/widgets/logger.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  String _age = '10代';
  String _place = '新潟県 - 上越';
  String _gender = '男';

  List<String> _placeList = <String>['新潟県 - 上越', '新潟県 - 中越', '新潟県 - 下越'];
  List<String> _ageList = <String>['10代', '20代', '30代', '40代', '50代', '60代'];

// setter
  void _handleAge(String e) {
    setState(() {
      _age = e;
    });
  }

  void _handlePlace(String e) {
    setState(() {
      _place = e;
    });
  }

  void _handleGender(String e) {
    setState(() {
      _gender = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Register User Page'),
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(children: <Widget>[
          contentPlace(size),
          contentAge(size),
          contentGender(size),
          RaisedButton(
            onPressed: _submission,
            child: Text('登録'),
          )
        ]),
      ),
    );
  }

// 地域選択
  Widget contentPlace(Size size) {
    return Row(
      children: [
        SizedBox(
          height: 100,
          width: size.width / 2 - 40,
          child: Text('お住いの地域'),
        ),
        DropdownButton<String>(
          items: _placeList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: _handlePlace,
          value: _place,
        ),
      ],
    );
  }

// 年齢入力
  Widget contentAge(Size size) {
    return Row(
      children: [
        SizedBox(
          height: 100,
          width: size.width / 2 - 40,
          child: Text('年齢'),
        ),
        DropdownButton<String>(
          items: _ageList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: _handleAge,
          value: _age,
        ),
      ],
    );
  }

// 性別選択
  Widget contentGender(Size size) {
    return Center(
      child: Row(
        children: [
          SizedBox(
            height: 100,
            width: size.width / 2 - 65,
            child: Text('性別'),
          ),
          Flexible(
            child: RadioListTile(
              activeColor: Colors.blue,
              title: Text('男'),
              value: '男',
              groupValue: _gender,
              onChanged: _handleGender,
            ),
          ),
          Flexible(
            child: RadioListTile(
              activeColor: Colors.blue,
              title: Text('女'),
              value: '女',
              groupValue: _gender,
              onChanged: _handleGender,
            ),
          ),
        ],
      ),
    );
  }

// 登録ボタンをおしたときの処理
// ダイアログで入力したデータを確認できる
  Future _submission() async {
    logger.i('press register button.');
    var value = await showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text('確認'),
        content: new Text('place:$_place\nage:$_age\ngender:$_gender'),
        actions: <Widget>[
          new SimpleDialogOption(
            child: new Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
    return value;
  }
}
