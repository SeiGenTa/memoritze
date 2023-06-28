import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InitMyQuestsGame extends StatefulWidget {

  //* Cosas necesarias
  late List<int> myMaterials;

  InitMyQuestsGame({super.key,required this.myMaterials});

  @override
  State<InitMyQuestsGame> createState() => _InitMyQuestsGameState();
}

class _InitMyQuestsGameState extends State<InitMyQuestsGame> {

  void chargerMyQuest(){

  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}