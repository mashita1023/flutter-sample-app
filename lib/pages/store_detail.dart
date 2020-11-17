import 'package:flutter/material.dart';

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

class _StoreDetailState extends State<StoreDetail> {
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
