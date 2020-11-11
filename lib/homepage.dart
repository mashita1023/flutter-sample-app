import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peer_route_app/coupon.dart';

import 'package:peer_route_app/footer.dart';
import 'package:peer_route_app/notification.dart';
import 'package:peer_route_app/register_user.dart';
import 'package:peer_route_app/list.dart';
import 'package:peer_route_app/coupon.dart';
import 'package:peer_route_app/teams_of_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('HOME')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text('NOTICE')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('LIST')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            title: Text('COUPON'),
          ),

        ],
      ),
      tabBuilder: (context, index){
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context){
              return CupertinoPageScaffold(
                  child: Home(),
              );
            });
          case 1:
            return CupertinoTabView(builder: (context){
              return CupertinoPageScaffold(
                child: NotificationPage(),
              );
            });
          case 2:
            return CupertinoTabView(builder: (context){
              return CupertinoPageScaffold(
                child: ListPage(),
              );
            });
          case 3:
            return CupertinoTabView(builder: (context){
              return CupertinoPageScaffold(
                child: CouponListPage(),
              );
            });

        }
      }
    );
  }
/*
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      bottomNavigationBar: Footer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Home',
            ),
            RaisedButton(
              onPressed: () => Navigator.of(context).pushNamed('/register_user'),
              child: Text('ユーザー登録'),
            ),
            RaisedButton(
              onPressed: () => Navigator.of(context).pushNamed('/tutorial'),
              child: Text('Tutorialへ'),
            ),
          ],
        ),
      ),
    );
  }
*/
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Home'),
        )
      ),
      body: Center(
        child:Container(
          padding: const EdgeInsets.all(40.0),
          child:Column(
            children: <Widget>[
              Container(
                height: 500,
                width: 200,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Text("いうおいうおいうおいうおいうおいうおいう"),
              ),
              RaisedButton(
    //              onPressed: () => Navigator.of(context).pushNamed('/register_user'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {return RegisterUser();}
                  )
                ),
                child: Text('ユーザー登録'),
              ),
              RaisedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context){return TeamsOfService();}
                  )
                ),
                child: Text('Tutorialへ'),
              ),
            ],
          ),
        ),
      )
    );
  }

}