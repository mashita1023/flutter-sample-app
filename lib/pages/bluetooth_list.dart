import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:peer_route_app/configs/importer.dart';

class BluetoothList extends StatefulWidget {
  @override
  _BluetoothState createState() => _BluetoothState();
}

/// デバッグ用のscanしたビーコンの一覧を見るためのページ
class _BluetoothState extends State<BluetoothList> {
  Bluetooth bluetooth = Bluetooth();

  /// ビーコン一覧をリスト表示するための処理
  ListView _buildListViewOfDevices() {
    List<Container> containers = new List<Container>();
    for (ScanResult device in bluetooth.devicesList) {
      containers.add(
        Container(
          height: 100,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.device.name == ''
                        ? '(unknown device)'
                        : device.device.name),
                    Text(device.device.id.toString()),
                    Text(bluetooth.detail(device).toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  /// 画面描写
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('BLE Demo'),
        ),
        body: _buildListViewOfDevices(),
      );
}
