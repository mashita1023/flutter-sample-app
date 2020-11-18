import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:peer_route_app/widgets/popup_menu.dart';
import 'package:peer_route_app/pages/store_detail.dart';
import 'package:peer_route_app/widgets/logger.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Map data;
  List userData;

// APIからGETする処理
  Future getData() async {
    try {
      http.Response res = await http.get("https://reqres.in/api/users?page=2");
      data = json.decode(res.body);
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

// CardをタップしたときにStoreDetailに遷移する処理
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
