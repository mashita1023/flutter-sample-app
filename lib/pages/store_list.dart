import 'package:http/http.dart' as http;
import 'package:peer_route_app/configs/importer.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

/// 店舗一覧を表示

class _ListPageState extends State<ListPage> {
  List userData;

  /// APIからGETしたJSONをdecodeしたデータを[data]に代入し、
  /// 必要情報だけを取り出したものを[userData]に代入する
  Future getData() async {
    try {
      http.Response res = await http.get("https://reqres.in/api/users?page=2");
      Map data = json.decode(res.body);
      setState(() {
        userData = data["data"];
      });
    } catch (err) {
      logger.e('don`t response. error message: $err');
    }
  }

  /// 呼び出されたときにgetData()を実行
  @override
  void initState() {
    super.initState();
    getData();
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
        body: ListView.builder(
            itemCount: userData == null ? 0 : userData.length,
            itemBuilder: (context, int index) {
              return Card(
                child: InkWell(
                  onTap: () => tapFunc(index),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(userData[index]["avatar"]),
                      ),
                      Text(
                          "${userData[index]["first_name"]} ${userData[index]["last_name"]}")
                    ],
                  ),
                ),
              );
            }));
  }

  /// CardをタップしたときにStoreDetailに遷移する処理
  void tapFunc(int index) {
    logger.i('navigated StoreDetail.');
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return StoreDetail(
        userId: userData[index]["id"],
        userEmail: userData[index]["email"],
        nameFirst: userData[index]["first_name"],
        nameLast: userData[index]["last_name"],
        linkAvatar: userData[index]["avatar"],
      );
    }));
  }
}
