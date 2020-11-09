import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fa_stepper/fa_stepper.dart';

void main() {
  runApp(Splash());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'routeApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder> {
        '/': (_) => new Splash(),
        '/home': (_) => new MyHomePage(),
        '/tutorial': (_) => new Tutorial(),
      },
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
        () => print('splashState')
    );
  }
  Future<bool> getPrefRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isRead = prefs.getBool('read');
    print('isRead:$isRead');
    if(isRead == null){
      print("isRead is null");
      isRead = false;
    }
    print('return _splashstate');
    return isRead;
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future: getPrefRead(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        print (snapshot);

        final hasData = snapshot.hasData;
        print('hasData:$hasData');
        if (hasData == false) {
          return CircularProgressIndicator();
        }

        final isRead = snapshot.data;
        print('isRead:$isRead');
        var homeWidget;
        if(isRead) {
          print('navigate home');
          homeWidget = new MyHomePage();
          //Navigator.of(context).pushReplacementNamed('/home');
        } else {
          print('navigate tutorial');
          homeWidget = new Tutorial();
          //Navigator.of(context).pushReplacementNamed('/tutorial');
        }
        print('finish navigate');

        var app = new MaterialApp (
          title: "Splash",
          home: homeWidget,
          routes: <String, WidgetBuilder> {
    //        '/': (_) => new Splash(),
            '/home': (_) => new MyHomePage(),
            '/tutorial': (_) => new Tutorial(),
          },

        );
        return app;
      },
    );
  }

}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            RaisedButton(
                onPressed: () => Navigator.of(context).pushNamed('/tutorial'),
              child: Text('Tutorialへ'),
                )
          ],
        ),
      ),
    );
  }
}

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
/*      body: Center(
        child: Column(
          children: <Widget>[
            Text('$_read'),
            RaisedButton(onPressed: _pushHome, child: Text('了承'),),
            RaisedButton(onPressed: switchRead, child: Text('Switch'),)
          ]
        ),
      ),

 */
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
