import 'package:flutter/material.dart';

class Footer extends StatefulWidget{
  const Footer();

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int _selectedIndex = 0;

  final _bottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('HOME')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('HOME')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('HOME')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('HOME')
    ),
  ];

  void _onItemTapped(e){
    setState(() {
      _selectedIndex = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: _bottomNavigationBarItems,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.blue,
    );
  }
}

