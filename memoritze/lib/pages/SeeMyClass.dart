import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memoritze/Settings.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/partes/barraLeft.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// ignore: must_be_immutable
class SeeMyClass extends StatefulWidget {
  bool prepared = true;
  SeeMyClass({super.key, this.prepared = true});

  @override
  State<SeeMyClass> createState() => _SeeMyClassState();
}

class _SeeMyClassState extends State<SeeMyClass> {
  ConectioDataBase myData = ConectioDataBase();
  Setting mySetting = Setting();

  Future<bool> initApp() async {
    print("cargando informacion");
    if (Platform.isWindows) {
      print("Estoy en windows");
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    await myData.init();
    mySetting.chargeSetting();

    setState(() {
      widget.prepared = true;
    });

    return true;
  }

  void initPage() async {
    if (!widget.prepared) {
      await initApp();
    }
  }

  @override
  void initState() {
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {
    Color backGround = mySetting.getBackgroundColor();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backGround,
        appBar: AppBar(
          
        ),
        drawer: BarraLeft(),
      ),
    );
  }
}
