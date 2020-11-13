import 'package:flutter/material.dart';

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

  void _handleage(String e) {
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
          Row(
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
          ),
          Row(
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
                onChanged: _handleage,
                value: _age,
              ),
            ],
          ),
          Center(
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
          ),
          RaisedButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return RegisterUser();
            })),
            //onPressed: _submission,
            child: Text('登録'),
          )
        ]),
      ),
    );
  }

  Future _submission() async {
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
