import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class UiErrorUtils {
  // opens snackbar
  void openSnackBar(BuildContext context, String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // subscribes to stream that triggers open snackbar
  void subscribeToSnackBarStream(
      BuildContext context, PublishSubject<String>? stream) {
    stream?.listen((String message) {
      openSnackBar(context, message);
    });
  }
}
