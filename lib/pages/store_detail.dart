import 'package:peer_route_app/configs/importer.dart';

/// 店舗の詳細ページ
/// 呼び出されたときに値を受け取る
/// 実際のデータはまだなのでまとめない
/// 表示するだけならStateless Widgetで問題ない
class StoreDetail extends StatefulWidget {
  int userId;
  String userEmail, nameFirst, nameLast, linkAvatar;
  StoreDetail(
      {this.userId,
      this.userEmail,
      this.nameFirst,
      this.nameLast,
      this.linkAvatar});

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
        title: Text('ItemDetail'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.linkAvatar),
              ),
              Text('id:${widget.userId}'),
              Text('email:${widget.userEmail}'),
              Text('name:${widget.nameFirst} ${widget.nameLast}'),
            ],
          ),
        ),
      ),
    );
  }
}
