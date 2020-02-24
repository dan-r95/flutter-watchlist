import 'package:flutter_watchlist/common/types.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class Bloc {
  // UI Feedback Subjects
  final PublishSubject<String> snackBarSubject = PublishSubject<String>();

  //  some function that gets data from network
  getDataRequest() async {
    try {
      // get request code here
    } catch (error) {
      this.snackBarSubject.add(error);
    }
  }

  void addMessage(String msg) {
    this.snackBarSubject.add(msg);
  }

  void dispose() {
    snackBarSubject?.close();
    animationIndexController.close();
    brightnessController.close();
    alreadyWatchedListController.close();
    favoritesListController.close();
  }

  // stream to control the theme of the app
  BehaviorSubject<int> animationIndexController =
      BehaviorSubject<int>.seeded(1); //listen with multiple subjects
  Stream<int> get currentAnimIndex =>
      animationIndexController.stream.asBroadcastStream();

  // stream to control the theme of the app
  BehaviorSubject<Brightness> brightnessController =
      BehaviorSubject<Brightness>(); //listen with multiple subjects
  Stream<Brightness> get currentBrightness =>
      brightnessController.stream.asBroadcastStream();

  // stream to control the theme of the app
  BehaviorSubject<List<MovieSuggestion>> alreadyWatchedListController =
      BehaviorSubject<List<MovieSuggestion>>.seeded(
          List<MovieSuggestion>()); //listen with multiple subjects
  Stream<List<MovieSuggestion>> get alreadyWatchedList =>
      alreadyWatchedListController.stream.asBroadcastStream();
  StreamSink<List<MovieSuggestion>> get writeToalreadyWatched =>
      alreadyWatchedListController.sink;

  // stream to control the theme of the app
  BehaviorSubject<List<MovieSuggestion>> favoritesListController =
      BehaviorSubject<List<MovieSuggestion>>(); //listen with multiple subjects
  Stream<List<MovieSuggestion>> get favoritesList =>
      favoritesListController.stream.asBroadcastStream();

  StreamSink<List<MovieSuggestion>> get writeToFavorites =>
      favoritesListController.sink;
}

final bloc = Bloc();
