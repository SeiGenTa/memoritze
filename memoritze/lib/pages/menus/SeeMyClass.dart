import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/pages/InfoMyClass.dart';
import 'package:memoritze/pages/menus/CreateNewClass.dart';
import 'package:memoritze/settings.dart';

class MyClass extends StatefulWidget {
  const MyClass({super.key});

  @override
  State<MyClass> createState() => _MyClassState();
}

class _MyClassState extends State<MyClass> {
  ConnectionDataBase myData = ConnectionDataBase();
  Setting mySetting = Setting();

  late List<Map<String, dynamic>> myDataBase;

  bool charge = false;

  void init() async {
    myDataBase = await myData.getClass(-1);
    print(myDataBase);
    setState(() {
      charge = true;
    });
    print(charge);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return !charge
        ? CircularProgressIndicator()
        : Stack(
            children: [
              GridView.builder(
                itemCount: myDataBase.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: mySetting.getColorPaper(),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InfoMyClass(
                                        number: myDataBase[index]['ID'])));
                            myDataBase = await myData.getClass(-1);
                            setState(() {
                              charge = true;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Hero(
                                  tag: "class_${myDataBase[index]['ID']}",
                                  child: Text(
                                    myDataBase[index]['Nombre'],
                                    style: TextStyle(
                                      color: mySetting.getColorText(),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Divider(
                                  color: mySetting.getColorText(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            iconSize: 20,
                            icon: Icon(Icons.phonelink_erase),
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (deviceWidth / 100).floor(),
                  mainAxisExtent: 150,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CreateClass()));
                    init();
                  },
                  style: ButtonStyle(
                    padding: const MaterialStatePropertyAll(EdgeInsets.all(8)),
                    shape: const MaterialStatePropertyAll(CircleBorder()),
                    backgroundColor: MaterialStatePropertyAll(
                        mySetting.getColorDrawerSecondary()),
                    iconColor:
                        MaterialStatePropertyAll(mySetting.getColorText()),
                    iconSize: const MaterialStatePropertyAll(40),
                  ),
                  child: const Icon(
                    Icons.add,
                  ),
                ),
              )
            ],
          );
  }
}
