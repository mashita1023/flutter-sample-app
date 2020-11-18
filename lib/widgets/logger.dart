import 'dart:async';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

final logger = Logger(printer: SimpleLogPrinter());

class SimpleLogPrinter extends LogPrinter {
  final _fileName = 'debug.log';
  String readData = '';

// ファイル出力も書く
  @override
  List<String> log(LogEvent event) {
    output(event.message);
    AnsiColor color = PrettyPrinter.levelColors[event.level];
    return [color('${event.level}: ${event.message}')];
  }

// ファイルに書き込み
  void output(message) async {
    File file = await getFilePath();
    await file.writeAsString(message + '\n', mode: FileMode.append);
  }

// 保存場所のパスを取得する
  Future<File> getFilePath() async {
    final directory = await getTemporaryDirectory();
    return File(directory.path + '/' + _fileName);
  }
}
