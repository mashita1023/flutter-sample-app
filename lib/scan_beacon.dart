import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ScanBeacon extends StatefulWidget {
  final List<ScanResult> devicesList = new List<ScanResult>();
  @override
  _ScanBeaconState createState() => _ScanBeaconState();
}

class _ScanBeaconState extends State<ScanBeacon> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  bool _scan = false;

  void initState() {
    super.initState();
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (widget.devicesList.contains(result) && result.device.name != '') {
          setState(() {
            widget.devicesList.add(result);
          });
        }
      }
    });
  }

  void changeSwitch(bool e) {
    setState(() {
      _scan = e;
    });
    if (_scan) {
      flutterBlue
          .scan(
        timeout: Duration(seconds: 10),
      )
          .listen((result) {
        if (widget.devicesList.contains(result) && result.device.name != '') {
          widget.devicesList.add(result);
        }
      });
    } else
      flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Beacon'),
      ),
      body: Column(
        children: <Widget>[
          Text(_scan.toString()),
          Switch(
            value: _scan,
            onChanged: changeSwitch,
          ),
          scanList(),
        ],
      ),
    );
  }

  Widget scanList() {
    if (_scan) {
      return ListView.builder(
        itemCount: widget.devicesList == null ? 0 : widget.devicesList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, int index) {
          return SizedBox(
            height: 30,
            width: 400,
            child: Expanded(
              child: Container(
                child: InkWell(
                  onTap: null,
                  child: Column(
                    children: <Widget>[
                      Text(widget.devicesList[index].device.name.toString()),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
    return Text('can`t find device.');
  }
}
