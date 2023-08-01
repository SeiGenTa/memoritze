// observer.dart

import 'dart:async';

class Observer {
  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  Stream<String> get onChanged => _controller.stream;

  void notify(String data) {
    _controller.add(data);
  }

  void dispose() {
    _controller.close();
  }
}
