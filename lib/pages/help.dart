import 'package:peer_route_app/configs/importer.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

class Helppage extends StatefulWidget {
  @override
  HelpState createState() => HelpState();
}

class HelpState extends State<Helppage> {
  /// [BottomTabBar]を呼び出す
  void _pushHome() {
    logger.i('navigated BottomTabBar.');
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return BottomTabBar();
    }));
  }

  /// 画面描写
  /// [size]で画面サイズを取得する
  /// [_tabs]に表示する画像をContainerにして格納
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    List<Container> _tabs = [
      Container(
        child: Column(
          children: [
            Image.asset(
              'assets/help_1.png',
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
      Container(
        child: Column(
          children: [
            Image.asset(
              'assets/help_2.png',
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
      Container(
        child: Column(
          children: [
            Image.asset(
              'assets/help_3.png',
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
      Container(
        child: Column(
          children: [
            Image.asset(
              'assets/help_4.png',
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 25),
            SizedBox(
              child: RaisedButton(
                onPressed: () {
                  _pushHome();
                },
                child: Text("閉じる"),
              ),
            ),
          ],
        ),
      ),
    ];

    /// 表示する画面
    /// Swiperを使って[_tabs]をスワイプで表示を変更する
    return Scaffold(
      appBar: AppBar(
        title: Text('ヘルプ'),
      ),
      backgroundColor: Colors.white60,
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Swiper(
                loop: false,
                itemBuilder: (BuildContext context, int index) {
                  return _tabs[index];
                },
                indicatorLayout: PageIndicatorLayout.COLOR,
                autoplay: false,
                itemCount: _tabs.length,
                pagination: SwiperPagination(
                  margin: EdgeInsets.only(bottom: size.height / 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
