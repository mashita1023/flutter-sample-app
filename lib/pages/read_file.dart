import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ReadFile extends StatefulWidget {
  @override
  _ReadFileState createState() => _ReadFileState();
}

class _ReadFileState extends State<ReadFile> {
  String out = '';
  final _fileName = 'debug.log';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('display'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: RaisedButton(
                child: Text('読み込み'),
                onPressed: loadButton,
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text('reset'),
                onPressed: resetButton,
              ),
            ),
            Container(
              height: size.height - 200,
              padding: EdgeInsets.all(10),
              child: Scrollbar(
                isAlwaysShown: false,
                child: SingleChildScrollView(
                  child: Card(
                    child: Text('出力結果\n$out'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadButton() async {
    setState(() {
      load().then((String value) {
        setState(() {
          out = value;
        });
      });
    });
  }

  void resetButton() async {
    getFilePath().then((File file) {
      file.writeAsString('');
    });
  }

  Future<File> getFilePath() async {
    final directory = await getTemporaryDirectory();
    return File(directory.path + '/' + _fileName);
  }

  Future<String> load() async {
    final file = await getFilePath();
    return file.readAsString();
  }
}
