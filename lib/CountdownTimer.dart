import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends ChangeNotifier {
  Duration remainingDuration;
  late Timer _timer;
  VoidCallback? onTimerEnd;

  CountdownTimer({required this.remainingDuration});

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
    return '${remainingDuration.inHours.toString().padLeft(2, '0')}:${remainingDuration.inMinutes.toString().padLeft(2, '0')}:${(remainingDuration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
