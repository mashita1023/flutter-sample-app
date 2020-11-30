import 'dart:async';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

/// [logger]でログを取るための定数
final logger = Logger(printer: SimpleLogPrinter());

/// ログの出力結果を簡易的にし、ファイルに書き込む
/// 出力先のファイルを[_fileName]に定義する
class SimpleLogPrinter extends LogPrinter {
  final _fileName = 'debug.log';

  /// DEBUG CONSOLEとログファイルに出力する
  @override
  List<String> log(LogEvent event) {
    output('${event.level}: ${event.message}');
    AnsiColor color = PrettyPrinter.levelColors[event.level];
    return [color('${event.level}: ${event.message}')];
  }

  /// [_filename]に受け取った[message]を書き込む処理
  void output(message) async {
    File file = await getFilePath();
    await file.writeAsString(message + '\n', mode: FileMode.append);
  }

  /// 保存するパスを取得する
  Future<File> getFilePath() async {
    final directory = await getTemporaryDirectory();
    return File(directory.path + '/' + _fileName);
  }
}
