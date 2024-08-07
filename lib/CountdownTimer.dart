import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends ChangeNotifier {
  Duration remainingDuration = Duration(minutes: 1);
  late Timer _timer;
  VoidCallback? onTimerEnd;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingDuration.inSeconds > 0) {
        remainingDuration = remainingDuration - Duration(seconds: 1);
        notifyListeners();
      } else {
        _timer.cancel();
        if (onTimerEnd != null) {
          onTimerEnd!();
        }
      }
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  String get formattedTime {
    return '${remainingDuration.inMinutes.toString().padLeft(2, '0')}:${(remainingDuration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
