class Observer {
  void notification() {}
}

class Observable {
  List<Observer> observers = [];

  void addObserver(Observer obs) {
    observers.add(obs);
  }

  @override
  void notifier() {
    for (int i = 0; observers.length > i; i++) {
      observers[i].notification();
    }
  }
}
