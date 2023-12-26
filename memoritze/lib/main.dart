import 'package:flutter/material.dart';
import 'package:memoritze/pages/MenuClass.dart';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MenuInit(prepared: false),
  ));
}
