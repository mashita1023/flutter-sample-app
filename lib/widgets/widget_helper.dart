import 'package:flutter/material.dart';

class WidgetHelper {
  /// タイトルとテキストとOKのボタンを表示するダイアログ
  // ignore: missing_return
  static Widget showTextDialog(
      String text, String title, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text, textAlign: TextAlign.center),
          actions: [
            FlatButton(
                onPressed: () => Navigator.pop(context), child: Text('OK')),
          ],
        );
      },
    );
  }

  /// 登録中に操作できないようにインジケーターを表示するダイアログ
  // ignore: missing_return
  static Widget showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text("Loading..."),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
