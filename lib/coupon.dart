import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CouponListPage extends StatefulWidget{
  @override
  _CouponListPageState createState() => _CouponListPageState();
}

class _CouponListPageState extends State<CouponListPage> {
  String jsonString;
  Map data;
  List userData;

  Future<void> getData() async{
    jsonString = await rootBundle.loadString("assets/data.json");
    data = json.decode(jsonString);
    print(data);
    setState(() {
      userData = data["data"];
    });
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
        title: Text('list page'),
      ),
      body: GridView.count(
          crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.0,
        shrinkWrap: true,
        children: List.generate(userData.length, (index) {
          return Card(
            child: InkWell(
              onTap: () => tapFunc(index),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text("${userData[index]["name"]}\n"),
                      Text("${userData[index]["detail"]}")
                    ],
                  )
                )
              )
            )
          );
        }),
      )
    );
  }

  void tapFunc(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context){return CouponListDetail(
      id: userData[index]["id"],
      name: userData[index]["name"],
      detail: userData[index]["detail"],
      place: userData[index]["place"],
    );}));

  }
}

// ignore: must_be_immutable
class CouponListDetail extends StatefulWidget {
//  List userData;
  int id;
  String place, detail, name;
  CouponListDetail({this.id, this.name, this.detail, this.place});

  @override
  _CouponListDetailState createState() => _CouponListDetailState();
}

class _CouponListDetailState extends State<CouponListDetail> {

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
              Text('id:${widget.id}'),
              Text('name:${widget.name}'),
              Text('detail:${widget.detail}'),
              Text('palce:${widget.place}')
            ],
          ),
        ),
      ),
    );
  }

}