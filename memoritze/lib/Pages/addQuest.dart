import 'package:flutter/material.dart';
import 'package:memoritze/setting.dart';

class AddQuest extends StatefulWidget {
  const AddQuest({super.key, required int id_class});

  @override
  State<AddQuest> createState() => _AddQuestState();
}

class _AddQuestState extends State<AddQuest> {
  Setting setting = Setting();

  TextEditingController nameMaterial = TextEditingController();

  late Widget myBody;

  void searchGalery() {}

  void configurativePage() {}

  void configureInitPage() {
    //Configure initial of page
    myBody = Column(
      children: [
        Row(
          children: [
            IconButton(
              iconSize: 40,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: setting.getColorText(),
              ),
            ),
            const Expanded(child: Text('')),
          ],
        ),
        //!Input de nombre materia
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return '¿Como sabremos que estamos estudiando?';
            }
            return null;
          },
          controller: nameMaterial,
          style: TextStyle(
            fontSize: 15,
            color: setting.getColorText(),
          ),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: setting.getColorText(),
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: setting.getColorText(),
              ),
            ),
            labelStyle: TextStyle(color: setting.getColorText()),
            hintStyle: TextStyle(color: setting.getColorText()),
            hintText: "Ejm: La peor materia :c",
            hoverColor: setting.getColorText(),
            labelText: "Nombre materia",
            icon: Icon(
              Icons.width_normal_rounded,
              color: setting.getColorText(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                  child: Divider(
                color: setting.getColorText(),
              )),
              CircleAvatar(
                backgroundColor: setting.getColorDrawerSecundary(),
                child: Text(
                  "1",
                  style: TextStyle(
                    color: setting.getColorText(),
                  ),
                ),
              ),
              Expanded(
                  child: Divider(
                color: setting.getColorText(),
              )),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    configureInitPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: setting.getBackgroundColor(),
        body: myBody,
      ),
    );
  }
}
