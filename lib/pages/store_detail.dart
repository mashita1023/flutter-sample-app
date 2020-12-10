import 'package:peer_route_app/configs/importer.dart';

/// 店舗の詳細ページ
/// 呼び出されたときに値を受け取る
/// 実際のデータはまだなのでまとめない
/// 表示するだけならStateless Widgetで問題ない
class StoreDetail extends StatefulWidget {
  int id;
  StoreDetail({this.id});

  @override
  _StoreDetailState createState() => _StoreDetailState();
}

/// 表示する内容
class _StoreDetailState extends State<StoreDetail> {
  /// 画面描写
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('店舗詳細'),
      ),
      body: FutureBuilder(
        future: Api.postStore(widget.id),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text('ID: ${snapshot.data[0]["STORE_ID"]}'),
                  Text('NAME: ${snapshot.data[0]["NAME"]}'),
                  Text('URL: ${snapshot.data[0]["URL"]}'),
                  Text('TEL: ${snapshot.data[0]["TEL"]}'),
                  Text('CREATED: ${snapshot.data[0]["CREATED_AT"]}'),
                  Text('OPEN: ${snapshot.data[0]["OPEN_TIME"]}'),
                  Text('CLOSE: ${snapshot.data[0]["CLOSE_TIME"]}'),
                  Text('PRIORITY: ${snapshot.data[0]["PRIORITY"]}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
