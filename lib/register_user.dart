import 'package:flutter/material.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {

  String _username = '';
  String _place = '新潟県 - 上越';
  String _gender = '男';

  List<String> _list = <String>['新潟県 - 上越', '新潟県 - 中越', '新潟県 - 下越'];

  void _handleUsername(String e){
    setState(() {
      _username = e;
    });
  }

  void _handlePlace(String e){
    setState(() {
      _place = e;
    });
  }

  void _handleGender(String e){
    setState(() {
      _gender = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register User Page'),
      ),
      body: Container(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: <Widget>[
            Text('ニックネーム'),
            new TextFormField(
              enabled: true,
              decoration: const InputDecoration(
                hintText: 'ニックネームを入力してください',
              ),
              onChanged: _handleUsername,
            ),

            Text('\n性別'),
            new RadioListTile(
              activeColor: Colors.blue,
              title: Text('男'),
              value: '男',
              groupValue: _gender,
              onChanged: _handleGender,
            ),
            new RadioListTile(
              activeColor: Colors.blue,
              title: Text('女'),
              value: '女',
              groupValue: _gender,
              onChanged: _handleGender,
            ),
            new RadioListTile(
              activeColor: Colors.blue,
              title: Text('その他'),
              value: 'その他',
              groupValue: _gender,
              onChanged: _handleGender,
            ),

            Text('\n出身地'),
            DropdownButton<String>(
              items: _list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: _handlePlace,
              value: _place,
              hint: Text('hello'),
            ),
            RaisedButton(
              onPressed: _submission,
              child: Text('登録'),
            )
          ]
        ),
      ),
    );
  }

  Future _submission() async {
    var value = await showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text('確認'),
        content: new Text('username:$_username\nplace:$_place\ngender:$_gender'),
        actions: <Widget>[
          new SimpleDialogOption(
            child: new Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
/*
  void _submission() {
    if (this._formKey.currentState.validate()){
      this._formKey.currentState.save();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
      print(this._username);
      print(this._password);
    }
  }
 */
}


