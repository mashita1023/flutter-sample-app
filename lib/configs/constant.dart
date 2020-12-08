/// 定数を扱う
/// dartでは定数もlowerCamelCaseなので[constant]クラスを呼び出すことで差別化する
Constant constant = Constant();

class Constant {
  final String appName = 'app name';
  final String appUrl = 'https://localhost:30443/r02-020_remoshot_server/api/';
}
