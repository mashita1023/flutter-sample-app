import 'package:peer_route_app/configs/importer.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

/// 店舗一覧を表示

class _ListPageState extends State<ListPage> {
  List userData;
  Future getStore;

  /// 呼び出されたときにgetStore()を実行
  @override
  void initState() {
    super.initState();
    getStore = Api.getStore();
  }

  /// 画面描写
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('店舗'),
        ),
        actions: <Widget>[
          Popup(),
        ],
      ),
      body: FutureBuilder(
        future: getStore,
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
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                return SizedBox(
                  height: 80,
                  child: Card(
                    child: InkWell(
                      onTap: () =>
                          tapFunc(int.parse(snapshot.data[index]['STORE_ID'])),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(snapshot.data[index]['NAME']),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// CardをタップしたときにStoreDetailに遷移する処理
  void tapFunc(int id) {
    logger.i('navigated $id StoreDetail.');
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return StoreDetail(id: id);
    }));
  }
}
