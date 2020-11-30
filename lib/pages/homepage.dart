import 'package:peer_route_app/configs/importer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

/// ホームのページ
class _HomePageState extends State<HomePage> {
  /// 画面描写
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text('ホーム'),
          ),
          // debug
          actions: <Widget>[
            Popup(),
          ]),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: <Widget>[
            Container(
              height: size.height - 200,
              width: size.width - 80,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: _contents(size),
            ),
          ],
        ),
      ),
    );
  }

  /// ホームに書かれる情報
  Widget _contents(Size size) {
    return Column(children: <Widget>[
      SizedBox(
        width: size.width - 100,
        child: Text(
          "新着情報",
          textAlign: TextAlign.left,
        ),
      ),
      SizedBox(
        width: size.width - 100,
        child: Text(
          '- 11/12',
          textAlign: TextAlign.left,
        ),
      ),
      SizedBox(
        width: size.width - 100,
        child: Text(
          '- 11/13',
          textAlign: TextAlign.left,
        ),
      ),
    ]);
  }
}
