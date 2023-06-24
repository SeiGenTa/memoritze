import 'package:flutter/material.dart';
import 'package:memoritze/setting.dart';

// ignore: must_be_immutable
class SeeClass extends StatefulWidget {
  // ignore: non_constant_identifier_names
  late int id_class;

  SeeClass({super.key, required int number}) {
    id_class = number;
  }

  @override
  State<SeeClass> createState() => _SeeClassState();
}

class _SeeClassState extends State<SeeClass> {
  @override
  void initState() {
    super.initState();
  }

  bool charge = false;
  Setting mySetting = Setting();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: mySetting.getBackgroundColor(),
          body: !charge
              ? Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          iconSize: 50,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: mySetting.getColorText(),
                          ),
                        ),
                        const Expanded(child: Text("")),
                      ],
                    ),
                    Expanded(
                        child: Center(
                            child: CircularProgressIndicator(
                      backgroundColor: mySetting.getBackgroundColor(),
                      valueColor:
                          AlwaysStoppedAnimation(mySetting.getColorText()),
                    ))),
                  ],
                )
              : const Center(
                  child: Text("Se cargo"),
                )),
    );
  }
}
