import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Bluetooth extends StatefulWidget {
  List devicesList = new List();
  Bluetooth({this.devicesList});

  @override
  _BluetoothState createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice _connectedDevice;
  List<BluetoothService> _services;

  _addDeviceTolist(final ScanResult device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  Widget _detail(List data) {
    var uuid;
    var major;
    var minor;
    var txpower;

    uuid = data[2].toRadixString(16).padLeft(2, "0");
    uuid += data[3].toRadixString(16).padLeft(2, "0");
    uuid += data[4].toRadixString(16).padLeft(2, "0");
    uuid += data[5].toRadixString(16).padLeft(2, "0");
    uuid += '-';
    uuid += data[6].toRadixString(16).padLeft(2, "0");
    uuid += data[7].toRadixString(16).padLeft(2, "0");
    uuid += '-';
    uuid += data[8].toRadixString(16).padLeft(2, "0");
    uuid += data[9].toRadixString(16).padLeft(2, "0");
    uuid += '-';
    uuid += data[10].toRadixString(16).padLeft(2, "0");
    uuid += data[11].toRadixString(16).padLeft(2, "0");
    uuid += '-';
    uuid += data[12].toRadixString(16).padLeft(2, "0");
    uuid += data[13].toRadixString(16).padLeft(2, "0");
    uuid += data[14].toRadixString(16).padLeft(2, "0");
    uuid += data[15].toRadixString(16).padLeft(2, "0");
    uuid += data[16].toRadixString(16).padLeft(2, "0");
    uuid += data[17].toRadixString(16).padLeft(2, "0");

    major = data[18].toRadixString(16).padLeft(2, "0") +
        data[19].toRadixString(16).padLeft(2, "0");
    major = int.parse(major, radix: 16).toString();
    minor = data[20].toRadixString(16).padLeft(2, "0") +
        data[21].toRadixString(16).padLeft(2, "0");
    minor = int.parse(minor, radix: 16).toString();

    txpower = data[22].toSigned(8);

    return Text('uuid: $uuid\nmajor: $major\nminor: $minor\ntxpower: $txpower');
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = new List<Container>();
    for (ScanResult device in widget.devicesList) {
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
                    _detail(device
                        .advertisementData.manufacturerData.values.first
                        .toList()),
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

  ListView _buildView() {
    return _buildListViewOfDevices();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('BLE Demo'),
        ),
        body: _buildView(),
      );
}
