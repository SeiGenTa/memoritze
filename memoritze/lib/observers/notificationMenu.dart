// observer.dart

import 'dart:async';

class ObserverOnMenu {
  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  Stream<String> get onChanged => _controller.stream;

  void notify(String event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
