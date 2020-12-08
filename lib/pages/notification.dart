import 'package:peer_route_app/configs/importer.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

/// お知らせページ
class _NotificationState extends State<NotificationPage> {
  /// 画面描写
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('お知らせ'),
        ),
        actions: <Widget>[
          Popup(),
        ],
      ),
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

  /// お知らせの内容
  Widget _contents(Size size) {
    return Column(children: <Widget>[
      SizedBox(
        width: size.width - 100,
        child: Text(
          "お知らせをひょうじ",
          textAlign: TextAlign.left,
        ),
      ),
    ]);
  }
}
