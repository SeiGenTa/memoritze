import 'dart:js_util';

import 'package:flutter_test/flutter_test.dart';
import 'package:memoritze/Settings.dart';
import 'package:memoritze/dataBase/db.dart';

void main() {
  test(
    "Test donde veremos el modo sigleton de Setting",
    () {
      Setting setting1 = Setting();
      Setting setting2 = Setting();
      expect(setting1.hashCode == setting2.hashCode, true);
    },
  );
  test("description", () async {
      ConnectionDataBase myData = ConnectionDataBase();
      Map<String, dynamic> prub = await myData.getSetting();
      expect(prub.length, 3);
      expect(typeofEquals(prub['NightMode'], "int"), true);
  });
}
