import 'package:http/io_client.dart';
import 'package:peer_route_app/configs/importer.dart';
import 'package:http/http.dart' as http;

Api api = Api();

/// apiを叩くためのクラス
class Api {
  /// このメソッドを呼び出してPOSTする
  Future post(url, request) async {
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
      logger.e('success posted.');
      return json.decode(response.body);
    } else {
      logger.e('failed posted.');
      throw Exception('Failed');
    }
  }

  /// このメソッドを呼び出してGETする
  Future get(url) async {
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
  Future getCoupon() async {
    logger.d('get coupon.');
    String url = constant.appUrl + 'coupon';
    return await get(url);
  }

  /// STORE一覧をGETする
  Future getStore() async {}

  /// BEACONにIDをPOSTして詳細情報を取得する
  Future postBeacon() async {
    Map<String, dynamic> request = {'id': 4};
    String url = constant.appUrl + 'beacon';
    logger.d('post beacon detail.');
    return await post(url, request);
  }

  /// COUPONにIDをPOSTして詳細情報を取得する
  Future postCoupon(id) async {
    Map<String, dynamic> request = {'id': id};
    String url = constant.appUrl + 'coupon';
    logger.d('post coupon detail.');
    return await post(url, request);
  }
}
