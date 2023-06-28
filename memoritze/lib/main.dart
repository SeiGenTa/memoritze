import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memoritze/db/dataBase.dart';
import 'package:memoritze/Pages/myClases.dart';
import 'package:memoritze/setting.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  // Initialize FFI
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  MyDataBase myDataBase = MyDataBase();
  await myDataBase.init();
  Setting setting = Setting();
  setting.chargeSetting();
  runApp(MyClasses());
}
