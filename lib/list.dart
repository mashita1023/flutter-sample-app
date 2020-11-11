import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget{
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Map data;
  List userData;

  Future getData() async{
    http.Response res = await http.get("https://reqres.in/api/users?page=2");
    data = json.decode(res.body);
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
      body: ListView.builder(
        itemCount: userData == null ? 0 : userData.length,
        itemBuilder: (context, int index) {
          return Card(
            child: InkWell(
              onTap: () => tapFunc(index),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(userData[index]["avatar"]),
                  ),
                  Text("${userData[index]["first_name"]} ${userData[index]["last_name"]}")
                ],
              ),

            ),
          );
        }
      )
    );
  }
  
  void tapFunc(int index) {
    print("$index hihi");
    Navigator.of(context).push(MaterialPageRoute(builder: (context){return ListDetail(
      userId: userData[index]["id"],
      userEmail: userData[index]["email"],
      nameFirst: userData[index]["first_name"],
      nameLast: userData[index]["last_name"],
      linkAvatar: userData[index]["avatar"],
    );}));

  }
}

// ignore: must_be_immutable
class ListDetail extends StatefulWidget {
//  List userData;
  int userId;
  String userEmail, nameFirst, nameLast, linkAvatar;
  ListDetail({this.userId, this.userEmail, this.nameFirst, this.nameLast, this.linkAvatar});

  @override
  _ListDetailState createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail> {

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