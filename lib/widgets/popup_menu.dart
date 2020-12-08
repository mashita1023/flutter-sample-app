import 'package:peer_route_app/configs/importer.dart';

/// Bluetoothの読み込み結果をデバッグ用ページに渡すために[deviceList]を受け取っている
class Popup extends StatefulWidget {
  @override
  _PopupState createState() => _PopupState();
}

/// headerのメニューボタンの処理をする
/// タップされた場所によって[selectedValue]が返されその結果で遷移先を変更する
class _PopupState extends State<Popup> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String selectedValue) {
        switch (selectedValue) {

          /// 利用者情報画面へ遷移
          case '0':
            logger.i('navigated RegisterUser.');
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
              return RegisterUser();
            }));
            break;

          /// 利用規約画面へ遷移
          case '1':
            logger.i('navigated TeamsOfService.');
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
              return TeamsOfService();
            }));
            break;

          /// BlueTooth一覧画面へ遷移(debug)
          case '2':
            logger.i('navigated BlueTooth.');
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
              return BluetoothList();
            }));
            break;

          /// 出力表示画面へ遷移(debug)
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

      /// 表示するアイテム一覧
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
