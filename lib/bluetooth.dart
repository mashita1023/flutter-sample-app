import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Bluetooth extends StatefulWidget {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
//  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
  final List<ScanResult> devicesList = new List<ScanResult>();
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  @override
  _BluetoothState createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  final _writeController = TextEditingController();
  BluetoothDevice _connectedDevice;
  List<BluetoothService> _services;
  List<ScanResult> _results;
/*
  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }
*/
  _addDeviceTolist(final ScanResult device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    /*
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    */
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (result.device.name != '') {
          _addDeviceTolist(result);
          print(result.toString());
        }
      }
    });
    widget.flutterBlue.startScan();
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
//    for (BluetoothDevice device in widget.devicesList) {
    for (ScanResult device in widget.devicesList) {
      containers.add(
        Container(
          height: 300,
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
              FlatButton(
                color: Colors.blue,
                child: Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  widget.flutterBlue.stopScan();
                  try {
                    await device.device.connect();
                  } catch (e) {
                    print('$e');
                    if (e.code != 'already_connected') {
                      throw e;
                    }
                  } finally {
                    _services = await device.device.discoverServices();
                  }
                  setState(() {
                    _connectedDevice = device.device;
                  });
                },
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

  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = new List<ButtonTheme>();

    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              color: Colors.blue,
              child: Text('READ', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                var sub = characteristic.value.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.read();
                sub.cancel();
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              child: Text('WRITE', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Write"),
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _writeController,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Send"),
                            onPressed: () {
                              characteristic.write(
                                  utf8.encode(_writeController.value.text));
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              child: Text('NOTIFY', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                characteristic.value.listen((value) {
                  widget.readValues[characteristic.uuid] = value;
                });
                await characteristic.setNotifyValue(true);
              },
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  ListView _buildConnectDeviceView() {
    List<Container> containers = new List<Container>();

    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = new List<Widget>();
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(characteristic.uuid.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Value: ' +
                        widget.readValues[characteristic.uuid].toString()),
                  ],
                ),
                /*
                Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Disconnect'),
                      onPressed: () => _connectedDevice.disconnect(),
                    )
                  ],
                ),
                */
                Divider(),
              ],
            ),
          ),
        );
      }
      containers.add(
        Container(
          child: ExpansionTile(
            title: Text(service.uuid.toString()),
            children: characteristicsWidget,
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
    if (_connectedDevice != null) {
      return _buildConnectDeviceView();
    }
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
