import 'package:flutter/material.dart';

class Setting {
  static final Setting _instance = Setting._internal();

  int stateNight = 1;

  factory Setting() {
    return _instance;
  }

  Setting._internal();

  static const List<Color> _colorsText = [
    Colors.black,
    Colors.white,
  ];

  static const List<Color> _colorsDrawer = [
    Colors.blue,
    Color.fromARGB(255, 61, 61, 61),
  ];

  static const List<Color> _colorsDrawerSecondary = [
    Colors.white,
    Color.fromARGB(255, 83, 83, 83),
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

  void setStateNight() {
    stateNight += 1;
    stateNight = stateNight % 2;
  }
}
