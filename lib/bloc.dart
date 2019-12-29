
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


class Bloc {
  // UI Feedback Subjects
  final PublishSubject<String> snackBarSubject = PublishSubject<String>();

  //  some function that gets data from network
  Future<bool> getDataRequest() async {
    try {
      // get request code here
    } catch (error) {
      this.snackBarSubject.add(error);
    }
  }

  void addMessage(String msg) {
    this.snackBarSubject.add(msg);
  }

  @override
  void dispose() {
    snackBarSubject?.close();
    animationIndexController.close();
  }

   // stream to control the theme of the app
  BehaviorSubject<int> animationIndexController =
      BehaviorSubject<int>.seeded(1); //listen with multiple subjects
  Stream<int> get currentAnimIndex => animationIndexController.stream.asBroadcastStream();

}
