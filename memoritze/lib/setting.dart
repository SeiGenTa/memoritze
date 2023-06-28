import 'package:flutter/material.dart';
import 'package:memoritze/db/dataBase.dart';

class Setting {
  MyDataBase database = MyDataBase();
  static final Setting _instance = Setting._internal();

  int stateNight = 0;
  int version0 = 9;

  factory Setting() {
    return _instance;
  }

  void chargeSetting() async {
    List<Map<String, dynamic>> config = await database.getSetting();
    if (config.isEmpty) {
      database.updatingSetting(0, 2, "Espanol");
      return;
    }

    stateNight = config[0]['NightMode'];

    if (version0 > config[0]['Version']) {
      print("Se cambiara la base de dato");
      //Code en caso de que se haga un cambio de la base
      database.changeSetting(stateNight, 9, "Espanol");
    }
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
    Color.fromRGBO(10, 10, 10, 1),
  ];

  static const List<Color> _colorsDrawerSecondary = [
    Color.fromRGBO(42, 146, 53, 1),
    Color.fromRGBO(73, 150, 70, 1),
  ];

    static const List<Color> _colorsPaper = [
    Color.fromRGBO(255, 255, 255, 1),
    Color.fromRGBO(97, 74, 22, 1),
  ];

  Color getColorPaper(){
    return _colorsPaper[stateNight];
  }

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
    database.changeSetting(stateNight, 1, "Espanol");
  }
}
