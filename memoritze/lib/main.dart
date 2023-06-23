import 'package:flutter/material.dart';
import 'package:memoritze/partes/barraLeft.dart';
import 'package:memoritze/Pages/myClases.dart';
import 'package:memoritze/setting.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Setting mySetting = Setting();

    print(mySetting.hashCode);

    const myBarra = BarraLeft();

    return MyClasses();
  }
}
