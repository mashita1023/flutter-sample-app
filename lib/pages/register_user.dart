import 'package:peer_route_app/configs/importer.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

/// 利用者登録のページ
/// [store] PermanentStore ユーザーIDを保存しておく場所
/// [_textEditingController] TextEditingController TextFieldの初期値を決める
/// [_name] String ニックネーム
/// [_age] String 年齢のKey
/// [_place] String 地域のKey
/// [_gender] String 性別のKey
/// [_selectedStores] List<int> お気に入りの店舗
/// [_placeList] Map<String, String> 地域一覧
/// [_ageList] Map<String, String> 年齢一覧
/// [_storeList] List<Map<String, dynamic>> 店舗一覧
class _RegisterUserState extends State<RegisterUser> {
  PermanentStore store = PermanentStore.getInstance();
  TextEditingController _textEditingController;

  String registerButtonText = '';

  String _name = '';
  String _age = '0';
  String _place = '0';
  String _gender = '0';
  List _selectedStores = [];

  Map<String, String> _placeList = {
    '0': '',
    '1': '新潟市北区',
    '2': '新潟市東区',
    '3': '新潟市中央区',
    '4': '新潟市江南区',
    '5': '新潟市秋葉区',
    '6': '新潟市南区',
    '7': '新潟市西区',
    '8': '新潟市西蒲区',
    '9': '新潟市外'
  };

  Map<String, String> _ageList = {
    '0': '',
    '1': '～10代',
    '2': '20代',
    '3': '30代',
    '4': '40代',
    '5': '50代',
    '6': '60代',
    '7': '70代～'
  };

  List<Map<String, dynamic>> _storeList = [];

  /// setter
  void _handleName(String e) {
    setState(() {
      _name = e;
    });
  }

  void _handleAge(String e) {
    setState(() {
      _age = e;
    });
  }

  void _handlePlace(e) {
    setState(() {
      _place = e;
    });
  }

  void _handleGender(String e) {
    setState(() {
      _gender = e;
    });
  }

  /// 呼び出されたときに行う処理
  @override
  void initState() {
    super.initState();
    _getStore();
    store.load();
    _getUserData(store.myID);
  }

// 店舗情報を取得する
  Future _getStore() async {
    logger.d('get store in user.');
    List data = await Api.getStore();
    data.forEach((element) {
      setState(() {
        _storeList.add(element);
      });
    });
  }

  /// ユーザー登録をしている場合そのデータを表示する変数に登録されているデータを代入する
  /// ボタンのテキストもここで変更する
  Future _getUserData(int myID) async {
    if (myID == 0) {
      registerButtonText = '登録';
      return;
    }
    Map userData = await Api.postUser(myID);
    List favorite = [];

    registerButtonText = '変更';
    for (int i = 1; i <= Constant.maxFavoriteStore; i++) {
      if (userData['FAV_STORE_ID_$i'] != '0') {
        favorite.add(int.parse(userData['FAV_STORE_ID_$i']));
      }
    }
    _textEditingController = new TextEditingController(text: userData['NAME']);
    setState(() => _name = userData['NAME']);
    setState(() => _place = userData['PLACE_ID']);
    setState(() => _age = userData['AGE_ID']);
    setState(() => _gender = userData['SEX_ID']);
    setState(() => _selectedStores = favorite);
  }

  /// チェックボックスのチェックを可変にも対応できる。
  /// [selectedStores]に[storeId]があるかどうかで判断するためvalueではcontainsを使う。
  void _onStoreSelected(bool selected, storeId) {
    if (_selectedStores.length < Constant.maxFavoriteStore && selected) {
      setState(() {
        _selectedStores.add(storeId);
      });
    } else {
      setState(() {
        _selectedStores.remove(storeId);
      });
    }
  }

  /// 画面描写
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Register User Page'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40.0),
          child: Column(children: <Widget>[
            contentName(size),
            contentPlace(size),
            contentAge(size),
            contentGender(size),
            contentStore(size),
            RaisedButton(
              onPressed: () => _submission(),
              child: Text(registerButtonText),
            )
          ]),
        ),
      ),
    );
  }

  /// ニックネーム入力
  Widget contentName(Size size) {
    return Row(
      children: <Widget>[
        SizedBox(
          height: 50,
          width: size.width / 2 - 65,
          child: Align(
            alignment: Alignment.center,
            child: Text('ニックネーム'),
          ),
        ),
        SizedBox(width: 25),
        Container(
          width: size.width / 2 - 40,
          child: TextField(
            controller: _textEditingController,
            style: TextStyle(height: 1),
            enabled: true,
            maxLines: 1,
            onChanged: _handleName,
          ),
        ),
      ],
    );
  }

  /// 地域選択
  Widget contentPlace(Size size) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: size.width / 2 - 65,
          child: Align(
            alignment: Alignment.center,
            child: Text('お住いの地域'),
          ),
        ),
        SizedBox(width: 25),
        DropdownButton<String>(
          items: _placeList.entries
              .map<DropdownMenuItem<String>>(
                  (MapEntry<String, String> e) => DropdownMenuItem<String>(
                        value: e.key,
                        child: Text(e.value),
                      ))
              .toList(),
          onChanged: _handlePlace,
          value: _place,
        ),
      ],
    );
  }

  /// 年齢入力
  Widget contentAge(Size size) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: size.width / 2 - 65,
          child: Align(
            alignment: Alignment.center,
            child: Text('年齢'),
          ),
        ),
        SizedBox(width: 45),
        DropdownButton<String>(
          items: _ageList.entries
              .map<DropdownMenuItem<String>>(
                  (MapEntry<String, String> e) => DropdownMenuItem<String>(
                        value: e.key,
                        child: Text(e.value),
                      ))
              .toList(),
          onChanged: _handleAge,
          value: _age,
        ),
      ],
    );
  }

  /// 性別選択
  Widget contentGender(Size size) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: size.width / 2 - 65,
          child: Align(
            alignment: Alignment.center,
            child: Text('性別'),
          ),
        ),
        Flexible(
          child: RadioListTile(
            activeColor: Colors.blue,
            title: Text('男'),
            value: '1',
            groupValue: _gender,
            onChanged: _handleGender,
          ),
        ),
        Flexible(
          child: RadioListTile(
            activeColor: Colors.blue,
            title: Text('女'),
            value: '2',
            groupValue: _gender,
            onChanged: _handleGender,
          ),
        ),
      ],
    );
  }

  /// 店舗選択
  Widget contentStore(Size size) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: size.width / 2 - 65,
              height: 50,
              child: Container(
                alignment: Alignment.center,
                child: Text('お気に入りの店舗'),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        GridView.builder(
          itemCount: _storeList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 3),
          itemBuilder: (BuildContext context, int index) {
            return checkBoxItem(index);
          },
        ),
      ],
    );
  }

  /// 店舗名を[index]で受けとりチェックボックスを作成する
  Widget checkBoxItem(int index) {
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: _selectedStores
                .contains(int.parse(_storeList[index]["STORE_ID"])),
            onChanged: (bool selected) {
              _onStoreSelected(
                  selected, int.parse(_storeList[index]["STORE_ID"]));
            },
          ),
          SizedBox(
            child: Text('${_storeList[index]["NAME"]}'),
          ),
        ],
      ),
    );
  }

  /// 登録ボタンをおしたときの処理
  /// ダイアログで入力したデータを確認できる
  Future _submission() async {
    logger.i('press register');
    if (validate()) {
      Map<String, String> request = {
        'id': '${store.myID}',
        'name': '$_name',
        'place': '$_place',
        'age': '$_age',
        'sex': '$_gender',
        'favorite1': '',
        'favorite2': '',
        'favorite3': ''
      };
      for (int i = 0; i < _selectedStores.length; i++) {
        request['favorite${i + 1}'] = '${_selectedStores[i]}';
      }
      if (_selectedStores.length < 2) {
        for (int i = _selectedStores.length - 1; i < 3; i++) {
          request['favorite${i + 1}'] = '0';
        }
      }
      showLoaderDialog();
      await Api.postRegisterUser(request).then((response) {
        store.myID = response['id'];
        store.save();
        Navigator.pop(context);
        showTextDialog('\n$registerButtonText が完了しました。', '');
        logger.i('registeration was successful');
      });
    }
  }

  /// バリデーションを行う。
  /// 適切な入力がされていないものをダイアログで通知する。
  bool validate() {
    String validText = '';
    if (_name == '') {
      validText += '\nニックネームが未入力です。';
    }
    if (_place == '0') {
      validText += '\nお住いの地域が選択されていません。';
    }
    if (_age == '0') {
      validText += '\n年齢が選択されていません。';
    }
    if (_gender == '') {
      validText += '\n性別が選択されていません。';
    }
    if (validText == '') return true;
    logger.w('Failed to validate check');
    showTextDialog(validText, 'エラー');
    return false;
  }

  /// テキストとOKのボタンを表示するダイアログ
  /// バリデーションと登録完了時のときに使用している。
  // ignore: missing_return
  Widget showTextDialog(String text, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text, textAlign: TextAlign.center),
          actions: [
            FlatButton(
                onPressed: () => Navigator.pop(context), child: Text('OK')),
          ],
        );
      },
    );
  }

  /// 登録中に操作できないようにインジケーターを表示するダイアログ
  // ignore: missing_return
  Widget showLoaderDialog() {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text("Loading..."),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
