import 'package:peer_route_app/configs/importer.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

/// お知らせページ
/// [getNotification] Future 最初にビルドしたときだけAPIをたたくための変数
class _NotificationState extends State<NotificationPage> {
  Future getNotification;

  /// 呼び出されたときに[getNotification]にAPIを叩いてデータを代入
  @override
  void initState() {
    super.initState();

    getNotification = Api.getNotification();
  }

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
      body: FutureBuilder(
        future: getNotification,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.error != null) {
            return Center(
              child: Text('データを取得できませんでした'),
            );
          }

          if (snapshot.data.length == 0) {
            return Align(
              alignment: Alignment.center,
              child: Text('現在店舗情報を取得できていません'),
            );
          }
          return Container(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: size.height - 200,
                  width: size.width - 80,
                  padding: const EdgeInsets.all(10.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _contents(size, snapshot.data),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// お知らせの内容
  /// 15文字だけをタイトルとして表示する
  Widget _contents(Size size, data) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        String text = data[index]['MESSAGE'].length < 15
            ? data[index]['MESSAGE']
            : data[index]['MESSAGE'].substring(0, 15);
        return SizedBox(
          height: (size.height - 220) / 5,
          child: Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide())),
            child: InkWell(
              onTap: () => showTextDialog(data[index]['MESSAGE']),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(text, textAlign: TextAlign.justify),
              ),
            ),
          ),
        );
      },
    );
  }

  /// お知らせの詳細内容をダイアログで表示する
  // ignore: missing_return
  Widget showTextDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text(text, textAlign: TextAlign.center),
          actions: [
            FlatButton(
                onPressed: () => Navigator.maybePop(context),
                child: Text('OK')),
          ],
        );
      },
    );
  }
}
