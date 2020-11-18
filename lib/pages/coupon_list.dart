import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:peer_route_app/widgets/popup_menu.dart';
import 'package:peer_route_app/pages/coupon_detail.dart';
import 'package:peer_route_app/widgets/logger.dart';

class CouponListPage extends StatefulWidget {
  @override
  _CouponListPageState createState() => _CouponListPageState();
}

class _CouponListPageState extends State<CouponListPage> {
  String jsonString;
  Map data;
  List userData = [];

// assets/data.jsonを読み込む処理
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

  @override
  void initState() {
    super.initState();
    getData();
  }

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
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(userData.length, (index) {
                return Card(
                  child: InkWell(
                    onTap: () => tapFunc(index),
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 30,
                        right: 30,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: (size.width - 60) / 2,
                            height: size.height / 8,
                            child: Container(
                              decoration: BoxDecoration(border: Border.all()),
                              child: Text("${userData[index]["name"]}"),
                            ),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            width: (size.width - 120) / 2,
                            height: size.height / 8,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${userData[index]["start-date"]}～${userData[index]["finish-date"]}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ));
  }

// CardをタップしたときにCouponDetailに遷移する処理
  void tapFunc(int index) {
    logger.i('navigated CouponDetail.');
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CouponListDetail(
        id: userData[index]["id"],
        name: userData[index]["name"],
        detail: userData[index]["detail"],
        place: userData[index]["place"],
      );
    }));
  }
}
