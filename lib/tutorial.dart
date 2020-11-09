import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fa_stepper/fa_stepper.dart';

class Tutorial extends StatefulWidget {
  @override
  _Tutorial createState() => _Tutorial();
}

class _Tutorial extends State<Tutorial> {
  bool _read = false;
  int _currentStep = 0;

  void _pushHome() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _read = true;
    await prefs.setBool('read', _read);
    if (_read) Navigator.of(context).pushReplacementNamed('/home');
    else print('_read is false');
  }

// debug
  void switchRead() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _read = !prefs.getBool('read');
      if (_read == null) {
        _read = false;
      }
    });
    await prefs.setBool('read', _read);
    print('set _read:$_read');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tutorial'),
      ),
      body: FAStepper(
        currentStep: this._currentStep,
        steps: _mySteps(),
        type: FAStepperType.horizontal,
        onStepTapped: (step) {
          setState(() {
            this._currentStep = step;
          });
        },
        onStepContinue: () {
          setState(() {
            if(this._currentStep < this._mySteps().length - 1) {
              this._currentStep = this._currentStep + 1;
            } else {
              print('Completed, check fields.');
              _pushHome();
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if(this._currentStep > 0) {
              this._currentStep = this._currentStep - 1;
            } else {
              this._currentStep = 0;
            }
          });
        },
      ),
    );
  }

  List<FAStep> _mySteps() {
    List<FAStep> _steps = [
      FAStep(
        title: Text('Step 1'),
        content: Text('aiueo'),
        isActive: _currentStep > 0,

      ),
      FAStep(
        title: Text('Step 2'),
        content: Text('$_read'),
        isActive: _currentStep > 1,

      ),
      FAStep(
        title: Text('Step 3'),
        content: RaisedButton(onPressed: switchRead, child: Text('Switch'),),
        isActive: _currentStep > 2,

      )
    ];
    return _steps;
  }
}