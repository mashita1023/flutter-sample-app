import 'package:flutter/material.dart';

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
