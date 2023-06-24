import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memoritze/db/dataBase.dart';
import 'package:memoritze/Pages/myClases.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  // Initialize FFI
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  MyDataBase myDataBase = MyDataBase();
  await myDataBase.init();
  runApp(const MyClasses());
}
