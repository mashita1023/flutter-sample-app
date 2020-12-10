import 'package:http/io_client.dart';
import 'package:peer_route_app/configs/importer.dart';
import 'package:http/http.dart' as http;

/// apiを叩くためのクラス
class Api {
  /// このメソッドを呼び出してPOSTする
  static Future _post(url, request) async {
    // debug
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);
//    final response = await http.post(
    final response = await ioClient.post(
      url,
      body: json.encode(request),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      logger.d('success posted.');
      return json.decode(response.body);
    } else {
      logger.e('failed posted.');
      throw Exception('Failed');
    }
  }

  /// このメソッドを呼び出してGETする
  static Future _get(url) async {
    // debug
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);
//    final response = await http.(
    final response = await ioClient.get(url);
    if (response.statusCode == 200) {
      logger.d('success get');
      return json.decode(response.body);
    } else {
      logger.e('failed get');
      throw Exception('Failed');
    }
  }

  /// COUPON一覧をGETする
  static Future getCoupon() async {
    logger.i('get coupon list.');
    String url = Constant.appUrl + 'coupon';
    return await _get(url);
  }

  /// STORE一覧をGETする
  static Future getStore() async {
    logger.i('get store list.');
    String url = Constant.appUrl + 'store';
    return await _get(url);
  }

  /// BEACONにIDをPOSTして詳細情報を取得する
  static Future postBeacon() async {
    Map<String, dynamic> request = {'id': 4};
    String url = Constant.appUrl + 'beacon';
    logger.i('post beacon detail.');
    return await _post(url, request);
  }

  /// COUPONにIDをPOSTして詳細情報を取得する
  static Future postCoupon(id) async {
    Map<String, dynamic> request = {'id': id};
    String url = Constant.appUrl + 'coupon';
    logger.i('post coupon detail.');
    return await _post(url, request);
  }

  /// STOREにIDをPOSTして詳細情報を取得する
  static Future postStore(id) async {
    Map<String, dynamic> request = {'id': id};
    String url = Constant.appUrl + 'store';
    logger.i('post store detail,');
    return await _post(url, request);
  }

  static Future postUser(id) async {
    Map<String, dynamic> request = {'id': id};
    String url = Constant.appUrl + 'user';
    logger.i('post user detail.');
    return await _post(url, request);
  }

  static Future postRegisterUser(req) async {
    Map<String, dynamic> request = req;
    String url = Constant.appUrl + 'user/register';
    logger.i('post register user.');
    return await _post(url, request);
  }
}
