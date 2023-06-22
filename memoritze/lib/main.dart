import 'package:flutter/material.dart';
import 'package:memoritze/partes/barraLeft.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Memoritze Demo'),
        ),
        drawer: const BarraLeft(),
        body: Center(
          child: Text('Hello '),
        ),
      ),
    );
  }
}
