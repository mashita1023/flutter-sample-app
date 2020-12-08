import 'package:flutter/material.dart';
import 'package:peer_route_app/configs/importer.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CouponListDetail extends StatefulWidget {
  var id;

  CouponListDetail({this.id});

  @override
  _CouponListDetailState createState() => _CouponListDetailState();
}

class _CouponListDetailState extends State<CouponListDetail> {
// 確認用
  void print_row() async {
    var data = db.queryAllRows();
    List result = await data;
    print(result.toString());
/*
    Directory documentsDirectory =
        await getApplicationDocumentsDirectory(); // アプリケーション専用のファイルを配置するディレクトリへのパスを返す
    String path =
        join(documentsDirectory.path, "peer_bandai.db"); // joinはセパレーターでつなぐ関数
    deleteDatabase(path);
  */
  }

  /// 画面描写
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ItemDetail'),
      ),
      body: FutureBuilder(
        future: api.postCoupon(widget.id),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.error != null || !snapshot.hasData) {
            return Center(
              child: Text('データを取得できませんでした。'),
            );
          }
          print_row();
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text("coupon_id: ${snapshot.data[0]["COUPON_ID"]}"),
                  Text("content: ${snapshot.data[0]["CONTENT"]}"),
                  Text("type_id: ${snapshot.data[0]["TYPE_ID"]}"),
                  Text("store_id: ${snapshot.data[0]["STORE_ID"]}"),
                  Text("start_date: ${snapshot.data[0]["START_DATE"]}"),
                  Text("finish_date: ${snapshot.data[0]["FINISH_DATE"]}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
