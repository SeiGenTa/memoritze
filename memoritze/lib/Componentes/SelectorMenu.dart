import 'package:flutter/material.dart';

class Option2Menu extends StatelessWidget {
  final String msg;
  final void Function() onPressed;
  final Color color1;
  final Color color2;
  const Option2Menu({
    super.key,
    required this.msg,
    required this.onPressed,
    required this.color1,
    this.color2 = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black12)
        ),
        width: 260,
        height: 120,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              alignment: Alignment.centerRight,
              child: Text(
                msg,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Option1Menu extends StatelessWidget {
  final String msg;
  final void Function() onPressed;
  final Color color1;
  const Option1Menu({
    super.key,
    required this.msg,
    required this.onPressed,
    required this.color1,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color1, borderRadius: BorderRadius.circular(20)),
        width: 120,
        height: 120,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              alignment: Alignment.centerRight,
              child: Text(
                msg,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
