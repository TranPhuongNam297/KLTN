import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer with ChangeNotifier {
  static const int _initialTime = 3600;
  int remainingTime = _initialTime;
  Timer? _timer;

  int get time => remainingTime;

  void startTimer() {
    // Prevent starting a new timer if one is already running
    if (_timer != null && _timer!.isActive) {
      return;
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
      } else {
        timer.cancel();
        remainingTime = 0;
      }
      notifyListeners();
    });
  }

  String get formattedTime {
    int hours = remainingTime ~/ 3600;
    int minutes = (remainingTime % 3600) ~/ 60;
    int seconds = remainingTime % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Duration get remainingDuration {
    return Duration(seconds: remainingTime);
  }

  void resetTimer() {
    remainingTime = _initialTime;
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
