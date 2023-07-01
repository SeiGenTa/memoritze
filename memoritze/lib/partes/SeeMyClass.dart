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
  ConnectionDataBase myData = ConnectionDataBase();
  Setting mySetting = Setting();

  Future<bool> initApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isWindows) {
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
    if (!myData.getInitiated()) {
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

    if (!widget.prepared){
      return const Center(
        child: Image(image: AssetImage("assets/img/myIcon.png")),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backGround,
        appBar: AppBar(
          backgroundColor: mySetting.getColorDrawer(),
          title: const Text('Mis Clases'),
        ),
        drawer: BarraLeft(),
      ),
    );
  }
}
