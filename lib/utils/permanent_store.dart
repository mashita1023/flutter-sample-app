import 'package:shared_preferences/shared_preferences.dart';
import 'package:peer_route_app/utils/logger.dart';

/// アプリを閉じても保存される値を管理するクラス
/// [_instance] インスタンス
/// [isAgree] 規約に了承したかどうか
class PermanentStore {
  static PermanentStore _instance;
  bool isAgree;

  /// クラスのインスタンス[_instance]を定義し返す
  static getInstance() {
    if (_instance == null) _instance = PermanentStore();
    return _instance;
  }

  /// [_instance]のisAgreeを読み込み[isAgree]に代入する処理
  load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isAgree = prefs.getBool('isAgree') ?? false;
    logger.d('load permanent store : $isAgree');
  }

  /// [_instance]のisAgreeを[isAgree]の値に変更する処理
  save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAgree', isAgree);
    logger.d('save permanent store : $isAgree');
  }
}
