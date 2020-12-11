import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:location/location.dart';
import 'package:peer_route_app/utils/logger.dart';

/// Bluetooth関連の挙動をまとめる
class Bluetooth {
  static FlutterBlue flutterBlue = FlutterBlue.instance;
  static Location location = Location();
  static final List<ScanResult> devicesList = new List<ScanResult>();
  List deviceDetail = new List();

  /// scanしたビーコンを[devicesList]へ追加
  static _addDeviceTolist(final ScanResult device) {
    if (!devicesList.contains(device)) {
      devicesList.add(device);
    }
  }

  /// ビーコンをscanしたときに行いたい処理
  /// uuidはおなじはずなので[Constant.uuid]と一致したものを
  /// [major]と[minor]を添えてAPIで叩いてStreamを貰って
  /// 存在するクーポンIDだけをDBに保存とプッシュ通知を出す
  static _sendData(final ScanResult device) {
    var uuid = '85c0e72c-2bd5-4090-9248-be84d9f0f2a8';
    var major = '65328';
    var minor = '98';
    List data = detail(device);
    logger.i('scan data: $data');
    for (var result in data) {
      if (result[2] == uuid && result[3] == major && result[4] == minor) {
        logger.d('uuid && major && minor : ${device.device.name}');
      }
    }
  }

  /// ビーコンをスキャンする
  static scanDevices() async {
    logger.i('start scan beacon.');
    flutterBlue
        .scan(
      timeout: Duration(seconds: 20),
    )
        .listen((result) {
      if (result.device.name != '') {
        _addDeviceTolist(result);
        _sendData(result);
      }
    });
  }

  /// scanしたビーコン情報を見てわかるようにするための前処理
  /// List[] => 0: name, 1: MACaddres, 2: uuid, 3: major, 4: minor, 5:txpower
  static List detail(final ScanResult device) {
    List returnData = new List();
    var data = device.advertisementData.manufacturerData.values.first.toList();
    var uuid = '';
    var major = '';
    var minor = '';
    var txpower = '';

    for (var i = 2; i < 18; i++) {
      uuid += data[i].toRadixString(16).padLeft(2, "0");
      if (i == 5 || i == 7 || i == 9 || i == 11) uuid += '-';
    }

    major = data[18].toRadixString(16).padLeft(2, "0") +
        data[19].toRadixString(16).padLeft(2, "0");
    major = int.parse(major, radix: 16).toString();
    minor = data[20].toRadixString(16).padLeft(2, "0") +
        data[21].toRadixString(16).padLeft(2, "0");
    minor = int.parse(minor, radix: 16).toString();

    txpower = data[22].toSigned(8).toString();

    returnData.add(
        [device.device.name, device.device.id, uuid, major, minor, txpower]);

    return returnData;
  }
}
