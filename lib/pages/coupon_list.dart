import 'package:peer_route_app/configs/importer.dart';

class CouponListPage extends StatefulWidget {
  @override
  _CouponListPageState createState() => _CouponListPageState();
}

class _CouponListPageState extends State<CouponListPage> {
  String jsonString;
  Map data;
  List userData = [];

  /// assets/data.jsonを読み込む処理
  Future<void> getData() async {
    try {
      jsonString = await rootBundle.loadString("assets/data.json");
      data = json.decode(jsonString);
      setState(() {
        userData = data["data"];
      });
    } catch (err) {
      logger.e('don`t response. error message: $err');
    }
  }

  /// クラスが呼び出されたときの処理
  @override
  void initState() {
    super.initState();
    getData();
  }

  /// 表示するクーポンだけを選別する
  /// 以前に取得したことがあるデータベースに保存されているクーポンだけを返す
  /// Future型なのでListにするためにawaitしている
  /// [useData]にMapになっているクーポンIDだけをListにして取り出す
  /// [result]に対象のものだけをいれて返す
  // ignore: non_constant_identifier_names
  Future display_coupon_list() async {
    List list = await api.getCoupon();
    List dbList = await db.queryAllRows();

    List useData = [];
    dbList.forEach((element) {
      //debug
      if (element['coupon'] != 0) {
        useData.add(element['coupon']);
      }
    });

    List result = [];
    list.forEach((element) {
      if (useData.contains(int.parse(element['COUPON_ID']))) {
        result.add(element);
      }
    });

    logger.d('get display_coupon_list');

    return result;
  }

  /// 画面描写
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('クーポン'),
        ),
        actions: <Widget>[
          Popup(),
        ],
      ),
      body: FutureBuilder(
          future: display_coupon_list(),
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
                child: Text('現在クーポンを取得していません'),
              );
            }

            return Container(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      InkWell(
                        onTap: () => tapFunc(
                            int.parse(snapshot.data[index]['COUPON_ID'])),
                        child: SizedBox(
                          height: 100,
                          width: (size.width - 20) / 2,
                          child: Card(
                            child: Row(
                              children: <Widget>[
                                Text(snapshot.data[index]['COUPON_ID']),
                                Text(snapshot.data[index]['CONTENT']),
                              ],
                            ),
                          ),
                        ),
                      ),
                      timeWidget(snapshot.data[index]),
                    ],
                  );
                },
              ),
            );
          }),
    );
  }

  /// Cardの右側の日付の表示
  /// start_dateとfinish_dateによって表示するテキストを変更する
  Widget timeWidget(data) {
    var text;
    if (data["START_DATE"] == null || data["FINISH_DATE"] == null) {
      text = 'undefined';
    } else {
      String start = data["START_DATE"].substring(5, 11).replaceAll('-', '/');
      String finish = data["FINISH_DATE"].substring(5, 11).replaceAll('-', '/');
      text = '$start ~ $finish';
    }
    return Align(
      alignment: Alignment.center,
      child: Text(text),
    );
  }

  /// CardをタップしたときにCouponDetailに遷移する処理
  void tapFunc(int id) {
    logger.i('navigated CouponDetail.');
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CouponListDetail(
        id: id,
      );
    }));
  }
}
