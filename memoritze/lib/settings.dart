import 'package:memoritze/dataBase/db.dart';
import 'package:flutter/material.dart';

class Setting {
  ConnectionDataBase database = ConnectionDataBase();
  static final Setting _instance = Setting._internal();

  int stateNight = 0;
  int version0 = 14;
  String languaje = "ESP";

  factory Setting() {
    return _instance;
  }

  Setting._internal();

  Future<bool> chargeSetting() async {
    Map<String, dynamic> config = await database.getSetting();
    print("cargando");
    //stateNight = config['NightMode'];
    stateNight = config['NightMode'];
    print(config['Version']);
    if (version0 != config['Version']){
      await database.changeSetting(stateNight, version0, languaje);
      print(config['Version']);
    }
    version0 = config['Version'];
    return true;
  }

  static const List<Color> _backGroundColor = [
    Color.fromRGBO(167, 220, 178, 1),
    Color.fromRGBO(3, 33, 7, 1),
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
    Color.fromRGBO(58, 118, 88, 1),
    Color.fromRGBO(35, 84, 52, 1),
  ];

  static const List<Color> _colorsPaper = [
    Color.fromRGBO(129, 190, 77, 1),
    Color.fromRGBO(58, 118, 88, 1),
  ];

  static const List<Color> _colorsIconButton = [
    Color.fromRGBO(255, 255, 255, 1),
    Color.fromRGBO(44, 44, 44, 1),
  ];

  Color getColorsIconButton(){
    return _colorsIconButton[stateNight];
  }

  Color getColorPaper() {
    return _colorsPaper[stateNight];
  }

  Color getColorText() {
    return _colorsText[stateNight];
  }

  Color getColorDrawer() {
    return _colorsDrawer[stateNight];
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
