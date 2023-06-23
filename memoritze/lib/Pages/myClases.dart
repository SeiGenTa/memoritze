import 'package:flutter/material.dart';
import 'package:memoritze/partes/barraLeft.dart';
import 'package:memoritze/setting.dart';

class MyClasses extends StatefulWidget {
  const MyClasses({super.key});

  @override
  State<MyClasses> createState() => _MyClassesState();
}

class _MyClassesState extends State<MyClasses> {
  @override
  Widget build(BuildContext context) {
    Setting mySetting = Setting();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: mySetting.getColorDrawer(),
          title: const Text('Mis Clases'),
        ),
        drawer: new BarraLeft(),
        body: Center(
          child: Text("Mis clases"),
        ),
      ),
    );
  }
}
