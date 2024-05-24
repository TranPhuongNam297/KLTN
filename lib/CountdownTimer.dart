import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer with ChangeNotifier {
  int remainingTime = 240; // 1 minute in seconds
  late Timer _timer;

  int get time => remainingTime;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
      } else {
        timer.cancel();
      }
      notifyListeners();
    });
  }

  void resetTimer() {
    remainingTime = 240;
    notifyListeners();
  }

  void stopTimer() {
    _timer.cancel();
  }
}
