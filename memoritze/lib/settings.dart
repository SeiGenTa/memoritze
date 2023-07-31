import 'package:memoritze/dataBase/db.dart';
import 'package:flutter/material.dart';

class Setting {
  ConnectionDataBase database = ConnectionDataBase();
  static final Setting _instance = Setting._internal();

  int stateNight = 0;
  int version0 = 16;
  String language = "ESP";

  factory Setting() {
    return _instance;
  }

  Setting._internal();

  Future<bool> chargeSetting() async {
    Map<String, dynamic> config = await database.getSetting();
    stateNight = config['NightMode'];
    if (version0 != config['Version']) {
      await database.changeSetting(stateNight, version0, language);
      return chargeSetting();
    }
    print("version: ${config['Version']}");
    return true;
  }

  static const List<Color> _backGroundColor = [
    Color.fromRGBO(255, 255, 255, 1),
    Color.fromRGBO(0, 0, 0, 1),
  ];

  static const List<Color> _colorsText = [
    Colors.black,
    Colors.white,
  ];

  static const List<Color> _colorsMore = [
    Color.fromRGBO(255, 255, 255, 1),
    Color.fromARGB(255, 26, 26, 26),
  ];

  static const List<Color> _colorsDrawerSecondary = [
    Color.fromRGBO(58, 118, 88, 1),
    Color.fromRGBO(35, 84, 52, 1),
  ];

  static const List<Color> _colorsPaper = [
    Color.fromRGBO(0, 122, 31, 1),
    Color.fromARGB(255, 26, 26, 26),
  ];

  static const List<Color> _colorsIconButton = [
    Color.fromRGBO(0, 122, 31, 1),
    Color.fromRGBO(0, 122, 31, 1),
  ];

  static const List<Color> _colorsPage = [
    Color.fromRGBO(240, 240, 240, 1),
    Color.fromRGBO(44, 44, 44, 1),
  ];

  static const List<Color> _colorsOpos = [
    Color.fromRGBO(44, 44, 44, 1),
    Color.fromRGBO(255, 255, 255, 1),
  ];

  static const List<Color> _colorsBook = [
    Color.fromARGB(255, 237, 55, 55),
    Color.fromARGB(255, 161, 45, 45),
  ];

  static const List<Color> _colorsNavBarSup = [
    Color.fromRGBO(0, 122, 31, 1),
    Color.fromARGB(255, 26, 26, 26),
  ];

  static const List<Color> _colorsNavBarBot = [
    Color.fromRGBO(255, 255, 255, 1),
    Color.fromARGB(255, 49, 49, 49),
  ];

  Color getColorNavBot() {
    return _colorsNavBarBot[stateNight];
  }

  Color getColorNavSup() {
    return _colorsNavBarSup[stateNight];
  }

  Color getColorBook() {
    return _colorsBook[stateNight];
  }

  Color getColorsOpos() {
    return _colorsOpos[stateNight];
  }

  Color getColorPager() {
    return _colorsPage[stateNight];
  }

  Color getColorsIconButton() {
    return _colorsIconButton[stateNight];
  }

  Color getColorPaper() {
    return _colorsPaper[stateNight];
  }

  Color getColorText() {
    return _colorsText[stateNight];
  }

  Color getColorMore() {
    return _colorsMore[stateNight];
  }

  Color getColorDrawerSecondary() {
    return _colorsDrawerSecondary[stateNight];
  }

  Color getBackgroundColor() {
    return _backGroundColor[stateNight];
  }

  void setStateNight() {
    stateNight += 1;
    stateNight = stateNight % 2;
    database.changeSetting(stateNight, version0, "esp");
  }
}
