import 'package:peer_route_app/configs/importer.dart';
import 'package:path_provider/path_provider.dart';

class ReadFile extends StatefulWidget {
  @override
  _ReadFileState createState() => _ReadFileState();
}

/// 書き込んだdebug.logを表示するdebug用ページ
/// [out]に出力結果を表示する
class _ReadFileState extends State<ReadFile> {
  String out = '';
  final _fileName = 'debug.log';

  /// 画面描写
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('display'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: RaisedButton(
                child: Text('読み込み'),
                onPressed: loadButton,
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text('reset'),
                onPressed: resetButton,
              ),
            ),
            Container(
              height: size.height - 200,
              padding: EdgeInsets.all(10),
              child: Scrollbar(
                isAlwaysShown: false,
                child: SingleChildScrollView(
                  child: Card(
                    child: Text('出力結果\n$out'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 読み込みをするボタンの処理
  void loadButton() async {
    setState(() {
      load().then((String value) {
        setState(() {
          out = value;
        });
      });
    });
  }

  /// debug.logをリセットするボタンの処理
  void resetButton() async {
    getFilePath().then((File file) {
      file.writeAsString('');
    });
  }

  /// ファイルのパスを取得して返す
  Future<File> getFilePath() async {
    final directory = await getTemporaryDirectory();
    return File(directory.path + '/' + _fileName);
  }

  /// ファイルを読み込んで返す
  Future<String> load() async {
    final file = await getFilePath();
    return file.readAsString();
  }
}
