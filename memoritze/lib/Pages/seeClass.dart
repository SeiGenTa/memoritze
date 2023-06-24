import 'package:flutter/material.dart';
import 'package:memoritze/db/dataBase.dart';
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
  MyDataBase dataBase = MyDataBase();
  @override
  void initState() {
    super.initState();
    chargerData();
  }

  void chargerData() async {
    this.myClass = await dataBase.getClassID(widget.id_class);
    setState(() {
      charge = true;
    });
  }

  late List<Map<String, dynamic>> myClass;

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
                : Container(
                    child: ListView(
                      children: [
                        Stack(
                          children: [
                            Container(
                              color: mySetting.getColorDrawerSecundary(),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        myClass[0]['Nombre'].toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: mySetting.getColorText(),
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Expanded(child: Text(""))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Descripcion:",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: mySetting.getColorText(),
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              50,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              50,
                                        ),
                                        child: Text(
                                          myClass[0]['Descripcion'].toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: mySetting.getColorText(),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                            IconButton(
                              iconSize: 40,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: mySetting.getColorText(),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )));
  }
}
