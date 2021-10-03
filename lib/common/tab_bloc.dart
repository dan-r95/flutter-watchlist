import 'dart:async';
import 'package:rxdart/rxdart.dart';

///
/// BloC pattern class containing streams and stream controllers which control the behaviour of
/// tabbed navigation, switching between tabs
///
class TabProvider {
  int _currentIndex = 0;

  void updateCurrentIndex(int index) {
    _currentIndex = index;
  }
}

class TabBloc {
  final indexController = BehaviorSubject<int>.seeded(0);
  TabProvider dropdownProvider = new TabProvider();
  Stream get getIndex => indexController.stream.asBroadcastStream();

  void updateIndex(int index) {
    dropdownProvider.updateCurrentIndex(index);
    indexController.sink.add(dropdownProvider._currentIndex);
  }

  void dispose() {
    indexController.close();
  }
}

final tabBloc = new TabBloc();
