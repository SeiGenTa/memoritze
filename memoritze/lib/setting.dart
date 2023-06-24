import 'package:flutter/material.dart';

class Setting {
  static final Setting _instance = Setting._internal();

  int stateNight = 0;

  factory Setting() {
    return _instance;
  }

  Setting._internal();

  static const List<Color> _backGroundColor = [
    Color.fromRGBO(220, 241, 217, 1),
    Color.fromRGBO(26, 26, 53, 26),
  ];

  static const List<Color> _colorsText = [
    Colors.black,
    Colors.white,
  ];

  static const List<Color> _colorsDrawer = [
    Color.fromRGBO(10, 73, 10, 1),
    Color.fromRGBO(0, 0, 0, 1),
  ];

  static const List<Color> _colorsDrawerSecondary = [
    Color.fromRGBO(42, 146, 53, 1),
    Color.fromRGBO(73, 150, 70, 1),
  ];

  Color getColorText() {
    return _colorsText[stateNight];
  }

  Color getColorDrawer() {
    return _colorsDrawer[stateNight];
  }

  Color getColorDrawerSecundary() {
    return _colorsDrawerSecondary[stateNight];
  }

  Color getBackgroundColor() {
    return _backGroundColor[stateNight];
  }

  void setStateNight() {
    stateNight += 1;
    stateNight = stateNight % 2;
  }
}
