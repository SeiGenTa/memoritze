import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MessageError extends StatefulWidget {
  String messageError;
  MessageError({super.key, required this.messageError});

  @override
  State<MessageError> createState() => _MessageErrorState();
}

class _MessageErrorState extends State<MessageError> {
  bool moreInfo = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      color: const Color.fromARGB(255, 18, 141, 22),
      child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  "Parece que hemos tenido un error cargando dato o creando nuestra base de datos"),
              IconButton(
                  onPressed: () => setState(() {
                        moreInfo = !moreInfo;
                      }),
                  icon: moreInfo
                      ? const Icon(Icons.arrow_drop_up)
                      : const Icon(Icons.arrow_drop_down)),
              if (moreInfo)
                SingleChildScrollView(
                  child: Text(widget.messageError),
                )
            ],
          )),
    );
  }
}
