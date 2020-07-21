import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import './lastpage.dart';
import './configs/colors.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: AppColors.pink),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _animateController;
  AnimationController _longPressController;
  AnimationController _secondStepController;

  double overall = 3.0;
  String overallStatus = "普通";
  int curIndex = 0;

  Animation<double> longPressAnimation;
  Animation<double> secondTranformAnimation;

  @override
  void initState() {
    super.initState();

    _animateController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _longPressController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _secondStepController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    longPressAnimation =
        Tween<double>(begin: 1.0, end: 2.0).animate(CurvedAnimation(
            parent: _longPressController,
            curve: Interval(
              0.1,
              1.0,
              curve: Curves.fastOutSlowIn,
            )));

    secondTranformAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _secondStepController,
            curve: Interval(
              0.1,
              1.0,
              curve: Curves.fastOutSlowIn,
            )));

    _longPressController.addListener(() {
      setState(() {});
    });

    _secondStepController.addListener(() {
      setState(() {});
    });
  }

  // @override
  // void dispose() {
  //   _animateController.dispose();
  //   _secondStepController.dispose();
  //   _longPressController.dispose();
  //   super.dispose();
  // }

  Future _startAnimation() async {
    try {
      await _animateController.forward().orCancel;
      setState(() {});
    } on TickerCanceled {}
  }

  Future _startSecondStepAnimation() async {
    try {
      await _secondStepController.forward().orCancel;
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    final ui.Size logicalSize = MediaQuery.of(context).size;
    final double _width = logicalSize.width;

    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: _animateController.isCompleted
              ? getPages(_width)
              : AnimationBox(
                  controller: _animateController,
                  screenWidth: _width,
                  onStartAnimation: () {
                    _startAnimation();
                  },
                ),
        ),
      ),
      bottomNavigationBar: _animateController.isCompleted
          ? BottomAppBar(
              child: Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [BoxShadow(color: AppColors.grey.withAlpha(200))]),
              height: 50.0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    curIndex += 1;
                    if (curIndex == 1) {
                      _startSecondStepAnimation();
                    }
                  });
                },
                child: Center(
                    child: Text(
                  curIndex < 1 ? 'Continue' : 'Finish',
                  style: TextStyle(fontSize: 20.0, color: AppColors.pink),
                )),
              ),
            ))
          : null,
    );
  }

  Widget getPages(double _width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 30.0),
          height: 10.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(2, (int index) {
              return Container(
                decoration: BoxDecoration(
                  color: index <= curIndex ? AppColors.pink : AppColors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
                height: 10.0,
                width: (_width - 32.0 - 15.0) / 2.0,
                margin: EdgeInsets.only(left: index == 0 ? 0.0 : 5.0),
              );
            }),
          ),
        ),
        curIndex == 0 ? _getFirstStep() : _getSecondStep(),
      ],
    );
  }

  Widget _getFirstStep() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 34.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Q1'),
            Container(
                margin: EdgeInsets.only(top: 16.0),
                child: Text('全体の満足度はいかがでしょうか。')),
            Container(
              margin: EdgeInsets.symmetric(vertical: 50.0),
              child: Text(
                overallStatus,
                style: TextStyle(
                    color: AppColors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Center(
                child: Slider(
                  activeColor: AppColors.pink,
                  value: overall,
                  onChanged: (value) {
                    setState(() {
                      overall = value.round().toDouble();
                      _getOverallStatus(overall);
                    });
                  },
                  label: '${overall.toInt()}',
                  divisions: 30,
                  min: 1.0,
                  max: 5.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getSecondStep() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 34.0),
        child: Transform(
          transform: new Matrix4.translationValues(
              0.0, 50.0 * (1.0 - secondTranformAnimation.value), 0.0),
          child: Opacity(
            opacity: secondTranformAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Q2'),
                Container(
                    margin: EdgeInsets.only(top: 16.0), child: Text('Kimochi')),
                Expanded(
                  child: Center(
                    child: Container(
                      height: 213.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 150.0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTapUp: (detail) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        LastPage(
                                                          statusType: 'Unhappy',
                                                        )));
                                      },
                                      child: Transform.scale(
                                          scale: longPressAnimation.value,
                                          child: Hero(
                                            tag: 'Unhappy',
                                            child: Image.asset(
                                              'images/angry.gif',
                                              width: 50.0,
                                              height: 50.0,
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Unhappy'),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTapUp: (detail) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        LastPage(
                                                          statusType: 'Neutral',
                                                        )));
                                      },
                                      child: Hero(
                                        tag: 'Neutral',
                                        child: Transform.scale(
                                            scale: longPressAnimation.value,
                                            child: Image.asset(
                                              'images/mmm.gif',
                                              width: 50.0,
                                              height: 50.0,
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Neutral'),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTapUp: (detail) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        LastPage(
                                                          statusType:
                                                              'Satisfied',
                                                        )));
                                      },
                                      child: Transform.scale(
                                          scale: longPressAnimation.value,
                                          child: Hero(
                                            tag: 'Satisfied',
                                            child: Image.asset(
                                              'images/hearteyes.gif',
                                              width: 50.0,
                                              height: 50.0,
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Satisfied'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getOverallStatus(double overall) {
    switch (overall.toInt()) {
      case 1:
        overallStatus = '不満';
        break;
      case 2:
        overallStatus = 'やや不満';
        break;
      case 3:
        overallStatus = '普通';
        break;
      case 4:
        overallStatus = 'ほぼ満足';
        break;
      default:
        overallStatus = '満足';
        break;
    }
  }
}

class AnimationBox extends StatelessWidget {
  AnimationBox(
      {Key key, this.controller, this.screenWidth, this.onStartAnimation})
      : width = Tween<double>(
          begin: screenWidth,
          end: 40.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.1,
              0.3,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        alignment = Tween<AlignmentDirectional>(
          begin: AlignmentDirectional.bottomCenter,
          end: AlignmentDirectional.topStart,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.3,
              0.6,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        radius = BorderRadiusTween(
          begin: BorderRadius.circular(20.0),
          end: BorderRadius.circular(2.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.6,
              0.8,
              curve: Curves.ease,
            ),
          ),
        ),
        height = Tween<double>(
          begin: 40.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.3,
              0.8,
              curve: Curves.ease,
            ),
          ),
        ),
        movement = EdgeInsetsTween(
          begin: EdgeInsets.only(top: 0.0),
          end: EdgeInsets.only(top: 30.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.3,
              0.6,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        scale = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.8,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        opacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.8,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        numberOfStep = IntTween(
          begin: 1,
          end: 4,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.8,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        super(key: key);

  final VoidCallback onStartAnimation;
  final Animation<double> controller;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<AlignmentDirectional> alignment;
  final Animation<BorderRadius> radius;
  final Animation<EdgeInsets> movement;
  final Animation<double> opacity;
  final Animation<double> scale;
  final Animation<int> numberOfStep;
  final double screenWidth;
  final double overral = 3.0;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Stack(
          alignment: alignment.value,
          children: <Widget>[
            Opacity(
              opacity: 1.0 - opacity.value,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    height: 10.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(numberOfStep.value, (int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: index == 0 ? AppColors.pink : AppColors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)),
                          ),
                          height: 10.0,
                          width: (screenWidth - 15.0) / 5.0,
                          margin: EdgeInsets.only(left: index == 0 ? 0.0 : 5.0),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Opacity(
              opacity:
                  controller.status == AnimationStatus.dismissed ? 1.0 : 0.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                      child: Center(
                          child: FlutterLogo(
                    colors: AppColors.pinklogo,
                    size: 100.0,
                  ))),
                  Text(
                    'アンケート',
                    style: TextStyle(
                        color: AppColors.pink,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 120.0),
                    child: Text(
                      'Demo Flutter App',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Opacity(
              opacity: opacity.value,
              child: GestureDetector(
                onTap: onStartAnimation,
                child: Transform.scale(
                  scale: scale.value,
                  child: Container(
                    margin: movement.value,
                    width: width.value,
                    child: GestureDetector(
                      child: Container(
                        height: height.value,
                        decoration: BoxDecoration(
                            color: AppColors.pink,
                            borderRadius: radius.value),
                        child: Center(
                          child: controller.status == AnimationStatus.dismissed
                              ? Text(
                                  'Zô nào',
                                  style: TextStyle(
                                      color: AppColors.white, fontSize: 20.0),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
