import 'dart:io';

import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';

void launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void launchYT(url) async {
  if (Platform.isAndroid) {
    try {
      final AndroidIntent intent = AndroidIntent(
          action: 'ACTION_SEARCH',
          arguments: {"query": url},
           data: 'com.google.android.youtube');
           print(intent.toString());
      await intent.launch();
    } catch (error) {}
  }
}
