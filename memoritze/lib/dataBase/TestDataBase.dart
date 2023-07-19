import 'package:memoritze/dataBase/dbnew.dart';

void main(List<String> args) {
  var db = ConectioDataBase();
  db.init();
  db.getSetting();
}
