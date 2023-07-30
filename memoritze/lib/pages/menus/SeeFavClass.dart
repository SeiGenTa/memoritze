import 'package:flutter/material.dart';
import 'package:memoritze/settings.dart';

class FavClass extends StatefulWidget {
  const FavClass({super.key});

  @override
  State<FavClass> createState() => _FavClassState();
}

class _FavClassState extends State<FavClass> {
  Setting mySetting = Setting();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Favoritos\n \n Esta es una seccion que estara disponible proximamente",
        style: TextStyle(
          color: mySetting.getColorText(),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
