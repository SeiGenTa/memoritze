import 'package:flutter/material.dart';

class BarraLeft extends StatelessWidget {
  const BarraLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      backgroundColor: Colors.blue,
      child: Column(
        children: [Text("data"), Expanded(child: Text('')), Text("Cosas")],
      ),
    );
  }
}
